import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/story_entity.dart';
import '../../domain/repositories/stories_repository.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final AppDatabase _db;

  StoriesRepositoryImpl(this._db);

  @override
  Future<Result<List<StoryEntity>>> getAllStories() async {
    try {
      final rows = await _db.getAllStories();
      final entities = rows.map((r) {
        final List<dynamic> pList = (jsonDecode(r.contentJson) as List<dynamic>?) ?? [];
        final paragraphs = pList.map((p) {
          final map = p as Map<String, dynamic>;
          final wordsList = (map['words'] as List<dynamic>?)?.map((w) => w.toString()).toList() ?? [];
          return StoryParagraph(
            portuguese: map['portuguese'] as String? ?? '',
            russian: map['russian'] as String? ?? '',
            words: wordsList,
          );
        }).toList();

        return StoryEntity(
          id: r.id,
          titlePortuguese: r.titlePortuguese,
          titleRussian: r.titleRussian,
          dialect: r.dialect,
          level: r.level,
          coverIcon: r.coverIcon,
          description: r.description,
          contentJson: r.contentJson,
          paragraphs: paragraphs,
        );
      }).toList();

      return Result.ok(entities);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure('Failed to load stories: $e', stackTrace: stackTrace),
      );
    }
  }
}
