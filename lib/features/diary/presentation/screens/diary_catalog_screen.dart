import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/speech/speech_recognition_service.dart';
import '../../domain/entities/diary_entry_entity.dart';
import '../../domain/repositories/diary_repository.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../widgets/diary_analysis_sheet.dart';
import '../widgets/diary_entry_card.dart';
import 'diary_editor_screen.dart';

class DiaryCatalogScreen extends StatelessWidget {
  const DiaryCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<DiaryRepository>();
    final speech = context.read<SpeechRecognitionService>();

    return BlocProvider<DiaryCubit>(
      create: (_) => DiaryCubit(
        repository: repository,
        speechService: speech,
      )..loadDiary(),
      child: const _DiaryCatalogView(),
    );
  }
}

class _DiaryCatalogView extends StatelessWidget {
  const _DiaryCatalogView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📖 Diário de Bordo'),
      ),
      body: BlocBuilder<DiaryCubit, DiaryState>(
        builder: (context, state) {
          if (state.status == DiaryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DiaryStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.errorMessage ?? 'Ошибка загрузки дневника'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<DiaryCubit>().loadDiary(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final cubit = context.read<DiaryCubit>();

          return Column(
            children: [
              _HeaderMotivationBanner(
                totalWords: state.totalWordCount,
                entriesCount: state.entries.length,
                theme: theme,
              ),
              if (state.prompts.isNotEmpty)
                _PromptOfTheDayBanner(
                  prompt: state.prompts.first,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: DiaryEditorScreen(initialPrompt: state.prompts.first),
                        ),
                      ),
                    );
                  },
                  theme: theme,
                ),
              Expanded(
                child: state.entries.isEmpty
                    ? _EmptyDiaryPlaceholder(
                        onStartFirstEntry: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: cubit,
                                child: const DiaryEditorScreen(),
                              ),
                            ),
                          );
                        },
                        theme: theme,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.entries.length,
                        itemBuilder: (context, index) {
                          final entry = state.entries[index];
                          return DiaryEntryCard(
                            entry: entry,
                            onTap: () => DiaryAnalysisSheet.show(context, entry: entry),
                            onDelete: () => _confirmDelete(context, cubit, entry),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final cubit = context.read<DiaryCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const DiaryEditorScreen(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('Новая запись'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DiaryCubit cubit, DiaryEntryEntity entry) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Удалить запись?'),
        content: const Text('Эта запись дневника будет безвозвратно удалена.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              cubit.deleteEntry(entry.id);
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}

class _HeaderMotivationBanner extends StatelessWidget {
  final int totalWords;
  final int entriesCount;
  final ThemeData theme;

  const _HeaderMotivationBanner({
    required this.totalWords,
    required this.entriesCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.history_edu_rounded, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '«Navegar é preciso...»',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Практика свободного письма и речи',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalWords слов',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '$entriesCount записей',
                style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PromptOfTheDayBanner extends StatelessWidget {
  final dynamic prompt; // DiaryPrompt
  final VoidCallback onTap;
  final ThemeData theme;

  const _PromptOfTheDayBanner({
    required this.prompt,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.amber.shade700),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тема дня: ${prompt.questionPt}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      prompt.questionRu,
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.outline),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDiaryPlaceholder extends StatelessWidget {
  final VoidCallback onStartFirstEntry;
  final ThemeData theme;

  const _EmptyDiaryPlaceholder({
    required this.onStartFirstEntry,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Ваш дневник пока пуст',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Напишите о том, как прошел день, о планах на поездку в Лиссабон или Рио. AI-тьютор разберет грамматику и подскажет новые слова!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onStartFirstEntry,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Сделать первую запись'),
            ),
          ],
        ),
      ),
    );
  }
}
