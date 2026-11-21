import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_portuguese_app/features/verb_trainer/presentation/screens/verb_trainer_screen.dart';
import '../cubit/grammar_cubit.dart';
import '../cubit/grammar_state.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GrammarCubit>().loadGrammarData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Грамматика'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bolt_rounded, color: Colors.amber),
              tooltip: 'VerboSprint: Тренажёр спряжений',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VerbTrainerScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(icon: Icon(Icons.table_chart_rounded), text: 'Спряжения'),
              Tab(icon: Icon(Icons.link_rounded), text: 'Слияния (do/no/à)'),
              Tab(icon: Icon(Icons.compare_arrows_rounded), text: 'Ser vs Estar'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerbTrainerScreen()),
            );
          },
          icon: const Icon(Icons.bolt_rounded),
          label: const Text('Спринт глаголов ⚡️'),
        ),
        body: BlocBuilder<GrammarCubit, GrammarState>(
          builder: (context, state) {
            if (state is GrammarLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GrammarError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: theme.colorScheme.error)),
              );
            }

            if (state is GrammarLoaded) {
              return TabBarView(
                children: [
                  _buildConjugationTab(context, state, theme),
                  _buildContractionsTab(state, theme),
                  _buildSerVsEstarTab(theme),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildConjugationTab(BuildContext context, GrammarLoaded state, ThemeData theme) {
    final verb = state.selectedVerb;
    final currentConjugations = verb.conjugations
        .where((c) => c.tense == state.selectedTense)
        .toList();

    return Column(
      children: [
        // Group Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip(context, 'Все', 'all', state.selectedGroup),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Группа -ar', '-ar', state.selectedGroup),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Группа -er', '-er', state.selectedGroup),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Группа -ir', '-ir', state.selectedGroup),
              const SizedBox(width: 8),
              _buildFilterChip(context, 'Неправильные', 'irregular', state.selectedGroup),
            ],
          ),
        ),

        // Verbs Selector Horizontal List
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.filteredVerbs.length,
            itemBuilder: (context, index) {
              final v = state.filteredVerbs[index];
              final isSelected = v.id == verb.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(v.infinitive),
                  selected: isSelected,
                  onSelected: (_) => context.read<GrammarCubit>().selectVerb(v),
                ),
              );
            },
          ),
        ),

        const Divider(height: 16),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Verb Card Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            verb.infinitive.toUpperCase(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              verb.regularity == 'regular' ? 'Правильный' : 'Неправильный',
                              style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        verb.russianMeaning,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verb.grammarNotesRu,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tense Selector
                DropdownButtonFormField<String>(
                  initialValue: state.selectedTense,
                  decoration: const InputDecoration(
                    labelText: 'Время глагола',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'presente_indicativo',
                      child: Text('Presente do Indicativo (Настоящее)'),
                    ),
                    DropdownMenuItem(
                      value: 'preterito_perfeito',
                      child: Text('Pretérito Perfeito (Прошедшее завершенное)'),
                    ),
                    DropdownMenuItem(
                      value: 'preterito_imperfeito',
                      child: Text('Pretérito Imperfeito (Прошедшее длительное)'),
                    ),
                    DropdownMenuItem(
                      value: 'futuro_presente',
                      child: Text('Futuro do Presente (Будущее)'),
                    ),
                    DropdownMenuItem(
                      value: 'presente_subjuntivo',
                      child: Text('Presente do Subjuntivo (Сослагательное)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      context.read<GrammarCubit>().selectTense(val);
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Forms List
                ...currentConjugations.map((c) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        child: Text(
                          _formatPersonShort(c.person),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        c.form,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      subtitle: Text(_formatPersonRu(c.person)),
                      trailing: IconButton(
                        icon: const Icon(Icons.volume_up_rounded),
                        onPressed: () {
                          context.read<GrammarCubit>().playFormAudio('${c.person} ${c.form}');
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    String value,
    String currentSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: currentSelected == value,
      onSelected: (_) {
        context.read<GrammarCubit>().filterGroup(value);
      },
    );
  }

  Widget _buildContractionsTab(GrammarLoaded state, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.contractions.length,
      itemBuilder: (context, index) {
        final item = state.contractions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.preposition} + ${item.article} = ${item.contracted}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded),
                      onPressed: () {
                        context.read<GrammarCubit>().playFormAudio(item.example);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.meaning,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 8),
                Text(
                  'Пример: ${item.example}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Перевод: ${item.translation}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSerVsEstarTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: Colors.amber),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Золотое правило: "Ser" — это сущность и постоянство, а "Estar" — состояние и локация!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Глагол SER (Постоянное качество)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Национальность: Eu sou brasileiro (Я бразилец)'),
                  const Text('• Профессия: Ela é médica (Она врач)'),
                  const Text('• Характер/свойства: O café é amargo (Кофе горький сам по себе)'),
                  const Text('• Время и дата: São duas da tarde (Сейчас два часа дня)'),
                  const Text('• Происхождение: Sou de Lisboa (Я из Лиссабона)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Глагол ESTAR (Временное состояние)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Настроение/самочувствие: Estou cansado hoje (Я сегодня устал)'),
                  const Text('• Местонахождение: Ele está no hotel (Он находится в отеле)'),
                  const Text('• Погода: O dia está ensolarado (День сейчас солнечный)'),
                  const Text('• Временное свойство: A sopa está fria (Суп сейчас холодный, остыл)'),
                  const Text('• Длительное действие: Estou estudando (Я прямо сейчас учусь)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPersonShort(String person) {
    return switch (person) {
      'eu' => 'Eu',
      'tu' => 'Tu',
      'ele/ela/você' => 'Ele',
      'nós' => 'Nós',
      'eles/elas/vocês' => 'Eles',
      _ => person,
    };
  }

  String _formatPersonRu(String person) {
    return switch (person) {
      'eu' => 'Я',
      'tu' => 'Ты',
      'ele/ela/você' => 'Он / Она / Вы (ед.ч.)',
      'nós' => 'Мы',
      'eles/elas/vocês' => 'Они / Вы (мн.ч.)',
      _ => person,
    };
  }
}
