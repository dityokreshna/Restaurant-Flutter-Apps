import 'package:flutter/material.dart';
import 'package:submission_restaurant/data/models/restaurant_detail.dart';
import 'package:submission_restaurant/data/models/restaurant_search.dart';
import 'package:submission_restaurant/style/color_style.dart';

class RestaurantDetail extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  final RestaurantDetailClass restaurant;
  const RestaurantDetail(List<RestaurantSearchElement> restaurant, {required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                  tag: restaurant.id,
                  child: Image.network(restaurant.pictureId)),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSubItem(
                              context, Icons.location_on, restaurant.city),
                          _buildSubItem(
                              context, Icons.star, restaurant.rating.toString())
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Divider(color: Colors.grey),
                    SizedBox(height: 5),
                    Text('Description',
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    Text(restaurant.description,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(height: 10),
                    Text('Menus', style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Food",
                              style: Theme.of(context).textTheme.bodyText2),
                          SizedBox(height: 5),
                          Container(
                            height: 35,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurant.menus.foods.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    restaurant.menus.foods[index].name,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text("Drinks",
                              style: Theme.of(context).textTheme.bodyText2),
                          SizedBox(height: 5),
                          Container(
                            height: 35,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurant.menus.drinks.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    restaurant.menus.drinks[index].name,
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
        ),
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
