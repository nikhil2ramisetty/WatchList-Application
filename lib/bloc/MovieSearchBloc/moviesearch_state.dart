part of 'moviesearch_bloc.dart';

@immutable
abstract class MovieSearchState {}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchLoaded extends MovieSearchState {
  MovieResponse response;
  MovieSearchLoaded({required this.response});
}
