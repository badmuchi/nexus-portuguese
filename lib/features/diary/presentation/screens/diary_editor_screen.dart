import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/diary_prompt_entity.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../widgets/diary_analysis_sheet.dart';
import '../widgets/prompt_selector_sheet.dart';

class DiaryEditorScreen extends StatefulWidget {
  final DiaryPrompt? initialPrompt;

  const DiaryEditorScreen({
    super.key,
    this.initialPrompt,
  });

  @override
  State<DiaryEditorScreen> createState() => _DiaryEditorScreenState();
}

class _DiaryEditorScreenState extends State<DiaryEditorScreen> {
  final _textController = TextEditingController();
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null) {
      context.read<DiaryCubit>().selectPrompt(widget.initialPrompt);
    }
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _textController.text.trim();
    final words = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    if (words != _wordCount) {
      setState(() => _wordCount = words);
    }
  }

  void _insertCharacter(String char) {
    HapticFeedback.selectionClick();
    final text = _textController.text;
    final selection = _textController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;

    final newText = text.replaceRange(start, end, char);
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + char.length),
    );
  }

  Future<void> _handleSave() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Напишите хотя бы пару слов перед сохранением.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    final cubit = context.read<DiaryCubit>();
    final prompt = cubit.state.selectedPrompt;

    final success = await cubit.saveEntry(text: text, prompt: prompt);
    if (success && mounted) {
      final savedEntry = cubit.state.entries.first;
      Navigator.pop(context);

      // Сразу показываем детальный анализ сохраненной записи
      DiaryAnalysisSheet.show(context, entry: savedEntry);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<DiaryCubit, DiaryState>(
      builder: (context, state) {
        final cubit = context.read<DiaryCubit>();
        final prompt = state.selectedPrompt;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Новая запись в дневник'),
            actions: [
              TextButton.icon(
                onPressed: state.status == DiaryStatus.loading ? null : _handleSave,
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('Готово'),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PromptSelectionCard(
                        prompt: prompt,
                        onOpenSelector: () {
                          PromptSelectorSheet.show(
                            context,
                            prompts: state.prompts,
                            selectedPrompt: prompt,
                            onSelectPrompt: (p) => cubit.selectPrompt(p),
                          );
                        },
                        theme: theme,
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _textController,
                        maxLines: 12,
                        minLines: 6,
                        autofocus: true,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                        decoration: InputDecoration(
                          hintText: 'Escreva em português sobre o seu dia...',
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerLowest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _StatsAndVoiceRow(
                        wordCount: _wordCount,
                        isRecording: state.isRecording,
                        onToggleVoice: () {
                          if (state.isRecording) {
                            cubit.stopVoiceInput();
                          } else {
                            cubit.startVoiceInput(onRecognized: (recognized) {
                              _textController.text =
                                  '${_textController.text} $recognized'.trim();
                            });
                          }
                        },
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ),
              _PortugueseDiacriticsBar(
                onCharSelected: _insertCharacter,
                theme: theme,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PromptSelectionCard extends StatelessWidget {
  final DiaryPrompt? prompt;
  final VoidCallback onOpenSelector;
  final ThemeData theme;

  const _PromptSelectionCard({
    required this.prompt,
    required this.onOpenSelector,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (prompt == null) {
      return OutlinedButton.icon(
        onPressed: onOpenSelector,
        icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
        label: const Text('Выбрать тему дня для вдохновения 💡'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prompt!.questionPt,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  prompt!.questionRu,
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                ),
                if (prompt!.hintWords.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: prompt!.hintWords.map((w) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          w,
                          style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: onOpenSelector,
          ),
        ],
      ),
    );
  }
}

class _StatsAndVoiceRow extends StatelessWidget {
  final int wordCount;
  final bool isRecording;
  final VoidCallback onToggleVoice;
  final ThemeData theme;

  const _StatsAndVoiceRow({
    required this.wordCount,
    required this.isRecording,
    required this.onToggleVoice,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.format_size_rounded, size: 16, color: theme.colorScheme.outline),
            const SizedBox(width: 4),
            Text(
              '$wordCount слов',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        FilledButton.tonalIcon(
          onPressed: onToggleVoice,
          style: FilledButton.styleFrom(
            backgroundColor: isRecording ? Colors.red.shade100 : null,
            foregroundColor: isRecording ? Colors.red.shade900 : null,
          ),
          icon: Icon(isRecording ? Icons.stop_rounded : Icons.mic_rounded, size: 18),
          label: Text(isRecording ? 'Остановить' : 'Надиктовать'),
        ),
      ],
    );
  }
}

class _PortugueseDiacriticsBar extends StatelessWidget {
  final ValueChanged<String> onCharSelected;
  final ThemeData theme;

  static const _characters = ['ã', 'õ', 'ç', 'á', 'é', 'í', 'ó', 'ú', 'â', 'ê', 'à'];

  const _PortugueseDiacriticsBar({
    required this.onCharSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: EdgeInsets.only(
        top: 6,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 6 : 24,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: _characters.map((ch) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onCharSelected(ch),
                child: Container(
                  width: 36,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ch,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
