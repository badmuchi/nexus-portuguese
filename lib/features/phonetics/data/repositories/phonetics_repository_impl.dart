import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/phonetic_trainer_models.dart';
import '../../domain/repositories/phonetics_repository.dart';

class PhoneticsRepositoryImpl implements PhoneticsRepository {
  final AppDatabase database;
  List<PhoneticExercise>? _cachedExercises;

  PhoneticsRepositoryImpl({required this.database});

  @override
  Future<Result<List<PhoneticExercise>>> getTrainerExercises() async {
    try {
      if (_cachedExercises != null && _cachedExercises!.isNotEmpty) {
        return Result.ok(_cachedExercises!);
      }

      final jsonString = await rootBundle.loadString('assets/seed/phonetics_trainer_seed.json');
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      final exercises = jsonList
          .map((e) => PhoneticExercise.fromJson(e as Map<String, dynamic>))
          .toList();

      _cachedExercises = exercises;
      return Result.ok(exercises);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure(
          'Failed to load phonetic trainer exercises: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<PhoneticMastery>>> getMasteryList() async {
    try {
      final rows = await database.getAllPhoneticMastery();
      final list = rows
          .map(
            (r) => PhoneticMastery(
              soundId: r.soundId,
              soundCategory: r.soundCategory,
              title: r.title,
              masteryScore: r.masteryScore,
              earAttempts: r.earAttempts,
              earCorrect: r.earCorrect,
              mouthAttempts: r.mouthAttempts,
              mouthScoreSum: r.mouthScoreSum,
              lastPracticedAt: r.lastPracticedAt,
            ),
          )
          .toList();
      return Result.ok(list);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure(
          'Failed to fetch phonetic mastery: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> recordEarAnswer({
    required String soundId,
    required bool isCorrect,
    required String soundCategory,
    required String title,
  }) async {
    try {
      await database.recordPhoneticEarAttempt(
        soundId: soundId,
        isCorrect: isCorrect,
        soundCategory: soundCategory,
        title: title,
      );
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure(
          'Failed to record ear attempt: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> recordMouthScore({
    required String soundId,
    required double scorePercent,
    required String soundCategory,
    required String title,
  }) async {
    try {
      await database.recordPhoneticMouthAttempt(
        soundId: soundId,
        scorePercent: scorePercent,
        soundCategory: soundCategory,
        title: title,
      );
      return const Result.ok(null);
    } catch (e, stackTrace) {
      return Result.err(
        DatabaseFailure(
          'Failed to record mouth attempt: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
