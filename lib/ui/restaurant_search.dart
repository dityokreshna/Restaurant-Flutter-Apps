import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/style/color_style.dart';
import 'package:submission_restaurant2/style/text_style.dart';
import 'package:submission_restaurant2/ui/restaurant_detail.dart';
import 'package:provider/provider.dart';

import 'provider/restaurant_search.dart';

class RestaurantUiSearch extends StatefulWidget {
  static const routeName = '/restaurant_search';

  @override
  _RestaurantUiSearchState createState() => _RestaurantUiSearchState();
}

class _RestaurantUiSearchState extends State<RestaurantUiSearch> {
  final _queryText = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _queryText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult internetResult =
        Provider.of<ConnectivityResult>(context);
    return SafeArea(
      child: ChangeNotifierProvider<RestaurantNotifier>(
        create: (_) => RestaurantNotifier(
          apiData: GetApiData(),
          mQuery: _queryText.text,
        ),
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
            alignment: Alignment.centerLeft,
            color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text("Search",
                      style: Theme.of(context).textTheme.headline4),
                ),
                Consumer<RestaurantNotifier>(builder: (context, state, _) {
                  return Container(
                      width: 350,
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 275,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              controller: _queryText,
                              decoration: InputDecoration(
                                hintText: 'Type Restaurant Name',
                                labelStyle: TextStyle(
                                  color: secondaryColor,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: IconButton(
                              iconSize: 20,
                              padding: const EdgeInsets.all(0),
                              icon: Icon(Icons.search),
                              onPressed: () {
                                Provider.of<RestaurantNotifier>(context,
                                        listen: false)
                                    .myQuery(_queryText.text);
                              },
                            ),
                          ),
                        ],
                      ));
                }),
                Expanded(
                    child: internetResult == ConnectivityResult.none
                        ? Center(
                            child: Text("Check Your Internet Connection!",
                                style: myTextTheme.bodyText2))
                        : Consumer<RestaurantNotifier>(
                            builder: (context, state, _) {
                            if (state.state == ResultState.Loading) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: secondaryColor,
                              ));
                            } else if (state.state == ResultState.HasData) {
                              return ListView.builder(
                                  itemCount: state.result.length,
                                  itemBuilder: (context, int index) {
                                    return Container(
                                      height: 100,
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(width: 0.1),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: Offset(0, 3),
                                            ),
                                          ]),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                        leading: Hero(
                                          tag: state.result[index].id,
                                          child: Image.network(
                                            'https://restaurant-api.dicoding.dev/images/small/' +
                                                state.result[index].pictureId,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return CircularProgressIndicator(
                                                color: secondaryColor,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              );
                                            },
                                            width: 100,
                                          ),
                                        ),
                                        title: Text(
                                          state.result[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 3, 0, 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildSubtitleItem(
                                                  context,
                                                  Icons.location_on,
                                                  state.result[index].city),
                                              _buildSubtitleItem(
                                                  context,
                                                  Icons.star,
                                                  state.result[index].rating
                                                      .toString())
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                              RestaurantUiDetail.routeName,
                                              arguments:
                                                  state.result[index].id);
                                        },
                                      ),
                                    );
                                  });
                            } else if (state.state == ResultState.NoData) {
                              return Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.search_off_rounded,
                                      size: 75,
                                    ),
                                  ),
                                  Text(state.message,
                                      style: myTextTheme.bodyText2),
                                ],
                              ));
                            } else if (state.state == ResultState.Error) {
                              return Center(child: Text(state.message));
                            } else {
                              return Center(child: Text(''));
                            }
                          }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleItem(
      BuildContext context, IconData subIcon, String subText) {
    return Row(children: <Widget>[
      Icon(
        subIcon,
        size: 14,
        color: secondaryColor,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
        child: Text(
          subText,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      )
    ]);
  }
}
