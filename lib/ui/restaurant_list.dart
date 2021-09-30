import 'dart:core';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';
import 'package:submission_restaurant2/style/color_style.dart';
import 'package:submission_restaurant2/style/text_style.dart';
import 'package:submission_restaurant2/ui/restaurant_search.dart';
import 'provider/list_notifier.dart';
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
  SliverPersistentHeader makeHeader(BuildContext context, String headerText,
      String subtitleText, List<RestaurantDataListElement> listRestaurant) {
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    await Provider.of<ListNotifier>(context, listen: false).fetchDataList();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult internetResult =
        Provider.of<ConnectivityResult>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: internetResult == ConnectivityResult.none
            ? Center(
                child: Text("Check Your Internet Connection!",
                    style: myTextTheme.bodyText2))
            : Consumer<ListNotifier>(builder: (context, state, _) {
                if (state.state == ResultState.Loading) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: secondaryColor,
                  ));
                } else if (state.state == ResultState.HasData) {
                  return _listItem(context, state.result);
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
              }),
      ),
    );
  }

  CustomScrollView _listItem(
      BuildContext context, List<RestaurantDataListElement> listRestaurant) {
    return CustomScrollView(
      slivers: [
        makeHeader(context, "Restaurant", "Recommendation restaurant for you",
            listRestaurant),
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
