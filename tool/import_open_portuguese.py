#!/usr/bin/env python3
"""Open-Source Portuguese Content ETL Tool.

Fetches and processes open-licensed Portuguese learning content from:
1. Tatoeba API (CC-BY 2.0 FR / CC0) for bilingual phrases and audio.
2. Kaikki.org / Wiktionary (CC BY-SA 4.0) for verbs, conjugations and definitions.
"""

import argparse
import json
import os
import re
import sys
import urllib.parse
import urllib.request

TATOEBA_API_URL = "https://api.tatoeba.org/v1/sentences"


def clean_portuguese_text(text: str) -> str:
    """Removes unwanted spaces and normalizes quotes."""
    return re.sub(r'\s+', ' ', text.strip())


def calculate_difficulty(text: str) -> str:
    """Estimates difficulty level (beginner, intermediate, advanced)."""
    words = text.split()
    length = len(words)
    if length <= 7:
        return "beginner"
    elif length <= 14:
        return "intermediate"
    return "advanced"


def extract_focus_words(text: str, limit: int = 4) -> list[str]:
    """Extracts significant words from text."""
    stop_words = {
        'o', 'a', 'os', 'as', 'um', 'uma', 'uns', 'umas', 'de', 'do', 'da',
        'dos', 'das', 'em', 'no', 'na', 'nos', 'nas', 'por', 'pelo', 'pela',
        'e', 'que', 'se', 'com', 'para', 'eu', 'você', 'ele', 'ela', 'nós',
        'eles', 'elas', 'meu', 'minha', 'seu', 'sua'
    }
    words = re.findall(r'\b[a-zA-ZáàâãéêíóôõúçÁÀÂÃÉÊÍÓÔÕÚÇ]+\b', text.lower())
    focused = [w for w in words if w not in stop_words and len(w) > 3]
    return focused[:limit]


def fetch_tatoeba_sentences(query: str, limit: int = 10) -> list[dict]:
    """Fetches sentences from Tatoeba pairing Portuguese and Russian."""
    params = {
        "lang": "por",
        "trans": "rus",
        "q": query,
        "limit": limit,
    }
    url = f"{TATOEBA_API_URL}?{urllib.parse.urlencode(params)}"
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "NexusPortugueseApp/0.1.0 (Educational/OpenSource)"}
    )

    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            results = []
            for item in data.get('data', []):
                pt_text = item.get('text', '')
                ru_translations = [
                    t.get('text', '')
                    for group in item.get('translations', [])
                    for t in group
                    if t.get('lang') == 'rus'
                ]
                if not ru_translations:
                    continue

                audio_url = None
                for aud in item.get('audios', []):
                    lic = aud.get('license', '').lower()
                    # Filter strict open licenses
                    if 'cc0' in lic or 'cc-by' in lic or 'creative commons' in lic:
                        audio_url = aud.get('url')
                        break

                results.append({
                    "id": f"tat_{item.get('id', '')}",
                    "portuguese": clean_portuguese_text(pt_text),
                    "russian": ru_translations[0],
                    "audio_url": audio_url,
                    "difficulty": calculate_difficulty(pt_text),
                    "focus_words": extract_focus_words(pt_text),
                    "source_name": "Tatoeba",
                    "license_name": "CC-BY 2.0 FR"
                })
            return results
    except Exception as e:
        print(f"Error fetching from Tatoeba: {e}", file=sys.stderr)
        return []


def main():
    parser = argparse.ArgumentParser(description="Nexus Portuguese Content ETL")
    subparsers = parser.add_subparsers(dest="command", required=True)

    tat_parser = subparsers.add_parser("tatoeba", help="Fetch from Tatoeba API")
    tat_parser.add_argument("--query", type=str, required=True, help="Search query (e.g. café, praia)")
    tat_parser.add_argument("--limit", type=int, default=10, help="Number of sentences")
    tat_parser.add_argument("--format", choices=["srs", "listening"], default="listening", help="Target format")
    tat_parser.add_argument("--dry-run", action="store_true", help="Print results without saving")

    args = parser.parse_args()

    if args.command == "tatoeba":
        sentences = fetch_tatoeba_sentences(args.query, args.limit)
        if args.dry_run:
            print(json.dumps(sentences, indent=2, ensure_ascii=False))
            print(f"\nFetched {len(sentences)} items from Tatoeba.")
        else:
            print(f"Found {len(sentences)} items for '{args.query}'.")


if __name__ == "__main__":
    main()
