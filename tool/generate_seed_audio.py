#!/usr/bin/env python3
"""Generate high-fidelity studio-grade neural Portuguese audio assets for seed packs.

Uses Microsoft Neural Voices via `edge-tts` for 100% natural, human-sounding pronunciation:
- Brazilian Portuguese (PT-BR): `pt-BR-FranciscaNeural` (female), `pt-BR-AntonioNeural` (male)
- European Portuguese (PT-PT): `pt-PT-RaquelNeural` (female), `pt-PT-DuarteNeural` (male)

Normalizes volume with ffmpeg (loudnorm) and trims silence.
"""

from __future__ import annotations

import argparse
import asyncio
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SEED_DIR = ROOT / "assets" / "seed"
AUDIO_DIR = ROOT / "assets" / "audio"

FFMPEG_BIN = "/opt/homebrew/bin/ffmpeg" if os.path.exists("/opt/homebrew/bin/ffmpeg") else shutil.which("ffmpeg")

# Neural voices
VOICE_BR_FEMALE = "pt-BR-FranciscaNeural"
VOICE_BR_MALE = "pt-BR-AntonioNeural"
VOICE_PT_FEMALE = "pt-PT-RaquelNeural"
VOICE_PT_MALE = "pt-PT-DuarteNeural"


def select_voice(dialect: str, speaker_gender: str = "female") -> str:
    """Selects appropriate regional neural voice."""
    if dialect == "pt_pt":
        return VOICE_PT_MALE if speaker_gender == "male" else VOICE_PT_FEMALE
    return VOICE_BR_MALE if speaker_gender == "male" else VOICE_BR_FEMALE


async def synthesize_speech(text: str, voice: str, output_path: Path) -> bool:
    """Synthesizes text using edge-tts and post-processes with ffmpeg."""
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as tmp_file:
        tmp_path = Path(tmp_file.name)

    try:
        # 1. Generate via edge-tts CLI
        cmd = [
            sys.executable, "-m", "edge_tts",
            "--voice", voice,
            "--text", text,
            "--write-media", str(tmp_path),
        ]
        proc = await asyncio.create_subprocess_exec(
            *cmd,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        _, stderr = await proc.communicate()
        if proc.returncode != 0:
            print(f"  [ERROR] edge-tts failed: {stderr.decode()}", file=sys.stderr)
            return False

        # 2. Normalize with ffmpeg if available
        if FFMPEG_BIN and os.path.exists(FFMPEG_BIN):
            ffmpeg_cmd = [
                FFMPEG_BIN, "-y", "-i", str(tmp_path),
                "-af", "silenceremove=start_periods=1:start_duration=0.05:start_threshold=-50dB,"
                       "areverse,silenceremove=start_periods=1:start_duration=0.05:start_threshold=-50dB,areverse,"
                       "loudnorm=I=-16:TP=-1.5:LRA=11",
                "-b:a", "128k",
                str(output_path),
            ]
            ff_proc = await asyncio.create_subprocess_exec(
                *ffmpeg_cmd,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )
            await ff_proc.communicate()
        else:
            shutil.copy2(tmp_path, output_path)

        return True
    except Exception as e:
        print(f"  [ERROR] Exception synthesizing '{text[:30]}...': {e}", file=sys.stderr)
        return False
    finally:
        if tmp_path.exists():
            tmp_path.unlink()


async def generate_srs_audio():
    """Generates audio for SRS seed pack."""
    srs_file = SEED_DIR / "srs_seed.json"
    if not srs_file.exists():
        return

    with open(srs_file, "r", encoding="utf-8") as f:
        cards = json.load(f)

    print(f"--- Generating SRS Audio ({len(cards)} items) ---")
    modified = False
    for card in cards:
        card_id = card["id"]
        pt_text = card["portuguese"]
        dialect = card.get("dialect", "all")
        out_rel = f"assets/audio/srs/{card_id}.mp3"
        out_file = ROOT / out_rel

        if not out_file.exists() or out_file.stat().st_size < 100:
            voice = select_voice(dialect, "female")
            print(f"  Synthesizing SRS [{voice}]: {pt_text}")
            success = await synthesize_speech(pt_text, voice, out_file)
            if success:
                card["audio_url"] = out_rel
                modified = True
        else:
            card["audio_url"] = out_rel
            modified = True

    if modified:
        with open(srs_file, "w", encoding="utf-8") as f:
            json.dump(cards, f, indent=2, ensure_ascii=False)
        print("  Updated srs_seed.json with audio paths.")


async def generate_dialogues_audio():
    """Generates audio for dialogue scenario nodes."""
    diag_file = SEED_DIR / "dialogues_seed.json"
    if not diag_file.exists():
        return

    with open(diag_file, "r", encoding="utf-8") as f:
        nodes = json.load(f)

    print(f"\n--- Generating Dialogue Audio ({len(nodes)} nodes) ---")
    modified = False
    for node in nodes:
        node_id = node["id"]
        line_pt = node["line_portuguese"]
        dialect = node.get("dialect", "all")
        out_rel = f"assets/audio/dialogue/{node_id}.mp3"
        out_file = ROOT / out_rel

        if not out_file.exists() or out_file.stat().st_size < 100:
            voice = select_voice(dialect, "male" if "Garçom" in node.get("speaker_portuguese", "") or "Vendedor" in node.get("speaker_portuguese", "") else "female")
            print(f"  Synthesizing Dialogue [{voice}]: {line_pt}")
            success = await synthesize_speech(line_pt, voice, out_file)
            if success:
                node["audio_path"] = out_rel
                modified = True
        else:
            node["audio_path"] = out_rel
            modified = True

    if modified:
        with open(diag_file, "w", encoding="utf-8") as f:
            json.dump(nodes, f, indent=2, ensure_ascii=False)
        print("  Updated dialogues_seed.json with audio paths.")


async def generate_listening_audio():
    """Generates audio for listening dictation exercises."""
    list_file = SEED_DIR / "listening_seed.json"
    if not list_file.exists():
        return

    with open(list_file, "r", encoding="utf-8") as f:
        exercises = json.load(f)

    print(f"\n--- Generating Listening Audio ({len(exercises)} exercises) ---")
    modified = False
    for ex in exercises:
        ex_id = ex["id"]
        transcript = ex["transcript"]
        dialect = ex.get("dialect", "all")
        out_rel = f"assets/audio/listening/{ex_id}.mp3"
        out_file = ROOT / out_rel

        if not out_file.exists() or out_file.stat().st_size < 100:
            voice = select_voice(dialect, "female")
            print(f"  Synthesizing Listening [{voice}]: {transcript}")
            success = await synthesize_speech(transcript, voice, out_file)
            if success:
                ex["audio_url"] = out_rel
                modified = True
        else:
            ex["audio_url"] = out_rel
            modified = True

    if modified:
        with open(list_file, "w", encoding="utf-8") as f:
            json.dump(exercises, f, indent=2, ensure_ascii=False)
        print("  Updated listening_seed.json with audio paths.")


async def generate_slang_audio():
    """Generates audio for slang & idiom examples."""
    slang_file = SEED_DIR / "slang_seed.json"
    if not slang_file.exists():
        return

    with open(slang_file, "r", encoding="utf-8") as f:
        slang_list = json.load(f)

    print(f"\n--- Generating Slang Audio ({len(slang_list)} items) ---")
    for item in slang_list:
        slang_id = item["id"]
        sentence = item["example_sentence"]
        dialect = item.get("dialect", "all")
        out_rel = f"assets/audio/slang/{slang_id}.mp3"
        out_file = ROOT / out_rel

        if not out_file.exists() or out_file.stat().st_size < 100:
            voice = select_voice(dialect, "male")
            print(f"  Synthesizing Slang [{voice}]: {sentence}")
            await synthesize_speech(sentence, voice, out_file)


async def generate_dictionary_audio():
    """Generates neural audio for dictionary words."""
    dict_file = SEED_DIR / "dictionary_seed.json"
    if not dict_file.exists():
        return

    with open(dict_file, "r", encoding="utf-8") as f:
        entries = json.load(f)

    print(f"\n--- Generating Dictionary Audio ({len(entries)} items) ---")
    for entry in entries:
        entry_id = entry["id"]
        word = entry["word"].split("/")[0].strip()
        dialect = entry.get("dialect", "all")
        out_rel = f"assets/audio/dictionary/{entry_id}.mp3"
        out_file = ROOT / out_rel

        if not out_file.exists() or out_file.stat().st_size < 100:
            voice = select_voice(dialect, "female")
            print(f"  Synthesizing Dictionary [{voice}]: {word}")
            await synthesize_speech(word, voice, out_file)


async def main():
    parser = argparse.ArgumentParser(description="Generate natural neural Portuguese audio packs")
    parser.add_argument("--srs", action="store_true", help="Generate SRS audio")
    parser.add_argument("--dialogues", action="store_true", help="Generate Dialogue audio")
    parser.add_argument("--listening", action="store_true", help="Generate Listening audio")
    parser.add_argument("--slang", action="store_true", help="Generate Slang audio")
    parser.add_argument("--dictionary", action="store_true", help="Generate Dictionary audio")
    parser.add_argument("--all", action="store_true", help="Generate all audio packs")

    args = parser.parse_args()

    do_all = args.all or not (args.srs or args.dialogues or args.listening or args.slang or args.dictionary)

    if do_all or args.srs:
        await generate_srs_audio()
    if do_all or args.dialogues:
        await generate_dialogues_audio()
    if do_all or args.listening:
        await generate_listening_audio()
    if do_all or args.slang:
        await generate_slang_audio()
    if do_all or args.dictionary:
        await generate_dictionary_audio()

    print("\n[SUCCESS] Audio synthesis complete!")


if __name__ == "__main__":
    asyncio.run(main())
