import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/portuguese_song_entity.dart';
import '../../domain/repositories/music_repository.dart';
import '../cubit/music_catalog_cubit.dart';
import '../cubit/music_catalog_state.dart';
import '../cubit/song_player_cubit.dart';
import '../widgets/song_card.dart';
import 'song_player_screen.dart';

class MusicCatalogScreen extends StatelessWidget {
  const MusicCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicCatalogCubit(
        repository: context.read<MusicRepository>(),
      )..loadSongs(),
      child: const _MusicCatalogView(),
    );
  }
}

class _MusicCatalogView extends StatelessWidget {
  const _MusicCatalogView();

  void _openSong(BuildContext context, PortugueseSong song) {
    final musicRepo = context.read<MusicRepository>();
    final audioService = context.read<HybridAudioPlaybackService>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => SongPlayerCubit(
            song: song,
            repository: musicRepo,
            audioService: audioService,
          ),
          child: const SongPlayerScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Trilha Sonora da Língua'),
            SizedBox(width: 8),
            Text('🎶', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          _SearchBarAndFilters(theme: theme),
          Expanded(
            child: BlocBuilder<MusicCatalogCubit, MusicCatalogState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.music_off_rounded, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(state.errorMessage!),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.read<MusicCatalogCubit>().loadSongs(),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                final songs = state.filteredSongs;
                if (songs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Песни не найдены',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Попробуй изменить поисковый запрос или фильтр жанров',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return SongCard(
                      song: song,
                      onTap: () => _openSong(context, song),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarAndFilters extends StatelessWidget {
  final ThemeData theme;

  const _SearchBarAndFilters({required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicCatalogCubit, MusicCatalogState>(
      builder: (context, state) {
        final cubit = context.read<MusicCatalogCubit>();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                onChanged: cubit.searchSongs,
                decoration: InputDecoration(
                  hintText: 'Поиск песни, артиста или строки...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => cubit.searchSongs(''),
                        )
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Все жанры'),
                    selected: state.selectedGenre == null,
                    onSelected: (_) => cubit.filterByGenre(null),
                  ),
                  const SizedBox(width: 8),
                  ...MusicGenre.values.map((genre) {
                    final isSelected = state.selectedGenre == genre;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('${genre.emoji} ${genre.labelPt}'),
                        selected: isSelected,
                        onSelected: (_) => cubit.filterByGenre(isSelected ? null : genre),
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('🇧🇷 Brasil'),
                    selected: state.selectedDialect == 'pt_BR',
                    onSelected: (selected) => cubit.filterByDialect(selected ? 'pt_BR' : 'all'),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('🇵🇹 Portugal'),
                    selected: state.selectedDialect == 'pt_PT',
                    onSelected: (selected) => cubit.filterByDialect(selected ? 'pt_PT' : 'all'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
