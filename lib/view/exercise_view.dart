import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../view_model/exercise_view_model.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({
    Key? key,
  }) : super(key: key);

  @override
  _ExerciseViewState createState() => _ExerciseViewState();
}

class _ExerciseViewState extends ExerciseViewModel {
  final double _expandedHeight = 100;

  final double _radiusValue = 20;
  final double _sizedBoxWidth = 10;
  final double _paddingValue = 10;
  late final TextEditingController _controller;

  final bool isLoading = true;

  Set<String> _types = {};
  Set<String> _muscles = {};

  _createTypes() {
    for (int i = 0; i < exercises.length; i++) {
      _types.add(exercises[i].type.toString());
    }
  }

  _createMuscles() {
    for (int i = 0; i < exercises.length; i++) {
      _muscles.add(exercises[i].muscle.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _createTypes();
    _createMuscles();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: _expandedHeight,
            floating: true,
            pinned: true,
            snap: true,

            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildSearchField(context),
                ),
                SizedBox(
                  width: _sizedBoxWidth,
                ),
                _buildFloatingActionButton(),
              ],
            ),
            // ignore: prefer_const_constructors
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(top: _paddingValue),
              // ignore: prefer_const_constructors
              title: Text(
                '3 results found',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(_paddingValue),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _buildExerciseList,
                childCount: exercises.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      mini: true,
      onPressed: filteredSearchModalBottomSheet,
      child: const Icon(Icons.search_sharp),
    );
  }

  Future<dynamic> filteredSearchModalBottomSheet() async {
    final modal = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(key: PageStorageKey('type'), title: Text('Type'), children: [
                    for (String val in _types)
                      ListTile(
                        title: Text(val),
                        trailing: Checkbox(onChanged: (bool? value) {}, value: true),
                      ),
                  ]

                      // Checkbox(onChanged: (bool? value) {}, value: true),
                      // subtitle: Text(exercises[index].muscle.toString()),
                      ),
                  ExpansionTile(
                    key: PageStorageKey('muscle'),
                    title: Text('Muscle'),

                    children: [
                      for (String val in _muscles)
                        ListTile(
                          title: Text(val),
                          trailing: Checkbox(onChanged: (bool? value) {}, value: true),
                        ),
                    ],

                    // subtitle: Text(exercises[index].muscle.toString()),
                  ),
                ],
              ),
            ),
          );
        });

    return modal;
  }

  TextField _buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,

      onChanged: (String value) {},
      cursorColor: Theme.of(context).primaryColor,
      // autofocus: true,
      decoration: _inputDecorator(),
    );
  }

  InputDecoration _inputDecorator() {
    return InputDecoration(
      labelText: 'Search',
      suffixIcon: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          _controller.clear();
        },
      ),
      filled: true,
      fillColor: Theme.of(context).primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radiusValue),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget? _buildExerciseList(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(exercises[index].name.toString()),
            Chip(label: Text(exercises[index].type.toString())),
          ],
        ),
      ),
    );
  }
}
