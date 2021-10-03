import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant2/style/color_style.dart';
import 'package:submission_restaurant2/style/text_style.dart';

import 'provider/detail_notifier.dart';

class RestaurantUiDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String restaurantDetailId;
  const RestaurantUiDetail({required this.restaurantDetailId});

  @override
  _RestaurantUiDetailState createState() => _RestaurantUiDetailState();
}

class _RestaurantUiDetailState extends State<RestaurantUiDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    await Provider.of<DetailNotifier>(context, listen: false)
        .myDetal(widget.restaurantDetailId);
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult internetResult =
        Provider.of<ConnectivityResult>(context);
    return SafeArea(
      child: Scaffold(
          body: internetResult == ConnectivityResult.none
              ? Center(
                  child: Text("Check Your Internet Connection!",
                      style: myTextTheme.bodyText2))
              : Consumer<DetailNotifier>(builder: (context, state, _) {
                  if (state.state == ResultState.Loading) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: secondaryColor,
                    ));
                  } else if (state.state == ResultState.HasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Hero(
                              tag: state.result!.id,
                              child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/large/' +
                                    state.result!.pictureId,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: secondaryColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              )),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.result!.name,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 3, 0, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSubItem(context, Icons.location_on,
                                          state.result!.city),
                                      _buildSubItem(context, Icons.star,
                                          state.result!.rating.toString())
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Divider(color: Colors.grey),
                                SizedBox(height: 5),
                                Text('Description',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                SizedBox(height: 10),
                                Text(state.result!.description,
                                    textAlign: TextAlign.justify,
                                    style:
                                        Theme.of(context).textTheme.bodyText2),
                                SizedBox(height: 10),
                                Text('Menus',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Food",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                      SizedBox(height: 5),
                                      Container(
                                        height: 35,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              state.result!.menus.foods.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Text(
                                                state.result!.menus.foods[index]
                                                    .name,
                                                textAlign: TextAlign.center,
                                              ),
                                              padding: EdgeInsets.all(5),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text("Drinks",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                      SizedBox(height: 5),
                                      Container(
                                        height: 35,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              state.result!.menus.drinks.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Text(
                                                state.result!.menus.drinks[index]
                                                    .name,
                                                textAlign: TextAlign.center,
                                              ),
                                              padding: EdgeInsets.all(5),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
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
                        Text(state.message, style: myTextTheme.bodyText2),
                      ],
                    ));
                  } else if (state.state == ResultState.Error) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text(''));
                  }
                })
          ),
    );
  }
}

Widget _buildSubItem(BuildContext context, IconData subIcon, String subText) {
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
