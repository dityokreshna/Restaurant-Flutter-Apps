// To parse this JSON data, do
//
//     final restaurantDataSearch = restaurantDataSearchFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class RestaurantDataSearch {
    RestaurantDataSearch({
        required this.error,
        required this.founded,
        required this.restaurants,
    });

    bool error;
    int founded;
    List<RestaurantDataSearchElement> restaurants;

    factory RestaurantDataSearch.fromJson(String str) => RestaurantDataSearch.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantDataSearch.fromMap(Map<String, dynamic> json) => RestaurantDataSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantDataSearchElement>.from(json["restaurants"].map((x) => RestaurantDataSearchElement.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toMap())),
    };
}

class RestaurantDataSearchElement {
    RestaurantDataSearchElement({
        required this.id,
        required this.name,
        required this.description,
        required this.pictureId,
        required this.city,
        required this.rating,
    });

    String id;
    String name;
    String description;
    String pictureId;
    String city;
    double rating;

    factory RestaurantDataSearchElement.fromJson(String str) => RestaurantDataSearchElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantDataSearchElement.fromMap(Map<String, dynamic> json) => RestaurantDataSearchElement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
    };
}
