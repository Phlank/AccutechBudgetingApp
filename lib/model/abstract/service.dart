import 'dart:async';

abstract class Service {
  void start();

  void stop();

  FutureOr<bool> isEnabled();

  FutureOr<bool> isAllowed();
}
