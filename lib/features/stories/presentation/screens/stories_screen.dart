import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import 'package:nexus_portuguese_app/features/morphology/presentation/widgets/sentence_xray_sheet.dart';
import '../../domain/entities/story_entity.dart';
import '../cubit/stories_cubit.dart';
import '../cubit/stories_state.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoriesCubit>().loadStories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Истории и тексты'),
      ),
      body: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          if (state is StoriesLoading || state is StoriesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<StoriesCubit>().loadStories(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is StoriesLoaded) {
            final stories = state.stories;
            if (stories.isEmpty) {
              return const Center(child: Text('Истории пока не добавлены'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final item = stories[index];
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
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final StoryEntity story;
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
    final paragraphs = widget.story.paragraphs;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.titlePortuguese),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: paragraphs.length,
        itemBuilder: (context, index) {
          final p = paragraphs[index];
          final pt = p.portuguese;
          final ru = p.russian;
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
                  const SizedBox(height: 8),
                  Text(
                    pt,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  if (isRuRevealed) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ru,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
