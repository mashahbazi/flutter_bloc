import 'dart:async';

import 'package:flutter_bloc/models/brewery_model.dart';
import 'package:flutter_bloc/repositories/brewery/brewery_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class ListBreweriesBloc {
  final BreweryRepository _breweryRepository =
      GetIt.instance.get<BreweryRepository>();
  final StreamController<List<BreweryModel>?> _listBreweriesController =
      StreamController();

  ///
  /// Save all previous loaded brewery in a list.
  ///
  /// This list will use when new breweries loaded to add into this list and
  /// add to stream controller
  ///
  final List<BreweryModel> loadedBreweries = [];

  ///
  /// Saves last loaded page to load new page in case use scroll to end of list
  ///
  @visibleForTesting
  int lastLoadedPage = 0;

  ///
  /// Give access to stream controller to any other class.
  ///
  /// This need to convert into stream so others can't add new data to it and it
  /// only be access able in this class
  ///
  Stream<List<BreweryModel>?> get listBreweriesStream =>
      _listBreweriesController.stream;

  ///
  /// Start loading data from scratch.
  ///
  /// Clear cached data and load first page.
  ///
  Future<void> loadInitialBreweries() async {
    loadedBreweries.clear();
    lastLoadedPage = 0;
    await loadSpecificPageToScreen(0);
  }

  ///
  /// Load an specific page, cache them and update stream.
  ///
  Future<void> loadSpecificPageToScreen(int page) async {
    List<BreweryModel> breweries =
        await _breweryRepository.getAllBreweriesInPage(page);
    loadedBreweries.addAll(breweries);
    _listBreweriesController.add(loadedBreweries);
  }

  ///
  /// Load new data which will be next page data
  ///
  Future<void> loadMore() async {
    lastLoadedPage++;
    await loadSpecificPageToScreen(lastLoadedPage);
  }

  ///
  /// Get result of breweries using search ability with [text] and update stream
  /// data
  ///
  Future<void> searchBrewery(String text) async {
    _listBreweriesController.add(null);
    List<BreweryModel> breweries = await _breweryRepository.searchBrewery(text);
    if (breweries.isNotEmpty) {
      _listBreweriesController.add(breweries);
    } else {
      _listBreweriesController.addError("Can't find any brewery");
    }
  }

  void dispose() {
    _listBreweriesController.close();
  }
}
