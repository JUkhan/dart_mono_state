import 'package:flutter/material.dart';

import './nav.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: nav(),
      ),
      body: Center(
        child: Text('coming...'),
      ),
    );
  }
}
