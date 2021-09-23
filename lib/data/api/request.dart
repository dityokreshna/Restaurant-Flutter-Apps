import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:submission_restaurant/data/models/restaurant.dart';
import 'package:submission_restaurant/data/models/restaurant_detail.dart';
import 'package:submission_restaurant/data/models/restaurant_search.dart';
import 'package:submission_restaurant/ui/restaurant_detail.dart';
import 'package:submission_restaurant/ui/restaurant_list.dart';
 

class GetApiData{
Future<RestaurantDetailModel> fetchDetail(String idRestaurant) async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/detail/'+idRestaurant));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RestaurantDetailModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to detail');
  }
}
Future<Restaurant> fetcList() async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load list');
  }
}
Future<RestaurantSearch> fetchSearch(String query) async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/search?q='+query));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RestaurantSearch.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to search');
  }
}
}