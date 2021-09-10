import 'package:flutter_bloc/models/brewery_model.dart';
import 'package:flutter_bloc/modules/list_breweries/list_breweries_bloc.dart';
import 'package:flutter_bloc/modules/single_brewery/single_brewery_bloc.dart';
import 'package:flutter_bloc/modules/single_brewery/single_brewery_screen.dart';
import 'package:flutter_bloc/widgets/custom_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListBreweriesScreen extends StatefulWidget {
  static const String routeName = "/ListBreweriesScreen";
  final ListBreweriesBloc _bloc;

  ListBreweriesScreen(this._bloc) {
    _bloc.loadInitialBreweries();
  }

  @override
  _ListBreweriesScreenState createState() => _ListBreweriesScreenState();
}

class _ListBreweriesScreenState extends State<ListBreweriesScreen> {
  final ScrollController _scrollController = ScrollController();
  final double breweryHeight = 50;

  ///
  /// A bool to disable some actions when it's loading more data
  ///
  bool isLoadingMore = false;

  ///
  /// A bool to disable some actions when user is searching.
  /// For example loading more data on scroll or showing loading at the end
  ///
  bool isSearching = false;

  ListBreweriesBloc get _bloc => widget._bloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScroll);
  }

  ///
  /// A call back which calls any time list view scrolls.
  ///
  /// This will call [_bloc] to load more data when user reach end of scroll
  ///
  void onScroll() async {
    if (!isSearching && !isLoadingMore) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      // This need to load before user reach end of scroll, so it will start
      // when there is 8 item to end
      double delta = breweryHeight * 8;
      if (maxScroll - currentScroll <= delta) {
        isLoadingMore = true;
        await _bloc.loadMore();
        isLoadingMore = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "All Breweries",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: _buildSearchEditText(),
        ),
        Expanded(
          flex: 10,
          child: _buildListBreweriesContainer(),
        ),
      ],
    );
  }

  Widget _buildSearchEditText() {
    return TextField(
      decoration: const InputDecoration(hintText: "Type To Search "),
      onChanged: (String text) {
        // If user input new
        if (text.isEmpty) {
          isSearching = false;
          _bloc.loadInitialBreweries();
        } else {
          isSearching = true;
          _bloc.searchBrewery(text);
        }
      },
    );
  }

  Widget _buildListBreweriesContainer() {
    return StreamBuilder(
      stream: _bloc.listBreweriesStream,
      builder: (_, AsyncSnapshot<List<BreweryModel>?> snapshot) {
        if (snapshot.hasData) {
          return _buildListBreweries(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text("Can't find breweries");
        } else {
          return Center(
            child: CustomProgressBar(),
          );
        }
      },
    );
  }

  Widget _buildListBreweries(List<BreweryModel> data) {
    int itemCount = data.length;
    // Add an extra item to show loading when user it's searching
    if (!isSearching) {
      itemCount++;
    }
    return ListView.builder(
        controller: _scrollController,
        itemCount: itemCount,
        itemBuilder: (_, int index) {
          if (index == data.length) {
            return CustomProgressBar();
          }
          return _buildIndividualBrewery(data[index]);
        });
  }

  Widget _buildIndividualBrewery(BreweryModel brewery) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(SingleBreweryScreen.routeName,
            arguments: SingleBreweryBloc(brewery));
      },
      child: Container(
        height: breweryHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 3.0,
            ),
          ),
        ),
        child: Text(
          brewery.name??"",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _scrollController.dispose();
  }
}
