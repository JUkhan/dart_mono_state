import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import './counterPage.dart';
import './todoPage.dart';

List<Widget> nav() => [
      ElevatedButton(
        onPressed: () {
          Get.off(() => CounterPage());
        },
        child: const Text('Counter'),
      ),
      ElevatedButton(
        onPressed: () {
          Get.off(() => TodoPage());
        },
        child: const Text('Todos'),
      ),
    ];
