part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent {}

class InternetOn extends InternetEvent {}

class InternetOff extends InternetEvent {
  int timeStamp;
  InternetOff({required this.timeStamp});
}
