part of 'internet_bloc.dart';

@immutable
abstract class InternetState {}

class YesInternet extends InternetState {}

class NoInternet extends InternetState {
  int timestamp;
  NoInternet({required this.timestamp});
}
