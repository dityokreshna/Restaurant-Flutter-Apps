// To parse this JSON data, do
//
//     final restaurant = restaurantFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class RestaurantDataList {
    RestaurantDataList({
        required this.error,
        required this.message,
        required this.count,
        required this.restaurants,
    });

    bool error;
    String message;
    int count;
    List<RestaurantDataListElement> restaurants;

    factory RestaurantDataList.fromJson(String str) => RestaurantDataList.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantDataList.fromMap(Map<String, dynamic> json) => RestaurantDataList(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<RestaurantDataListElement>.from(json["restaurants"].map((x) => RestaurantDataListElement.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "count": count,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toMap())),
    };
}

class RestaurantDataListElement {
    RestaurantDataListElement({
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

    factory RestaurantDataListElement.fromJson(String str) => RestaurantDataListElement.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantDataListElement.fromMap(Map<String, dynamic> json) => RestaurantDataListElement(
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
