part of 'list_section_movie_bloc.dart';

@immutable
abstract class ListSectionMovieState {}

class ListSectionMovieInitial extends ListSectionMovieState {}

class ListSectionMovieLoading extends ListSectionMovieState {}

class ListSectionMovieLoaded extends ListSectionMovieState {
  final List<Result> movieResponse1;
  final List<Result> movieResponse2;
  ListSectionMovieLoaded(
      {required this.movieResponse1, required this.movieResponse2});
}
