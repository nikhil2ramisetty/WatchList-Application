// import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:watchlist/services/getmoviedetails.dart';

import '../../model/movie_response.dart';

part 'movietap_event.dart';
part 'movietap_state.dart';

class MovietapBloc extends Bloc<MovietapEvent, MovietapState> {
  final SearchingMovie searchingMovie;
  MovietapBloc(this.searchingMovie) : super(MovietapInitial()) {
    on<MovieTappedEvent>((event, emit) async {
      emit(MovieTappedLoading());
      Result res = await searchingMovie.getSearchResults(event.id);
      emit(MovieTappedLoaded(movie: res));
    });
    on<MovieInitalComeBack>((event, emit) => emit(MovietapInitial()));
  }
}
