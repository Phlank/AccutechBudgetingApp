import 'package:flutter/cupertino.dart';

class Padding8 extends StatelessWidget {
  final child;

  Padding8({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8), child: child);
  }
}

class Padding16 extends StatelessWidget {
  final child;

  Padding16({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(16), child: child);
  }
}

class Padding24 extends StatelessWidget {
  final child;

  Padding24({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(24), child: child);
  }
}
