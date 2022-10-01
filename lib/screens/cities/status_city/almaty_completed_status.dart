import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CompleedAlmaty extends StatefulWidget {
  const CompleedAlmaty({Key? key}) : super(key: key);

  @override
  State<CompleedAlmaty> createState() => _CompleedAlmatyState();
}

class _CompleedAlmatyState extends State<CompleedAlmaty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar'),
      ),
      body: Center(child: Text('Completed')),
    );
  }
}
