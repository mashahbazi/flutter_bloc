class UrlProvider {
  static const String _baseUrl = "https://api.openbrewerydb.org/";

  ListBreweriesUrl listBreweries() => ListBreweriesUrl(_baseUrl);

  SearchBreweriesUrl searchBreweries(String text) =>
      SearchBreweriesUrl(_baseUrl, text);
}

abstract class UrlParserInterface {
  Uri toUri();
}

class ListBreweriesUrl extends UrlParserInterface {
  String _url;
  int page = 0;

  ListBreweriesUrl(String baseUrl) : _url = "${baseUrl}breweries";

  @override
  Uri toUri() {
    String urlToParse = "$_url?page=$page";
    return Uri.parse(urlToParse);
  }
}

class SearchBreweriesUrl extends UrlParserInterface {
  String _url;

  SearchBreweriesUrl(String baseUrl, String text)
      : _url = "${baseUrl}breweries/search?query=$text";

  @override
  Uri toUri() {
    return Uri.parse(_url);
  }
}
