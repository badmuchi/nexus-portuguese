import 'package:flutter/material.dart';
import '../../domain/entities/diary_prompt_entity.dart';

class PromptSelectorSheet extends StatelessWidget {
  final List<DiaryPrompt> prompts;
  final DiaryPrompt? selectedPrompt;
  final ValueChanged<DiaryPrompt?> onSelectPrompt;

  const PromptSelectorSheet({
    super.key,
    required this.prompts,
    required this.selectedPrompt,
    required this.onSelectPrompt,
  });

  static void show(
    BuildContext context, {
    required List<DiaryPrompt> prompts,
    required DiaryPrompt? selectedPrompt,
    required ValueChanged<DiaryPrompt?> onSelectPrompt,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PromptSelectorSheet(
        prompts: prompts,
        selectedPrompt: selectedPrompt,
        onSelectPrompt: onSelectPrompt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DragHandle(theme: theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_rounded, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Темы для записи дня',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (selectedPrompt != null)
                TextButton(
                  onPressed: () {
                    onSelectPrompt(null);
                    Navigator.pop(context);
                  },
                  child: const Text('Сбросить'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 380,
            child: ListView.builder(
              itemCount: prompts.length,
              itemBuilder: (context, index) {
                final p = prompts[index];
                final isSelected = p.id == selectedPrompt?.id;

                return _PromptCardTile(
                  prompt: p,
                  isSelected: isSelected,
                  onTap: () {
                    onSelectPrompt(p);
                    Navigator.pop(context);
                  },
                  theme: theme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  final ThemeData theme;
  const _DragHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _PromptCardTile extends StatelessWidget {
  final DiaryPrompt prompt;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _PromptCardTile({
    required this.prompt,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
            : theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      prompt.category,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'CEFR ${prompt.difficultyCefr}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                prompt.questionPt,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                prompt.questionRu,
                style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
              ),
              if (prompt.hintWords.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: prompt.hintWords.map((w) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
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
      ),
    );
  }
}
