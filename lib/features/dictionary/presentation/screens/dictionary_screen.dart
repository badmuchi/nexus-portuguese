import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/dictionary_entry_entity.dart';
import '../cubit/dictionary_cubit.dart';
import '../cubit/dictionary_state.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DictionaryCubit>().loadDictionary();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddWordDialog(BuildContext context) {
    final wordController = TextEditingController();
    final translationController = TextEditingController();
    final exampleController = TextEditingController();
    String selectedPos = 'noun';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Добавить слово в словарь'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: wordController,
                      decoration: const InputDecoration(labelText: 'Слово на португальском'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: translationController,
                      decoration: const InputDecoration(labelText: 'Перевод на русский'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPos,
                      decoration: const InputDecoration(labelText: 'Часть речи'),
                      items: const [
                        DropdownMenuItem(value: 'noun', child: Text('Существительное (substantivo)')),
                        DropdownMenuItem(value: 'verb', child: Text('Глагол (verbo)')),
                        DropdownMenuItem(value: 'adjective', child: Text('Прилагательное (adjetivo)')),
                        DropdownMenuItem(value: 'phrase', child: Text('Фраза / Выражение (expressão)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedPos = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: exampleController,
                      decoration: const InputDecoration(labelText: 'Пример использования (необязательно)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Отмена'),
                ),
                FilledButton(
                  onPressed: () {
                    final word = wordController.text.trim();
                    final tr = translationController.text.trim();
                    if (word.isEmpty || tr.isEmpty) return;

                    final newEntry = DictionaryEntryEntity(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      word: word,
                      partOfSpeech: selectedPos,
                      translationRu: tr,
                      frequencyRank: 9999,
                      dialect: 'all',
                      examplePt: exampleController.text.trim().isEmpty ? null : exampleController.text.trim(),
                      isCustom: true,
                    );

                    context.read<DictionaryCubit>().addWord(newEntry);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Сохранить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Словарь'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWordDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Добавить слово'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск слова или перевода...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          context.read<DictionaryCubit>().search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onChanged: (val) => context.read<DictionaryCubit>().search(val),
            ),
          ),
          BlocBuilder<DictionaryCubit, DictionaryState>(
            builder: (context, state) {
              final selected = state is DictionaryLoaded ? state.selectedFilter : 'all';
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _filterChip(context, 'Все', 'all', selected),
                    const SizedBox(width: 8),
                    _filterChip(context, 'Глаголы', 'verb', selected),
                    const SizedBox(width: 8),
                    _filterChip(context, 'Существительные', 'noun', selected),
                    const SizedBox(width: 8),
                    _filterChip(context, 'Прилагательные', 'adjective', selected),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<DictionaryCubit, DictionaryState>(
              builder: (context, state) {
                if (state is DictionaryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DictionaryError) {
                  return Center(
                    child: Text(state.message, style: TextStyle(color: theme.colorScheme.error)),
                  );
                }

                if (state is DictionaryLoaded) {
                  final list = state.filteredEntries;

                  if (list.isEmpty) {
                    return const Center(child: Text('Ничего не найдено'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        title: Row(
                          children: [
                            Text(
                              item.word,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.partOfSpeech,
                                style: TextStyle(fontSize: 10, color: theme.colorScheme.outline),
                              ),
                            ),
                            if (item.isCustom) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                            ],
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(item.translationRu, style: theme.textTheme.bodyMedium),
                            if (item.examplePt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.examplePt!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.volume_up_rounded),
                          onPressed: () => context.read<DictionaryCubit>().playWord(item.word),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, String value, String selected) {
    return FilterChip(
      label: Text(label),
      selected: selected == value,
      onSelected: (_) => context.read<DictionaryCubit>().filterPart(value),
    );
  }
}
