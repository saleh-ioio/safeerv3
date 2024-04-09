import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddDriverPage extends StatefulWidget {
  const AddDriverPage({super.key});

  @override
  State<AddDriverPage> createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Driver"),
        ),
        body: Column(children: [
          Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              return ['a', 'b', 'c'];
            },
          )
        ]));
  }
}
