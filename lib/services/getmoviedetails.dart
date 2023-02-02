import 'dart:convert';
import 'package:cache_manager/cache_manager.dart';

import '../Strings/strings.dart';
import '../model/movie_response.dart';
import 'package:http/http.dart' as http;

class SearchingMovie {
  Future<Result> getSearchResults(int element) async {
    try {
      Strings str = Strings(element: element.toString());
      var url = Uri.parse(str.api3);
      http.Response res = await http.get(url);
      if (res.statusCode == 200) {
        var decode = jsonDecode(res.body);
        Map<String, dynamic> userMap = decode;
        Result movie = Result.fromJson(userMap);
        WriteCache.setJson(key: element.toString(), value: userMap);
        return movie;
      } else {
        var movieMap = await ReadCache.getJson(key: element.toString());
        Result movie = Result.fromJson(movieMap);
        return movie;
      }
    } catch (e) {
      var movieMap = await ReadCache.getJson(key: element.toString());
      Result movie = Result.fromJson(movieMap);
      return movie;
    }
  }

  Future<Result> getSearchResult(String element) async {
    try {
      var decode = await ReadCache.getJson(key: element);
      Map<String, dynamic> ms = decode;
      Result movie = Result.fromJson(ms);
      return movie;
    } catch (e) {
      Strings str = Strings(element: element.toString());
      var url = Uri.parse(str.api3);
      try {
        http.Response res = await http.get(url);
        if (res.statusCode == 200) {
          var decode = jsonDecode(res.body);
          Map<String, dynamic> userMap = decode;
          Result movie = Result.fromJson(userMap);
          WriteCache.setJson(key: element, value: decode);
          return movie;
        } else {
          return Result();
        }
      } catch (e) {
        return Result();
      }
    }
  }
}
