import 'dart:convert';
import '../Strings/strings.dart';
import '../model/movie_response.dart';
import 'package:http/http.dart' as http;

class SearchingMovie {
  Future<Result> getSearchResults(int element) async {
    Strings str = Strings(element: element.toString());
    var url = Uri.parse(str.api3);
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      var decode = jsonDecode(res.body);
      Map<String, dynamic> userMap = decode;
      Result movie = Result.fromJson(userMap);
      return movie;
    } else {
      throw Exception(res.statusCode);
    }
  }

  Future<Result> getSearchResult(String element) async {
    Strings str = Strings(element: element.toString());
    var url = Uri.parse(str.api3);
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      var decode = jsonDecode(res.body);
      Map<String, dynamic> userMap = decode;
      Result movie = Result.fromJson(userMap);
      return movie;
    } else {
      return Result();
      // throw Exception(res.statusCode);
    }
  }
}
