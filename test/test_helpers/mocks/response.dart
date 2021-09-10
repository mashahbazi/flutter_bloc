import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ResponseMock extends Mock implements Response {
  @override
  final int statusCode;
  final String _body;

  ResponseMock(this.statusCode, this._body);

  @override
  String get body => _body;
}
