import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:watchlist/model/movie_response.dart';

import '../../services/getSearch.dart';
// import '../services/getSearch.dart';

part 'moviesearch_event.dart';
part 'moviesearch_state.dart';

class MoviesearchBloc extends Bloc<MoviesearchEvent, MovieSearchState> {
  final Searching searching;
  MoviesearchBloc(this.searching) : super(MovieSearchInitial()) {
    on<SearchClicked>((event, emit) => _getMovies(event.movieName, emit));
  }
  Future<void> _getMovies(
      String searchElement, Emitter<MovieSearchState> emit) async {
    emit(MovieSearchLoading());
    MovieResponse response = await searching.getSearchResults(searchElement);
    emit(MovieSearchLoaded(response: response));
  }
}
