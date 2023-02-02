import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:watchlist/model/movie_response.dart';

import '../../services/getSearch.dart';

part 'sidenavigation_event.dart';
part 'sidenavigation_state.dart';

class SideNavigationBloc
    extends Bloc<SideNavigationEvent, SideNavigationState> {
  final Searching search = Searching();
  SideNavigationBloc()
      : super(SideNavigationInitialHome(movieResponse: const [])) {
    on<PopularPressed>((event, emit) async {
      emit(PageLoading());
      MovieResponse popularResult = await search.getPopularList();
      emit(SideNavigationPopular(movieResponse: popularResult));
    });
    on<UpcomingPressed>((event, emit) async {
      emit(PageLoading());
      MovieResponse upcomingResult = await search.getUpcomingList();
      emit(SideNavigationUpcoming(movieResponse: upcomingResult));
    });
    on<TopRatedPressed>((event, emit) async {
      emit(PageLoading());
      MovieResponse topRatedResult = await search.getTopRatedList();
      emit(SideNavigationTopRated(movieResponse: topRatedResult));
    });
    on<SearchPressed>((event, emit) async {
      List<MovieResponse> lis = await search.getHomePage();
      emit(SideNavigationSearch(movieResponse: lis));
    });
    on<MoviePressed>((event, emit) {
      emit(MoviePageRequest());
    });
    on<HomePressed>((event, emit) async {
      List<MovieResponse> lis = await search.getHomePage();
      emit(SideNavigationInitialHome(movieResponse: lis));
    });
  }
}
