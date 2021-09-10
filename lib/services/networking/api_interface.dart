import 'package:flutter_bloc/models/brewery_model.dart';

abstract class ApiInterface {
  Future<List<BreweryModel>> getAllBreweriesInPage(int page);

  Future<List<BreweryModel>>  searchBrewery(String text);
}
