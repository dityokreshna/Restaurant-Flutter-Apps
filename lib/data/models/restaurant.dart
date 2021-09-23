// To parse this JSON data, do
//
//     final restaurant = restaurantFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class Restaurant {
    Restaurant({
        required this.error,
        required this.message,
        required this.count,
        required this.restaurants,
    });

    bool error;
    String message;
    int count;
    List<RestaurantElement> restaurants;

    factory Restaurant.fromJson(String str) => Restaurant.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Restaurant.fromMap(Map<String, dynamic> json) => Restaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantElement>.from(json["restaurants"].map((x) => RestaurantElement.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toMap())),
    };
}

class RestaurantElement {
    RestaurantElement({
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

    factory RestaurantElement.fromJson(String str) => RestaurantElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantElement.fromMap(Map<String, dynamic> json) => RestaurantElement(
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
