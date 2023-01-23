class Strings {
  String element;
  Strings({required this.element}) {
    api3 =
        "https://api.themoviedb.org/3/movie/${element}?api_key=8bf9b5e7fc00e532b755421538ac1d01&language=en-US";
    popularMovies =
        "https://api.themoviedb.org/3/movie/popular?api_key=8bf9b5e7fc00e532b755421538ac1d01&language=en-US&page=";
    latestMovies =
        "https://api.themoviedb.org/3/movie/latest?api_key=8bf9b5e7fc00e532b755421538ac1d01&language=en-US&page=";
    topRatedMovies =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=8bf9b5e7fc00e532b755421538ac1d01&language=en-US&page=";
    upcomingMovies =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=8bf9b5e7fc00e532b755421538ac1d01&language=en-US&page=";
    api1 =
        "https://api.themoviedb.org/3/search/movie?api_key=8bf9b5e7fc00e532b755421538ac1d01&query=${element}&page=1";
  }
  late String api1;
  late String popularMovies;
  late String topRatedMovies;
  late String latestMovies;
  late String upcomingMovies;
  late String api3;
}
