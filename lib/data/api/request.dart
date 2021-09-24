import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:submission_restaurant2/data/models/restaurant_data_detail.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_search.dart';

class GetApiData{
Future<RestaurantDataDetail> fetchDetail(String idRestaurant) async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/detail/'+idRestaurant));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RestaurantDataDetail.fromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to detail');
  }
}

Future<RestaurantDataList> fetcList() async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RestaurantDataList.fromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load list');
  }
}

Future<RestaurantDataSearch> fetchSearch(String query) async {
  final response = await http
      .get(Uri.parse('https://restaurant-api.dicoding.dev/search?q='+query));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return RestaurantDataSearch.fromJson(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to search');
  }
}
}