import 'package:dio/dio.dart';
import 'package:exercises_filtered_search/model/exercise_model.dart';
import 'package:flutter/material.dart';

import '../service/exercise_service.dart';
import '../view/exercise_view.dart';

abstract class ExerciseViewModel extends State<ExerciseView> {
  final baseUrl = 'https://exercises-by-api-ninjas.p.rapidapi.com/v1';
  late final IExerciseService exerciseService;
  final Map<String, String> headers = {
    'X-RapidAPI-Key': '8c14845bc1msh740b31ed61c2371p11562cjsn4bccafd4cb18',
    'X-RapidAPI-Host': 'exercises-by-api-ninjas.p.rapidapi.com',
  };
  bool isLoading = false;

  List<ExerciseModel> exercises = [];
  List<ExerciseModel> filteredExercises = [];

  @override
  void initState() {
    super.initState();

    exerciseService = ExerciseService(Dio(BaseOptions(baseUrl: baseUrl, headers: headers)));

    _fetchData();

    exercises = filteredExercises;
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> _fetchData() async {
    changeLoading();

    exercises = await exerciseService.fetchExerciseItem() ?? [];
    changeLoading();
  }
}
