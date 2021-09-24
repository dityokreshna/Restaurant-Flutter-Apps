import 'package:flutter/cupertino.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_search.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantNotifier extends ChangeNotifier {
  final GetApiData apiData;
  String mQuery;

  RestaurantNotifier({required this.apiData, required this.mQuery}) {
    _fetchSearchData();
  }

  late RestaurantDataSearch _searchResult;
  late String _message = '';
  late ResultState _state;

  String get message => _message;

  RestaurantDataSearch get result => _searchResult;

  ResultState get state => _state;

  set myQuery(String queryKu){
    mQuery = queryKu;
    print("disini : " + mQuery);
    notifyListeners();
  }

  Future<dynamic> _fetchSearchData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final searchData = await apiData.fetchSearch(mQuery);
      if (searchData.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchResult = searchData;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
