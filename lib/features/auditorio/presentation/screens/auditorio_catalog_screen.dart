import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auditorio_repository.dart';
import '../cubit/auditorio_catalog_cubit.dart';
import '../cubit/auditorio_catalog_state.dart';
import '../widgets/podcast_card.dart';
import 'podcast_player_screen.dart';

class AuditorioCatalogScreen extends StatelessWidget {
  const AuditorioCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuditorioCatalogCubit>(
      create: (context) => AuditorioCatalogCubit(
        repository: context.read<AuditorioRepository>(),
      )..loadCatalog(),
      child: const _AuditorioCatalogView(),
    );
  }
}

class _AuditorioCatalogView extends StatelessWidget {
  const _AuditorioCatalogView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🎧 Auditório & Shadowing'),
          ],
        ),
      ),
      body: BlocBuilder<AuditorioCatalogCubit, AuditorioCatalogState>(
        builder: (context, state) {
          if (state.status == AuditorioCatalogStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AuditorioCatalogStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.errorMessage ?? 'Произошла ошибка при загрузке подкастов'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<AuditorioCatalogCubit>().loadCatalog(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final cubit = context.read<AuditorioCatalogCubit>();

          return Column(
            children: [
              _HeaderStatsBanner(
                completedCount: state.completedCount,
                totalCount: state.allTracks.length,
                theme: theme,
              ),
              _SearchBarSection(
                onSearch: (q) => cubit.search(q),
                theme: theme,
              ),
              _FilterChipsRow(
                selectedDialect: state.selectedDialect,
                selectedCefr: state.selectedCefr,
                onDialectSelected: (d) => cubit.filterByDialect(d),
                onCefrSelected: (c) => cubit.filterByCefr(c),
                theme: theme,
              ),
              const Divider(height: 1),
              Expanded(
                child: state.filteredTracks.isEmpty
                    ? _EmptyTracksPlaceholder(theme: theme)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.filteredTracks.length,
                        itemBuilder: (context, index) {
                          final track = state.filteredTracks[index];
                          return PodcastCard(
                            track: track,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PodcastPlayerScreen(track: track),
                                ),
                              );
                              if (context.mounted) {
                                cubit.loadCatalog();
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderStatsBanner extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final ThemeData theme;

  const _HeaderStatsBanner({
    required this.completedCount,
    required this.totalCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
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
                child: const Icon(Icons.record_voice_over_rounded, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Погружение в живую речь',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Синхронный текст, тайминги и теневой повтор',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Text(
              '$completedCount / $totalCount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarSection extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final ThemeData theme;

  const _SearchBarSection({
    required this.onSearch,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Поиск по теме, автору или городу...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  final String selectedDialect;
  final String selectedCefr;
  final ValueChanged<String> onDialectSelected;
  final ValueChanged<String> onCefrSelected;
  final ThemeData theme;

  const _FilterChipsRow({
    required this.selectedDialect,
    required this.selectedCefr,
    required this.onDialectSelected,
    required this.onCefrSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          _ChoiceFilterChip(
            label: 'Все диалекты',
            isSelected: selectedDialect == 'all',
            onSelected: (_) => onDialectSelected('all'),
          ),
          const SizedBox(width: 6),
          _ChoiceFilterChip(
            label: '🇧🇷 PT-BR',
            isSelected: selectedDialect == 'pt_BR',
            onSelected: (_) => onDialectSelected('pt_BR'),
          ),
          const SizedBox(width: 6),
          _ChoiceFilterChip(
            label: '🇵🇹 PT-PT',
            isSelected: selectedDialect == 'pt_PT',
            onSelected: (_) => onDialectSelected('pt_PT'),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: theme.colorScheme.outlineVariant),
          const SizedBox(width: 12),
          _ChoiceFilterChip(
            label: 'Все уровни',
            isSelected: selectedCefr == 'all',
            onSelected: (_) => onCefrSelected('all'),
          ),
          const SizedBox(width: 6),
          _ChoiceFilterChip(
            label: 'A1-A2',
            isSelected: selectedCefr == 'A1' || selectedCefr == 'A2',
            onSelected: (_) => onCefrSelected('A2'),
          ),
          const SizedBox(width: 6),
          _ChoiceFilterChip(
            label: 'B1-B2',
            isSelected: selectedCefr == 'B1' || selectedCefr == 'B2',
            onSelected: (_) => onCefrSelected('B1'),
          ),
        ],
      ),
    );
  }
}

class _ChoiceFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _ChoiceFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: onSelected,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EmptyTracksPlaceholder extends StatelessWidget {
  final ThemeData theme;
  const _EmptyTracksPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.headphones_outlined, size: 54, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            'Подкасты не найдены',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Попробуйте сбросить фильтры поиска',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
