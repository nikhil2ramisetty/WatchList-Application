part of 'movietap_bloc.dart';

@immutable
abstract class MovietapEvent {}

class MovieTappedEvent extends MovietapEvent {
  final int id;
  MovieTappedEvent({required this.id});
}

class MovieLoadingEvent extends MovietapEvent {}

class MovieInitalComeBack extends MovietapEvent {}
