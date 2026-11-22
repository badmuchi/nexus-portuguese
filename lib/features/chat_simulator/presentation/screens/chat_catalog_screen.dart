import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/core/audio/hybrid_audio_playback_service.dart';
import '../../domain/entities/chat_scenario_entity.dart';
import '../../domain/repositories/chat_simulator_repository.dart';
import '../cubit/chat_catalog_cubit.dart';
import '../cubit/chat_catalog_state.dart';
import '../cubit/chat_conversation_cubit.dart';
import '../widgets/chat_scenario_card.dart';
import 'chat_room_screen.dart';

class ChatCatalogScreen extends StatelessWidget {
  const ChatCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCatalogCubit(
        repository: context.read<ChatSimulatorRepository>(),
      )..loadCatalog(),
      child: const _ChatCatalogView(),
    );
  }
}

class _ChatCatalogView extends StatelessWidget {
  const _ChatCatalogView();

  void _openScenario(BuildContext context, ChatScenarioEntity scenario) {
    final repo = context.read<ChatSimulatorRepository>();
    final audio = context.read<HybridAudioPlaybackService>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ChatConversationCubit(
            scenario: scenario,
            repository: repo,
            audioService: audio,
          ),
          child: const ChatRoomScreen(),
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
            Text('Simulador de Redes'),
            SizedBox(width: 8),
            Text('💬', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          _SearchBarAndFilters(theme: theme),
          Expanded(
            child: BlocBuilder<ChatCatalogCubit, ChatCatalogState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(state.errorMessage!),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.read<ChatCatalogCubit>().loadCatalog(),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                final scenarios = state.filteredScenarios;
                if (scenarios.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'Сценарии не найдены',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Попробуй изменить поисковый запрос или фильтр диалекта',
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
                  itemCount: scenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = scenarios[index];
                    return ChatScenarioCard(
                      scenario: scenario,
                      onTap: () => _openScenario(context, scenario),
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
    return BlocBuilder<ChatCatalogCubit, ChatCatalogState>(
      builder: (context, state) {
        final cubit = context.read<ChatCatalogCubit>();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                onChanged: cubit.searchScenarios,
                decoration: InputDecoration(
                  hintText: 'Поиск сценария, контакта или ситуации...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () => cubit.searchScenarios(''),
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
                    label: const Text('Все диалекты'),
                    selected: state.selectedDialect == 'all',
                    onSelected: (_) => cubit.filterByDialect('all'),
                  ),
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
