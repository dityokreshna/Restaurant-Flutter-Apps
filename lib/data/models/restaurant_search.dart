// To parse this JSON data, do
//
//     final restaurant = restaurantFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class RestaurantSearch {
    RestaurantSearch({
        required this.error,
        required this.founded,
        required this.restaurants,
    });

    bool error;
    int founded;
    List<RestaurantSearchElement> restaurants;

    factory RestaurantSearch.fromJson(String str) => RestaurantSearch.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantSearch.fromMap(Map<String, dynamic> json) => RestaurantSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantSearchElement>.from(json["restaurants"].map((x) => RestaurantSearchElement.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toMap())),
    };
}

class RestaurantSearchElement {
    RestaurantSearchElement({
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

    factory RestaurantSearchElement.fromJson(String str) => RestaurantSearchElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantSearchElement.fromMap(Map<String, dynamic> json) => RestaurantSearchElement(
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
