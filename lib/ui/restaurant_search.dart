import 'package:flutter/material.dart';
import 'package:submission_restaurant/data/models/restaurant_search.dart';
import 'restaurant_detail.dart';

class RestaurantSearchDelegate extends SearchDelegate<String> {
  final List<RestaurantSearchElement> restaurant;
  RestaurantSearchDelegate(this.restaurant);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, "");
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = restaurant;

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(restaurant[index].name),
        subtitle: Text(restaurant[index].id),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    final suggestionList = query.isEmpty
        ? restaurant
        : restaurant
            .where((p) => p.name.contains(RegExp(query, caseSensitive: false)))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetail(
                restaurant: ,),
            ),
          );
        },
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].name.substring(0, query.length),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].name.substring(query.length),
                    style: TextStyle(color: Colors.grey)),
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
