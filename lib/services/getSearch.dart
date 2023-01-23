import 'dart:convert';
import 'package:watchlist/screens/moviePageDetailed.dart';
import 'package:watchlist/services/getmoviedetails.dart';

import '../Strings/strings.dart';
import '../model/movie_response.dart';
import 'package:http/http.dart' as http;

class Searching {
  Future<MovieResponse> getSearchResults(String element) async {
    Strings str = Strings(element: element);
    var url2 = Uri.parse(str.api1);
    if (element == "") {
      url2 = Uri.parse(str.popularMovies);
    }
    http.Response res = await http.get(url2);
    if (res.statusCode == 200) {
      var decode = jsonDecode(res.body);
      Map<String, dynamic> userMap = decode;
      MovieResponse movie = MovieResponse.fromJson(userMap);
      return movie;
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<List<MovieResponse>> getHomePage() async {
    Strings str = Strings(element: "");
    var popularMovies = Uri.parse(str.popularMovies + "1");
    var upcomingMovies = Uri.parse(str.upcomingMovies + "1");
    var latestMovies = Uri.parse(str.latestMovies + "1");
    var topRatedMovies = Uri.parse(str.topRatedMovies + "1");
    http.Response res1 = await http.get(popularMovies);
    http.Response res2 = await http.get(upcomingMovies);
    http.Response res3 = await http.get(latestMovies);
    http.Response res4 = await http.get(topRatedMovies);
    if (res1.statusCode == 200 &&
        res2.statusCode == 200 &&
        res3.statusCode == 200 &&
        res4.statusCode == 200) {
      var decode1 = jsonDecode(res1.body);
      var decode2 = jsonDecode(res2.body);
      var decode3 = jsonDecode(res3.body);
      var decode4 = jsonDecode(res4.body);

      Map<String, dynamic> userMap1 = decode1;
      Map<String, dynamic> userMap2 = decode2;
      Map<String, dynamic> userMap3 = decode3;
      Map<String, dynamic> userMap4 = decode4;
      MovieResponse movie1 = MovieResponse.fromJson(userMap1);
      MovieResponse movie2 = MovieResponse.fromJson(userMap2);
      MovieResponse movie3 = MovieResponse.fromJson(userMap3);
      MovieResponse movie4 = MovieResponse.fromJson(userMap4);
      List<MovieResponse> lis = [movie1, movie2, movie3, movie4];
      return lis;
    }
    return throw Exception();
  }

  Future<MovieResponse> getPopularList() async {
    Strings str = Strings(element: "");
    var popularMovies1 = Uri.parse(str.popularMovies + "1");
    var popularMovies2 = Uri.parse(str.popularMovies + "2");
    http.Response res1 = await http.get(popularMovies1);
    http.Response res2 = await http.get(popularMovies2);
    if (res1.statusCode == 200 && res2.statusCode == 200) {
      var decode1 = jsonDecode(res1.body);
      var decode2 = jsonDecode(res2.body);
      Map<String, dynamic> userMap1 = decode1;
      Map<String, dynamic> userMap2 = decode2;
      MovieResponse movie1 = MovieResponse.fromJson(userMap1);
      MovieResponse movie2 = MovieResponse.fromJson(userMap2);
      List<Result?>? lis = movie1.results! + movie2.results!;
      MovieResponse ms =
          MovieResponse(page: 1, results: lis, totalPages: 2, totalResults: 40);
      return ms;
    }
    return throw Exception();
  }

  Future<MovieResponse> getUpcomingList() async {
    Strings str = Strings(element: "");
    var upcomingMovies1 = Uri.parse(str.upcomingMovies + "1");
    var upcomingMovies2 = Uri.parse(str.upcomingMovies + "2");
    http.Response res1 = await http.get(upcomingMovies1);
    http.Response res2 = await http.get(upcomingMovies2);
    if (res1.statusCode == 200 && res2.statusCode == 200) {
      var decode1 = jsonDecode(res1.body);
      var decode2 = jsonDecode(res2.body);
      Map<String, dynamic> userMap1 = decode1;
      Map<String, dynamic> userMap2 = decode2;
      MovieResponse movie1 = MovieResponse.fromJson(userMap1);
      MovieResponse movie2 = MovieResponse.fromJson(userMap2);
      List<Result?>? lis = movie1.results! + movie2.results!;
      MovieResponse ms =
          MovieResponse(page: 1, results: lis, totalPages: 2, totalResults: 40);
      return ms;
    }
    return throw Exception();
  }

  Future<MovieResponse> getLatestList() async {
    Strings str = Strings(element: "");
    var latestMovies1 = Uri.parse(str.latestMovies + "1");
    var latestMovies2 = Uri.parse(str.latestMovies + "2");
    http.Response res1 = await http.get(latestMovies1);
    http.Response res2 = await http.get(latestMovies2);
    if (res1.statusCode == 200 && res2.statusCode == 200) {
      var decode1 = jsonDecode(res1.body);
      var decode2 = jsonDecode(res2.body);
      Map<String, dynamic> userMap1 = decode1;
      Map<String, dynamic> userMap2 = decode2;
      MovieResponse movie1 = MovieResponse.fromJson(userMap1);
      MovieResponse movie2 = MovieResponse.fromJson(userMap2);
      List<Result?>? lis = movie1.results! + movie2.results!;
      MovieResponse ms =
          MovieResponse(page: 1, results: lis, totalPages: 2, totalResults: 40);
      return ms;
    }
    return throw Exception();
  }

  Future<MovieResponse> getTopRatedList() async {
    Strings str = Strings(element: "");
    var topRatedMovies1 = Uri.parse(str.topRatedMovies + "1");
    var topRatedMovies2 = Uri.parse(str.topRatedMovies + "2");
    http.Response res1 = await http.get(topRatedMovies1);
    http.Response res2 = await http.get(topRatedMovies2);
    if (res1.statusCode == 200 && res2.statusCode == 200) {
      var decode1 = jsonDecode(res1.body);
      var decode2 = jsonDecode(res2.body);
      Map<String, dynamic> userMap1 = decode1;
      Map<String, dynamic> userMap2 = decode2;
      MovieResponse movie1 = MovieResponse.fromJson(userMap1);
      MovieResponse movie2 = MovieResponse.fromJson(userMap2);
      List<Result?> ls = movie1.results! + movie2.results!;
      MovieResponse movie3 =
          MovieResponse(page: 0, results: ls, totalPages: 12, totalResults: 40);
      return movie3;
    }
    return throw Exception();
  }

  Future<List<Result>> getTotalResults(List<String?>? ls) async {
    SearchingMovie search = SearchingMovie();
    List<Result> lss = [];
    for (var i = 0; i < ls!.length; i++) {
      lss.add(Result());
    }
    for (var i = 0; i < ls.length; i++) {
      lss[i] = await search.getSearchResult(ls[i]!);
    }
    return lss;
  }
}
