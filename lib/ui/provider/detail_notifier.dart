import 'package:flutter/cupertino.dart';
import 'package:submission_restaurant2/data/api/request.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_detail.dart';

enum ResultState { Loading, NoData, HasData, Error }

class DetailNotifier extends ChangeNotifier {
  final GetApiData apiData;

  var doneModuleList;

  DetailNotifier({required this.apiData});

  RestaurantDataDetailElement? _detailResult;
  String _message = '';
  ResultState? _state;

  String get message => _message;

 RestaurantDataDetailElement? get result => _detailResult;

  ResultState? get state => _state;
  myDetal(String idNya){
    _fetchDetailData(idNya);
  }
  Future<dynamic> _fetchDetailData(String idRestaurant) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final detailData = await apiData.fetchDetail(idRestaurant);
      if (detailData.error) {
        _state = ResultState.NoData;
        _message = 'Cannot Find Restaurant';
        notifyListeners();
      } else {
        _state = ResultState.HasData;
        _detailResult = detailData.restaurant;
        notifyListeners();
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
