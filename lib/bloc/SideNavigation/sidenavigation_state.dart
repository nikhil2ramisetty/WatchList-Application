part of 'sidenavigation_bloc.dart';

@immutable
abstract class SideNavigationState {}

class SideNavigationInitialHome extends SideNavigationState {
  final List<MovieResponse> movieResponse;
  SideNavigationInitialHome({required this.movieResponse});
}

class SideNavigationPopular extends SideNavigationState {
  final MovieResponse movieResponse;
  SideNavigationPopular({required this.movieResponse});
}

class PageLoading extends SideNavigationState {}

class SideNavigationUpcoming extends SideNavigationState {
  final MovieResponse movieResponse;
  SideNavigationUpcoming({required this.movieResponse});
}

class Loading extends SideNavigationState {}

class SideNavigationTopRated extends SideNavigationState {
  final MovieResponse movieResponse;
  SideNavigationTopRated({required this.movieResponse});
}

class SideNavigationSearch extends SideNavigationState {
  final List<MovieResponse> movieResponse;
  SideNavigationSearch({required this.movieResponse});
}

class MoviePageRequest extends SideNavigationState {}
