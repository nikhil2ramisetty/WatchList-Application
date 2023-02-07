part of 'list_section_movie_bloc.dart';

@immutable
abstract class ListSectionMovieState {}

class ListSectionMovieInitial extends ListSectionMovieState {}

class ListSectionMovieLoading extends ListSectionMovieState {}

class ListSectionMovieLoaded extends ListSectionMovieState {
  final List<Result> movieResponse1;
  ListSectionMovieLoaded({required this.movieResponse1});
}
