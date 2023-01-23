part of 'sidenavigation_bloc.dart';

@immutable
abstract class SideNavigationState {}

class SideNavigationInitialHome extends SideNavigationState {}

class SideNavigationPopular extends SideNavigationState {
  final MovieResponse movieResponse;
  SideNavigationPopular({required this.movieResponse});
}

class PageLoading extends SideNavigationState {}

// class SideNavigationLatest extends SideNavigationState {}

class SideNavigationUpcoming extends SideNavigationState {
  final MovieResponse movieResponse;
  SideNavigationUpcoming({required this.movieResponse});
}

class SideNavigationTopRated extends SideNavigationState {
  final MovieResponse movieResponse;
  SideNavigationTopRated({required this.movieResponse});
}

class SideNavigationSearch extends SideNavigationState {}

class MoviePageRequest extends SideNavigationState {}
