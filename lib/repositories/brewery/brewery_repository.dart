import 'package:flutter_bloc/models/brewery_model.dart';
import 'package:flutter_bloc/services/networking/api_interface.dart';

class BreweryRepository {
  final ApiInterface _apiInterface;

  BreweryRepository(this._apiInterface);

  Future<List<BreweryModel>> getAllBreweriesInPage(int page) async =>
      _apiInterface.getAllBreweriesInPage(page);

  Future<List<BreweryModel>> searchBrewery(String text) async =>
      _apiInterface.searchBrewery(text);
}
