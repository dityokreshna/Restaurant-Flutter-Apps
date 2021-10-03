import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';

class HiveNotifier extends ChangeNotifier{

List _restaurantDataList = <RestaurantDataListElement>[];
List get resultList => _restaurantDataList;

  addItem(RestaurantDataListElement item) async{
    var box = await Hive.openBox<RestaurantDataListElement>('restaurant');
    box.add(item);
    notifyListeners();
  }
  getItem()async{
    var box = await Hive.openBox<RestaurantDataListElement>('restaurant');
    _restaurantDataList = box.values.toList();
    print(_restaurantDataList.length);
    notifyListeners();
  }
  updateItem(int index,RestaurantDataListElement value){
    final box = Hive.box<RestaurantDataListElement>('restaurant');
    box.putAt(index, value);
    notifyListeners();
  }
  deleteItem(int index){
    final box = Hive.box<RestaurantDataListElement>('restaurant');
    box.deleteAt(index);
    getItem();
    notifyListeners();
  }

}