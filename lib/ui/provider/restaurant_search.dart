import 'package:flutter/cupertino.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_search.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantNotifier extends ChangeNotifier {
  final GetApiData apiData;
  String mQuery;

  RestaurantNotifier({required this.apiData, required this.mQuery});

  List<RestaurantDataSearchElement> _searchResult = [];
  String _message = '';
  ResultState? _state;

  String get message => _message;

  List<RestaurantDataSearchElement> get result => _searchResult;

  ResultState? get state => _state;
  
  myQuery(String queryKu){
    mQuery = queryKu;
    _fetchSearchData(mQuery);
  }

  Future<dynamic> _fetchSearchData(String jQuery) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final searchData = await apiData.fetchSearch(jQuery);
      if (searchData.restaurants.isEmpty) {
        _state = ResultState.NoData;
        _message = 'Cannot Find Restaurant';
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _searchResult = searchData.restaurants;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
