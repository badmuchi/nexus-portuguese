import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../cubit/slang_cubit.dart';
import '../cubit/slang_state.dart';

class SlangScreen extends StatefulWidget {
  const SlangScreen({super.key});

  @override
  State<SlangScreen> createState() => _SlangScreenState();
}

class _SlangScreenState extends State<SlangScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SlangCubit>().loadSlang();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = context.read<HybridAudioPlaybackService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сленг и идиомы (Gírias)'),
      ),
      body: BlocBuilder<SlangCubit, SlangState>(
        builder: (context, state) {
          if (state is SlangLoading || state is SlangInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SlangError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<SlangCubit>().loadSlang(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is SlangLoaded) {
            final slangList = state.slangList;
            if (slangList.isEmpty) {
              return const Center(child: Text('Сленг пока не добавлен'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: slangList.length,
              itemBuilder: (context, index) {
                final item = slangList[index];

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
                            Expanded(
                              child: Text(
                                item.expression,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.dialect == 'pt_br'
                                    ? 'PT-BR 🇧🇷'
                                    : item.dialect == 'pt_pt'
                                        ? 'PT-PT 🇵🇹'
                                        : 'BR/PT 🇧🇷🇵🇹',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Буквально: «${item.literalTranslation}»',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Значение: ${item.actualMeaning}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.history_edu_rounded, size: 16, color: Colors.amber),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Происхождение:',
                                    style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(item.originNotes, style: theme.textTheme.bodySmall),
                              const SizedBox(height: 8),
                              const Divider(height: 1),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.exampleSentence,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          item.exampleTranslation,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.volume_up_rounded),
                                    onPressed: () => audio.playAudioOrSpeak(fallbackText: item.exampleSentence),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
