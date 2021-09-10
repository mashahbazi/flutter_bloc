import 'package:flutter_bloc/modules/single_brewery/single_brewery_bloc.dart';
import 'package:flutter_bloc/modules/single_brewery/single_brewery_screen.dart';
import 'package:flutter_bloc/repositories/brewery/brewery_repository.dart';
import 'package:flutter_bloc/services/networking/api_interface.dart';
import 'package:flutter_bloc/services/networking/http_api_interface.dart';
import 'package:flutter_bloc/services/networking/url_provider.dart';
import 'package:flutter_bloc/modules/list_breweries/list_breweries_bloc.dart';
import 'package:flutter_bloc/modules/list_breweries/list_breweries_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    setUpDependencies();
  }

  setUpDependencies() {
    GetIt.instance.registerLazySingleton<ApiInterface>(
        () => HttpApiInterface(Client(), UrlProvider()));

    GetIt.instance.registerLazySingleton(
        () => BreweryRepository(GetIt.instance.get<ApiInterface>()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListBreweriesScreen(ListBreweriesBloc()),
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SingleBreweryScreen.routeName:
        return MaterialPageRoute(
          builder: (_) =>
              SingleBreweryScreen(settings.arguments as SingleBreweryBloc),
          settings: settings,
        );
      default:
        throw "${settings.name} doesn't support";
    }
  }
}
