import 'dart:async';
import 'package:rxdart/rxdart.dart';

class ErrorService {
  BehaviorSubject<Error> errorController = BehaviorSubject<Error>();
  Stream<Error> get error => errorController.stream;
  void errorCreate(Error e) {
    print('!!!');
    errorController.add(e);
  }
}
