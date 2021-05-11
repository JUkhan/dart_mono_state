import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mono_state/mono_state.dart';

import 'package:todos/states/counter.dart';
import 'package:todos/states/searchCategory.dart';
import 'package:todos/states/todo.dart';

import './pages/counterPage.dart';

void main() {
  Get.put(MonoState([CounterState(), SearchCategoryState(), TodoState()]));
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: CounterPage(),
  ));
}
