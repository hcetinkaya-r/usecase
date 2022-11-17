import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exercises_filtered_search/model/exercise_model.dart';
import 'package:flutter/material.dart';

abstract class IExerciseService {
  final Dio dio;

  IExerciseService(this.dio);

  Future<List<ExerciseModel>?> fetchExerciseItem();
}

enum _ExercisesPath { exercises }

class ExerciseService extends IExerciseService {
  // String path = 'https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises';

  ExerciseService(super.dio);

  @override
  Future<List<ExerciseModel>?> fetchExerciseItem() async {
    final response = await dio.get('/${_ExercisesPath.exercises.name}');

    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is List) {
        return jsonBody.map((json) => ExerciseModel.fromJson(json)).toList();
      }
    }
    return null;
  }
}
