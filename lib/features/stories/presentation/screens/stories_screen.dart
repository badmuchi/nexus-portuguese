import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/database/app_database.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  List<StoryRow> _stories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    final db = context.read<AppDatabase>();
    final list = await db.getAllStories();
    setState(() {
      _stories = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Истории и тексты'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stories.isEmpty
              ? const Center(child: Text('Истории пока не добавлены'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _stories.length,
                  itemBuilder: (context, index) {
                    final item = _stories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryDetailScreen(story: item),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item.coverIcon == 'wb_sunny_rounded'
                                          ? Icons.wb_sunny_rounded
                                          : Icons.storefront_rounded,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.titlePortuguese,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item.titleRussian,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.dialect == 'pt_br' ? 'PT-BR 🇧🇷' : 'PT-PT 🇵🇹',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(item.description, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final StoryRow story;
  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final Set<int> _revealedParagraphs = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();
    final paragraphs = (jsonDecode(widget.story.contentJson) as List<dynamic>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.titlePortuguese),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: paragraphs.length,
        itemBuilder: (context, index) {
          final p = paragraphs[index] as Map<String, dynamic>;
          final pt = p['portuguese'] as String? ?? '';
          final ru = p['russian'] as String? ?? '';
          final words = (p['words'] as List<dynamic>?) ?? [];
          final isRuRevealed = _revealedParagraphs.contains(index);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Абзац ${index + 1}',
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.saved_search_rounded),
                            visualDensity: VisualDensity.compact,
                            tooltip: 'X-Ray разбор фразы',
                            onPressed: () {
                              SentenceXRaySheet.show(
                                context,
                                sentencePortuguese: pt,
                                translationRussian: ru,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded),
                            visualDensity: VisualDensity.compact,
                            onPressed: () => audio.playAudioOrSpeak(fallbackText: pt),
                          ),
                          IconButton(
                            icon: Icon(isRuRevealed ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                            visualDensity: VisualDensity.compact,
                            tooltip: isRuRevealed ? 'Скрыть перевод' : 'Показать перевод',
                            onPressed: () {
                              setState(() {
                                if (isRuRevealed) {
                                  _revealedParagraphs.remove(index);
                                } else {
                                  _revealedParagraphs.add(index);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pt,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isRuRevealed) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        ru,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  if (words.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: words.map((w) {
                        final wordMap = w as Map<String, dynamic>;
                        final word = wordMap['word'] as String? ?? '';
                        final tr = wordMap['translation'] as String? ?? '';
                        return ActionChip(
                          avatar: const Icon(Icons.translate_rounded, size: 14),
                          label: Text('$word — $tr'),
                          onPressed: () => audio.playAudioOrSpeak(fallbackText: word),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
