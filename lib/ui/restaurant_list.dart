import 'dart:core';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_detail.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';
import 'package:submission_restaurant2/main.dart';
import 'package:submission_restaurant2/notification/custom_dialog.dart';
import 'package:submission_restaurant2/notification/notification_helper.dart';
import 'package:submission_restaurant2/style/color_style.dart';
import 'package:submission_restaurant2/style/text_style.dart';
import 'package:submission_restaurant2/ui/restaurant_search.dart';
import 'provider/hive_notifier.dart';
import 'provider/list_notifier.dart';
import 'provider/scheduling_provider.dart';
import 'restaurant_detail.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get maxExtent => maxHeight;
  @override
  double get minExtent => minHeight;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class RestaurantUiList extends StatefulWidget {
  static const routeName = '/restaurant_list';

  @override
  _RestaurantUiListState createState() => _RestaurantUiListState();
}

class _RestaurantUiListState extends State<RestaurantUiList> {
  SliverPersistentHeader makeHeader(
      BuildContext context, String headerText, String subtitleText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 100.0,
        child: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
            alignment: Alignment.centerLeft,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(headerText,
                        style: Theme.of(context).textTheme.headline4),
                    Text(subtitleText,
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RestaurantUiSearch.routeName,
                    );
                  },
                )
              ],
            )),
      ),
    );
  }

  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantUiDetail.routeName);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    await Provider.of<ListNotifier>(context, listen: false).fetchDataList();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Provider.of<HiveNotifier>(context, listen: false).getItem();
      }
    });
  }

  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult internetResult =
        Provider.of<ConnectivityResult>(context);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        backgroundColor: primaryColor,
        body: internetResult == ConnectivityResult.none
            ? Center(
                child: Text("Check Your Internet Connection!",
                    style: myTextTheme.bodyText2))
            : _selectedIndex == 2
                ? CustomScrollView(
                    slivers: [
                      makeHeader(
                          context, "Settings", "Settings Your Remainder"),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        ListTile(
                          title: Text('Dark Theme'),
                          trailing: Switch.adaptive(
                            value: false,
                            onChanged: (value) => customDialog(context),
                          ),
                        ),
                        ListTile(
                          title: Text('Scheduling News'),
                          trailing: Consumer<SchedulingProvider>(
                            builder: (context, scheduled, _) {
                              return Switch.adaptive(
                                value: scheduled.isScheduled,
                                onChanged: (value) async {
                                  if (Platform.isIOS) {
                                    customDialog(context);
                                  } else {
                                    scheduled.scheduledNews(value);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ]))
                    ],
                  )
                : _selectedIndex == 1
                    ? CustomScrollView(slivers: [
                        makeHeader(context, "Favorite",
                            "Look At Your Favorite Restaurant"),
                        Consumer<HiveNotifier>(builder: (context, state, _) {
                          return SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                height: 100,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(width: 0.1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 3),
                                      ),
                                    ]),
                                child: ListTile(
                                  onLongPress: () {
                                    Provider.of<HiveNotifier>(context,
                                            listen: false)
                                        .deleteItem(index);
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  leading: Hero(
                                    tag: state.resultList[index].id,
                                    child: Image.network(
                                      'https://restaurant-api.dicoding.dev/images/small/' +
                                          state.resultList[index].pictureId,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
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
                                    state.resultList[index].name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 3, 0, 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSubtitleItem(
                                            context,
                                            Icons.location_on,
                                            state.resultList[index].city),
                                        _buildSubtitleItem(
                                            context,
                                            Icons.star,
                                            state.resultList[index].rating
                                                .toString())
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RestaurantUiDetail.routeName,
                                        arguments: state.resultList[index].id);
                                  },
                                ),
                              );
                            },
                            childCount:
                                state.resultList.length, // 1000 list items
                          ));
                        })
                      ])
                    : Consumer<ListNotifier>(
                        builder: (context, state, _) {
                          if (state.state == ResultState.Loading) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: secondaryColor,
                            ));
                          } else if (state.state == ResultState.HasData) {
                            return _listItem(
                                context,
                                state.result,
                                "Restaurant",
                                "Recommendation restaurant for you");
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
                        },
                      ),
      ),
    );
  }

  showAlertDialog(BuildContext context, RestaurantDataListElement item) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Provider.of<HiveNotifier>(context, listen: false).getItem();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Provider.of<HiveNotifier>(context, listen: false).addItem(item);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Favorite"),
      content:
          Text("Are you sure to add this restaurant to your favorite list?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  CustomScrollView _listItem(
      BuildContext context,
      List<RestaurantDataListElement> listRestaurant,
      String head,
      String title) {
    return CustomScrollView(
      slivers: [
        makeHeader(context, head, title),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              height: 100,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: ListTile(
                onLongPress: () {
                  showAlertDialog(context, listRestaurant[index]);
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: listRestaurant[index].id,
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/' +
                        listRestaurant[index].pictureId,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return CircularProgressIndicator(
                        color: secondaryColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      );
                    },
                    width: 100,
                  ),
                ),
                title: Text(
                  listRestaurant[index].name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubtitleItem(context, Icons.location_on,
                          listRestaurant[index].city),
                      _buildSubtitleItem(context, Icons.star,
                          listRestaurant[index].rating.toString())
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, RestaurantUiDetail.routeName,
                      arguments: listRestaurant[index].id);
                },
              ),
            );
          },
          childCount: listRestaurant.length, // 1000 list items
        ))
      ],
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
