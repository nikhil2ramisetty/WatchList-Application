part of 'list_section_movie_bloc.dart';

@immutable
abstract class ListSectionMovieEvent {}

class MoviesListLoaded extends ListSectionMovieEvent {
  final List<String?>? movieLists1;
  final List<String?>? movieLists2;
  MoviesListLoaded({required this.movieLists1, required this.movieLists2});
}
