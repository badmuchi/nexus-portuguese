import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/portuguese_life_scene.dart';
import '../cubit/scenes_cubit.dart';
import '../cubit/scenes_state.dart';
import '../widgets/scene_challenge_card.dart';
import '../widgets/scene_phrase_tile.dart';
import '../widgets/scene_word_card.dart';

class SceneDetailScreen extends StatefulWidget {
  final PortugueseLifeScene scene;

  const SceneDetailScreen({super.key, required this.scene});

  @override
  State<SceneDetailScreen> createState() => _SceneDetailScreenState();
}

class _SceneDetailScreenState extends State<SceneDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final Set<String> _solvedChallengeIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onChallengeSolved(String challengeId) {
    setState(() {
      _solvedChallengeIds.add(challengeId);
    });

    context.read<ScenesCubit>().recordChallengeCompleted(
          sceneId: widget.scene.id,
          completedCount: _solvedChallengeIds.length,
          totalCount: widget.scene.challenges.length,
        );
  }

  @override
  Widget build(BuildContext context) {
    final scene = widget.scene;

    return BlocBuilder<ScenesCubit, ScenesState>(
      builder: (context, state) {
        final progress = (state is ScenesLoaded) ? state.progressMap[scene.id] : null;
        final isDone = progress?.isCompleted ?? false;

        return Scaffold(
          appBar: AppBar(
            title: Text(scene.titlePt),
            actions: [
              if (isDone)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.check_circle_rounded, color: Colors.green),
                ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: const Icon(Icons.forum_outlined, size: 20),
                  text: 'Реплики (${scene.phrases.length})',
                ),
                Tab(
                  icon: const Icon(Icons.style_outlined, size: 20),
                  text: 'Слова (${scene.words.length})',
                ),
                Tab(
                  icon: const Icon(Icons.quiz_outlined, size: 20),
                  text: 'Челленджи (${scene.challenges.length})',
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              _CulturalTipBanner(tip: scene.culturalTip),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _PhrasesTab(phrases: scene.phrases),
                    _WordsTab(words: scene.words),
                    _ChallengesTab(
                      challenges: scene.challenges,
                      solvedIds: _solvedChallengeIds,
                      onSolved: _onChallengeSolved,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CulturalTipBanner extends StatelessWidget {
  final CulturalTip tip;

  const _CulturalTipBanner({required this.tip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.35),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tip.countryFlag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Dica Cultural: ${tip.title}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.bodyRu,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhrasesTab extends StatelessWidget {
  final List<ScenePhrase> phrases;

  const _PhrasesTab({required this.phrases});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        return ScenePhraseTile(phrase: phrases[index]);
      },
    );
  }
}

class _WordsTab extends StatelessWidget {
  final List<SceneWord> words;

  const _WordsTab({required this.words});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: words.length,
      itemBuilder: (context, index) {
        return SceneWordCard(word: words[index]);
      },
    );
  }
}

class _ChallengesTab extends StatelessWidget {
  final List<SceneChallenge> challenges;
  final Set<String> solvedIds;
  final ValueChanged<String> onSolved;

  const _ChallengesTab({
    required this.challenges,
    required this.solvedIds,
    required this.onSolved,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        final isSolved = solvedIds.contains(challenge.id);

        return SceneChallengeCard(
          challenge: challenge,
          isInitiallySolved: isSolved,
          onSolved: () => onSolved(challenge.id),
        );
      },
    );
  }
}
