part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class HomeClicked extends NavigationEvent {}

class MoviesClicked extends NavigationEvent {}

class AccountClicked extends NavigationEvent {}
