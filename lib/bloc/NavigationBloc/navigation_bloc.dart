// import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:watchlist/screens/AccountPage/account.dart';
import 'package:watchlist/screens/MoviesPage/movies.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationHome()) {
    on<MoviesClicked>((event, emit) => emit(NavigationMovies()));
    on<AccountClicked>((event, emit) => emit(NavigationAccount()));
    on<HomeClicked>((event, emit) => emit(NavigationHome()));
    // on<AccountClicked>((event, emit)) => emit(NavigationAccount());
  }

  // @override
  // Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
  //   if (event is HomeClicked) {
  //     yield NavigationHome();
  //   } else if (event is MoviesClicked) {
  //     yield NavigationMovies();
  //   } else if (event is AccountClicked) {
  //     yield NavigationAccount();
  //   } else {
  //     throw UnimplementedError();
  //   }
  // }
}
