import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ErrorPageState();
}

class ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Text.rich(TextSpan(
            text: 'Error',
            style: TextStyle(
                color: Colors.red,
                backgroundColor: Colors.black,
                fontSize: 24,
                fontStyle: FontStyle.italic))));
  }
}
