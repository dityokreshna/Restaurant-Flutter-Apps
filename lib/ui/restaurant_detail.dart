import 'package:flutter/material.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_detail.dart';
import 'package:submission_restaurant2/style/color_style.dart';

class RestaurantUiDetail extends StatefulWidget {
  static const routeName = '/restaurant_detail';
  final String restaurantDetailId;
  const RestaurantUiDetail({required this.restaurantDetailId});

  @override
  _RestaurantUiDetailState createState() => _RestaurantUiDetailState();
}

class _RestaurantUiDetailState extends State<RestaurantUiDetail> {
  Future<RestaurantDataDetail>? _restaurantDataDetail;

  @override
  void initState() {
    super.initState();
    _restaurantDataDetail = GetApiData().fetchDetail(widget.restaurantDetailId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: _restaurantDataDetail,
            builder: (context, AsyncSnapshot<RestaurantDataDetail> snapshot) {
              var connectionState = snapshot.connectionState;
              if (connectionState != ConnectionState.done) {
                return Center(
                    child: CircularProgressIndicator(
                  color: secondaryColor,
                ));
              }else if (connectionState == ConnectionState.none) {
                final snackBar = SnackBar(
                  content: const Text('Periksa Koneksi Anda!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                if (snapshot.hasData) {
                  RestaurantDataDetailElement restaurantDetail =
                      snapshot.data!.restaurant;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Hero(
                            tag: restaurantDetail.id,
                            child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/large/' +
                                  restaurantDetail.pictureId,
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
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
                                restaurantDetail.name,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSubItem(context, Icons.location_on,
                                        restaurantDetail.city),
                                    _buildSubItem(context, Icons.star,
                                        restaurantDetail.rating.toString())
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Divider(color: Colors.grey),
                              SizedBox(height: 5),
                              Text('Description',
                                  style: Theme.of(context).textTheme.headline6),
                              SizedBox(height: 10),
                              Text(restaurantDetail.description,
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context).textTheme.bodyText2),
                              SizedBox(height: 10),
                              Text('Menus',
                                  style: Theme.of(context).textTheme.headline6),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            restaurantDetail.menus.foods.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Text(
                                              restaurantDetail
                                                  .menus.foods[index].name,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2),
                                    SizedBox(height: 5),
                                    Container(
                                      height: 35,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: restaurantDetail
                                            .menus.drinks.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Text(
                                              restaurantDetail
                                                  .menus.drinks[index].name,
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
                } else if (snapshot.hasError) {
                  final snackBar = SnackBar(
                    content: const Text('Error !'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  print(snapshot.error);
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: secondaryColor,
                  ));
                }
              }
              return Center(
                  child: CircularProgressIndicator(
                color: secondaryColor,
              ));
            }),
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
