part of 'moviesearch_bloc.dart';

@immutable
abstract class MoviesearchEvent {}

class SearchClicked extends MoviesearchEvent {
  final String movieName;
  SearchClicked({required this.movieName});
}
