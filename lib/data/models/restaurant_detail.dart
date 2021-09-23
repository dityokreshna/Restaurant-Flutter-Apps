// To parse this JSON data, do
//
//     final restaurant = restaurantFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class RestaurantDetailModel {
    RestaurantDetailModel({
        required this.error,
        required this.message,
        required this.restaurant,
    });

    bool error;
    String message;
    RestaurantDetailClass restaurant;

    factory RestaurantDetailModel.fromJson(String str) => RestaurantDetailModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantDetailModel.fromMap(Map<String, dynamic> json) => RestaurantDetailModel(
        error: json["error"],
        message: json["message"],
        restaurant: RestaurantDetailClass.fromMap(json["restaurant"]),
    );

    Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toMap(),
    };
}

class RestaurantDetailClass {
    RestaurantDetailClass({
        required this.id,
        required this.name,
        required this.description,
        required this.city,
        required this.address,
        required this.pictureId,
        required this.categories,
        required this.menus,
        required this.rating,
        required this.customerReviews,
    });

    String id;
    String name;
    String description;
    String city;
    String address;
    String pictureId;
    List<Category> categories;
    Menus menus;
    double rating;
    List<CustomerReview> customerReviews;

    factory RestaurantDetailClass.fromJson(String str) => RestaurantDetailClass.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RestaurantDetailClass.fromMap(Map<String, dynamic> json) => RestaurantDetailClass(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        city: json["city"],
        address: json["address"],
        pictureId: json["pictureId"],
        categories: List<Category>.from(json["categories"].map((x) => Category.fromMap(x))),
        menus: Menus.fromMap(json["menus"]),
        rating: json["rating"].toDouble(),
        customerReviews: List<CustomerReview>.from(json["customerReviews"].map((x) => CustomerReview.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "address": address,
        "pictureId": pictureId,
        "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
        "menus": menus.toMap(),
        "rating": rating,
        "customerReviews": List<dynamic>.from(customerReviews.map((x) => x.toMap())),
    };
}

class Category {
    Category({
        required this.name,
    });

    String name;

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
    };
}

class CustomerReview {
    CustomerReview({
        required this.name,
        required this.review,
        required this.date,
    });

    String name;
    String review;
    String date;

    factory CustomerReview.fromJson(String str) => CustomerReview.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CustomerReview.fromMap(Map<String, dynamic> json) => CustomerReview(
        name: json["name"],
        review: json["review"],
        date: json["date"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "review": review,
        "date": date,
    };
}

class Menus {
    Menus({
        required this.foods,
        required this.drinks,
    });

    List<Category> foods;
    List<Category> drinks;

    factory Menus.fromJson(String str) => Menus.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Menus.fromMap(Map<String, dynamic> json) => Menus(
        foods: List<Category>.from(json["foods"].map((x) => Category.fromMap(x))),
        drinks: List<Category>.from(json["drinks"].map((x) => Category.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toMap())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toMap())),
    };
}
