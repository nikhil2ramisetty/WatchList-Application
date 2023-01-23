part of 'movietap_bloc.dart';

@immutable
abstract class MovietapState {}

class MovietapInitial extends MovietapState {}

class MovieTappedLoading extends MovietapState {}

class MovieTappedLoaded extends MovietapState {
  final Result movie;
  MovieTappedLoaded({required this.movie});
}
