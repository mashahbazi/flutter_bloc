import 'dart:async';

import 'package:flutter_bloc/models/brewery_model.dart';
import 'package:flutter_bloc/modules/list_breweries/list_breweries_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../test_helpers/get_it_helper.dart';
import '../../test_helpers/mocks/response.dart';
import 'list_breweries_bloc_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  final MockClient mockHttpClient = MockClient();
  GetItHelper.setUpDependencies(client: mockHttpClient);

  group("ListBreweriesBloc", () {
    group("loadInitialBreweries", () {
      test("Should clear all previous cached data", () async {
        when(mockHttpClient.get(
                Uri.parse("https://api.openbrewerydb.org/breweries?page=0")))
            .thenAnswer((_)async => ResponseMock(200, "[]"));

        ListBreweriesBloc listBreweriesBloc = ListBreweriesBloc();
        listBreweriesBloc.lastLoadedPage = 10;
        listBreweriesBloc.loadedBreweries.add(BreweryModel());

        await listBreweriesBloc.loadInitialBreweries();

        expect(listBreweriesBloc.lastLoadedPage, 0);
        expect(listBreweriesBloc.loadedBreweries.length, 0);
      });

      test("Should fetch data and update stream value", () async {
        when(mockHttpClient.get(
                Uri.parse("https://api.openbrewerydb.org/breweries?page=0")))
            .thenAnswer((_) async => ResponseMock(200, "[{\"id\":123}]"));
        ListBreweriesBloc listBreweriesBloc = ListBreweriesBloc();

        await listBreweriesBloc.loadInitialBreweries();

        expect(listBreweriesBloc.lastLoadedPage, 0);
        expect(listBreweriesBloc.loadedBreweries.length, 1);
        expect(
            (await listBreweriesBloc.listBreweriesStream.first)!.first.id, 123);
      });
    });

    group("searchBrewery", () {
      test("Should return error if list result is empty", () async {
        when(mockHttpClient.get(Uri.parse(
                "https://api.openbrewerydb.org/breweries/search?query=searchText")))
            .thenAnswer((_) async => ResponseMock(200, "[]"));

        ListBreweriesBloc listBreweriesBloc = ListBreweriesBloc();

        var streamError;
        var streamEvent;
        StreamSubscription streamSubscription =
            listBreweriesBloc.listBreweriesStream.listen((event) {
          streamEvent = event;
        }, onError: (error) {
          streamError = error;
        });

        await listBreweriesBloc.searchBrewery("searchText");
        await Future.delayed(Duration(seconds: 1));

        expect(streamError, "Can't find any brewery");
        expect(streamEvent, null);

        streamSubscription.cancel();
      });

      test("Should add list result to stream", () async {
        when(mockHttpClient.get(Uri.parse(
                "https://api.openbrewerydb.org/breweries/search?query=searchText")))
            .thenAnswer((_) async => ResponseMock(200, "[{\"id\":123}]"));

        ListBreweriesBloc listBreweriesBloc = ListBreweriesBloc();

        var streamError;
        var streamEvent;
        StreamSubscription streamSubscription =
            listBreweriesBloc.listBreweriesStream.listen((event) {
          streamEvent = event;
        }, onError: (error) {
          streamError = error;
        });

        await listBreweriesBloc.searchBrewery("searchText");
        await Future.delayed(Duration(seconds: 1));

        expect(streamError, null);
        expect(streamEvent.first.id, 123);

        streamSubscription.cancel();
      });
    });
  });
}
