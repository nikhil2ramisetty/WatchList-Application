part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {
  get index => null;
}

class NavigationHome extends NavigationState {
  final int index = 0;
}

class NavigationMovies extends NavigationState {
  final int index = 1;
}

class NavigationAccount extends NavigationState {
  final int index = 2;
}
