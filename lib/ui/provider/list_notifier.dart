import 'package:flutter/cupertino.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';

enum ResultState { Loading, NoData, HasData, Error }

class ListNotifier extends ChangeNotifier {
  final GetApiData apiData;

  ListNotifier({required this.apiData});

  List<RestaurantDataListElement> _listResult = [];
  String _message = '';
  ResultState? _state;

  String get message => _message;

  List<RestaurantDataListElement> get result => _listResult;

  ResultState? get state => _state;

  fetchDataList(){
    _fetchListData();
  }

  Future<dynamic> _fetchListData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final listData = await apiData.fetcList();
      if (listData.restaurants.isEmpty) {
        _state = ResultState.NoData;
        _message = 'Cannot Find Restaurant';
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _listResult = listData.restaurants;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
