import 'dart:convert';

import 'package:flutter_bloc/models/brewery_model.dart';
import 'package:flutter_bloc/services/networking/api_interface.dart';
import 'package:flutter_bloc/services/networking/url_provider.dart';
import 'package:http/http.dart';

class HttpApiInterface extends ApiInterface {
  final Client _client;
  final UrlProvider _urlProvider;

  HttpApiInterface(this._client, this._urlProvider);

  ///
  /// Fetch list of breweries in a page from api and convert to app model
  ///
  /// It will return empty list when error happens.
  ///
  @override
  Future<List<BreweryModel>> getAllBreweriesInPage(int page) async {
    UrlParserInterface listBreweriesUrl = _urlProvider.listBreweries()
      ..page = page;
    Response response = await _client.get(listBreweriesUrl.toUri());
    if (response.statusCode == 200) {
      List<dynamic> resultList = jsonDecode(response.body);
      return resultList
          .map<BreweryModel>(
              (item) => BreweryModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return [];
    }
  }

  ///
  /// Fetch ada with [text] from api and convert to app model
  ///
  /// It will return empty list when error happens.
  ///
  @override
  Future<List<BreweryModel>> searchBrewery(String text) async {
    UrlParserInterface listBreweriesUrl = _urlProvider.searchBreweries(text);
    Response response = await _client.get(listBreweriesUrl.toUri());
    if (response.statusCode == 200) {
      List<dynamic> resultList = jsonDecode(response.body);
      return resultList
          .map<BreweryModel>(
              (item) => BreweryModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return [];
    }
  }
}
