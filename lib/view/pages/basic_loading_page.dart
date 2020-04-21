import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasicLoadingPage extends StatelessWidget {
  final String message;

  BasicLoadingPage({@required this.message});

  Widget _buildConstrainedIndicator() {
    return Row(
      children: <Widget>[
        ConstrainedBox(
          child: CircularProgressIndicator(
            value: null,
          ),
          constraints: BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxHeight: 100,
            maxWidth: 100,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Setup')),
        body: Column(
          children: <Widget>[
            _buildConstrainedIndicator(),
            Container(
              height: 24,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ));
  }
}
