import 'package:flutter_bloc/repositories/brewery/brewery_repository.dart';
import 'package:flutter_bloc/services/networking/api_interface.dart';
import 'package:flutter_bloc/services/networking/http_api_interface.dart';
import 'package:flutter_bloc/services/networking/url_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../modules/list_breweries_bloc/list_breweries_bloc_test.mocks.dart';


class GetItHelper {
  static void setUpDependencies({Client? client}) {
    GetIt.instance.registerLazySingleton<ApiInterface>(
        () => HttpApiInterface(client ?? MockClient(), UrlProvider()));

    GetIt.instance.registerLazySingleton(
        () => BreweryRepository(GetIt.instance.get<ApiInterface>()));
  }
}
