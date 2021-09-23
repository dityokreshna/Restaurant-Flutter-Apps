import 'package:flutter/material.dart';
import 'package:submission_restaurant/data/models/restaurant.dart';
import 'package:submission_restaurant/data/models/restaurant_search.dart';
import 'package:submission_restaurant/style/color_style.dart';
import 'package:submission_restaurant/ui/restaurant_search.dart';
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

class RestaurantList extends StatelessWidget {
  static const routeName = '/restaurant_list';
  SliverPersistentHeader makeHeader(BuildContext context, String headerText,
      String subtitleText, List<RestaurantElement> restaurantData,List<RestaurantSearchElement> restaurantSearchData) {
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
                    showSearch(
                        context: context,
                        delegate: RestaurantSearchDelegate(restaurantSearchData));
                  },
                )
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<RestaurantElement> _restaurantList;
    Future<RestaurantSearchElement> _listSearch;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: _customRestaurantList(context),
      ),
    );
  }

  FutureBuilder _customRestaurantList(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/data/local_restaurant.json'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var restaurant = Restaurant.fromJson(snapshot.data.toString());
          List<RestaurantElement> listRestaurant = restaurant.restaurants;
          print(listRestaurant);

          return _listItem(context, restaurant, listRestaurant,listSearch);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          final snackBar = SnackBar(
            content: const Text('Error !'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        return Center(
            child: CircularProgressIndicator(
          color: secondaryColor,
        ));
      },
    );
  }

  CustomScrollView _listItem(BuildContext context, Restaurant restaurant,
      List<RestaurantElement> listRestaurant,List<RestaurantSearchElement> listSearch) {
    return CustomScrollView(
      slivers: [
        makeHeader(context, "Restaurant", "Recommendation restaurant for you",
            listRestaurant,listSearch),
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
                  tag: restaurant.restaurants[index].id,
                  child: Image.network(
                    restaurant.restaurants[index].pictureId,
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
                  restaurant.restaurants[index].name,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubtitleItem(context, Icons.location_on,
                          restaurant.restaurants[index].city),
                      _buildSubtitleItem(context, Icons.star,
                          restaurant.restaurants[index].rating.toString())
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, RestaurantDetail.routeName,
                      arguments: restaurant.restaurants[index]);
                },
              ),
            );
          },
          childCount: restaurant.restaurants.length, // 1000 list items
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
