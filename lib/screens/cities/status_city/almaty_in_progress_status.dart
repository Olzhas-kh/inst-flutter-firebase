import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class InProgressAlmaty extends StatefulWidget {
  const InProgressAlmaty({Key? key}) : super(key: key);

  @override
  State<InProgressAlmaty> createState() => _InProgressAlmatyState();
}

class _InProgressAlmatyState extends State<InProgressAlmaty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar'),
      ),
      body: Center(child: Text('In progress')),
    );
  }
}
