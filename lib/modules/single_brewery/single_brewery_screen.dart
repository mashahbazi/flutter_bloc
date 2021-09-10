import 'package:flutter_bloc/modules/single_brewery/single_brewery_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleBreweryScreen extends StatefulWidget {
  static const String routeName = "/SingleBreweryScreen";
  final SingleBreweryBloc _bloc;

  SingleBreweryScreen(this._bloc);

  @override
  _SingleBreweryScreenState createState() => _SingleBreweryScreenState();
}

class _SingleBreweryScreenState extends State<SingleBreweryScreen> {
  SingleBreweryBloc get _bloc => widget._bloc;

  TextStyle get detailTextStyle => const TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        _bloc.breweryModel.name ?? "",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildBody() {
    return RichText(
      text: TextSpan(
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          children: [
            ..._buildDetailRow("Name", _bloc.breweryModel.name),
            ..._buildDetailRow("State", _bloc.breweryModel.state),
            ..._buildDetailRow("City", _bloc.breweryModel.city),
            ..._buildDetailRow("Street", _bloc.breweryModel.street),
          ]),
    );
  }

  List<TextSpan> _buildDetailRow(String title, String? detail) {
    return [
      TextSpan(text: "$title:"),
      TextSpan(text: "${detail ?? ""}\n", style: detailTextStyle),
    ];
  }
}
