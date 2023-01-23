part of 'sidenavigation_bloc.dart';

@immutable
abstract class SideNavigationEvent {}

class HomePressed extends SideNavigationEvent {}

class PopularPressed extends SideNavigationEvent {}

class UpcomingPressed extends SideNavigationEvent {}

class TopRatedPressed extends SideNavigationEvent {}

class SearchPressed extends SideNavigationEvent {}

class MoviePressed extends SideNavigationEvent {}
