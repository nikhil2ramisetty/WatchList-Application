import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/movie_response.dart';
import '../../services/getSearch.dart';

part 'list_section_movie_event.dart';
part 'list_section_movie_state.dart';

class ListSectionMovieBloc
    extends Bloc<ListSectionMovieEvent, ListSectionMovieState> {
  ListSectionMovieBloc() : super(ListSectionMovieInitial()) {
    on<MoviesListLoaded>((event, emit) async {
      emit(ListSectionMovieLoading());
      Searching search = Searching();
      List<Result> movieResponse1 =
          await search.getTotalResults(event.movieLists1);
      List<Result> movieResponse2 =
          await search.getTotalResults(event.movieLists2);
      emit(ListSectionMovieLoaded(
          movieResponse1: movieResponse1, movieResponse2: movieResponse2));
    });
  }
}
