import 'package:flutter/material.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_search.dart';
import 'package:submission_restaurant2/style/color_style.dart';
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider<RestaurantNotifier>(
        create: (_) => RestaurantNotifier(apiData: GetApiData(), mQuery: _queryText.text,),
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
            alignment: Alignment.centerLeft,
            color: primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Search", style: Theme.of(context).textTheme.headline4),
                Consumer<RestaurantNotifier>(
                  builder: (context, state, _) {
                    return Container(
                      width: 350,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 250,
                              child: TextField(
                                controller: _queryText,
                                decoration: InputDecoration(
                                  hintText: 'Search Input',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF6200EE),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF6200EE)),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    Provider.of<RestaurantNotifier>(context,listen: false).mQuery = _queryText.text;
                                    print(state.mQuery);
                                  },
                                ),
                          ],
                        ));
                  }
                ),
                    Expanded(child: 
                    //RestaurantUiSearchWidget(restaurantSearchQuery: _queryText.text
                    Consumer<RestaurantNotifier>(builder: (context, state, _){
                      print("state sini  1: " +state.result.toString());
                              if (state.state == ResultState.Loading) {
          return Center(child: CircularProgressIndicator());
        }  else if (state.state == ResultState.HasData){
          print("state sini : " +state.result.restaurants.length.toString());
          
          return ListView.builder(
                  itemCount: state.result.restaurants.length,
                  itemBuilder: (context, int index) {
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: Hero(
                          tag: state.result.restaurants[index].id,
                          child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/small/' +
                                state.result.restaurants[index].pictureId,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return CircularProgressIndicator(
                                color: secondaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              );
                            },
                            width: 100,
                          ),
                        ),
                        title: Text(
                          state.result.restaurants[index].name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSubtitleItem(context, Icons.location_on,
                                  state.result.restaurants[index].city),
                              _buildSubtitleItem(context, Icons.star,
                                  state.result.restaurants[index].rating.toString())
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, RestaurantUiDetail.routeName,
                              arguments: state.result.restaurants[index].id);
                        },
                      ),
                    );
                  });
        }else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text(''));
        }
                    }
                    ))
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



class RestaurantUiSearchWidget extends StatefulWidget {
  final String restaurantSearchQuery;
  const RestaurantUiSearchWidget({required this.restaurantSearchQuery});

  @override
  _RestaurantUiSearchWidgetState createState() =>
      _RestaurantUiSearchWidgetState();
}

class _RestaurantUiSearchWidgetState extends State<RestaurantUiSearchWidget> {
  late Future<RestaurantDataSearch> _restaurantDataSearch;

  @override
  void initState() {
    super.initState();
    _restaurantDataSearch =
        GetApiData().fetchSearch(widget.restaurantSearchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _restaurantDataSearch,
          builder: (context, AsyncSnapshot<RestaurantDataSearch> snapshot) {
            if (snapshot.hasData) {
              List<RestaurantDataSearchElement> listRestaurantSearch =
                  snapshot.data!.restaurants;
              return ListView.builder(
                  itemCount: listRestaurantSearch.length,
                  itemBuilder: (context, int index) {
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: Hero(
                          tag: listRestaurantSearch[index].id,
                          child: Image.network(
                            'https://restaurant-api.dicoding.dev/images/small/' +
                                listRestaurantSearch[index].pictureId,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return CircularProgressIndicator(
                                color: secondaryColor,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              );
                            },
                            width: 100,
                          ),
                        ),
                        title: Text(
                          listRestaurantSearch[index].name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSubtitleItem(context, Icons.location_on,
                                  listRestaurantSearch[index].city),
                              _buildSubtitleItem(context, Icons.star,
                                  listRestaurantSearch[index].rating.toString())
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, RestaurantUiDetail.routeName,
                              arguments: listRestaurantSearch[index].id);
                        },
                      ),
                    );
                  });
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: secondaryColor,
              ));
            }
          }),
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
