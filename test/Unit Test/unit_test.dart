import 'package:submission_restaurant2/data/models/restaurant_data_list.dart';
import 'package:submission_restaurant2/data/models/restaurant_data_search.dart';
import 'package:test/test.dart';

void main() {
  group('Tes Parsing Data', () {
    test('Tes Parsing Data List Element', () {
      String testData = "rqdv5juczeskfw1e867";
      var myJson =
          "{\"id\":\"rqdv5juczeskfw1e867\",\"name\":\"Melting Pot\",\"description\":\"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...\",\"pictureId\":\"14\",\"city\":\"Medan\",\"rating\":4.2}";
      var cobaData = RestaurantDataListElement.fromJson(myJson);
      var result = cobaData.id;
      expect(result, testData);
    });
    test('Tes Parsing Data Search Element', () {
      String testData = "rqdv5juczeskfw1e867";
      var myJson =
          "{\"id\":\"rqdv5juczeskfw1e867\",\"name\":\"Melting Pot\",\"description\":\"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...\",\"pictureId\":\"14\",\"city\":\"Medan\",\"rating\":4.2}";
      var cobaData = RestaurantDataSearchElement.fromJson(myJson);
      var result = cobaData.id;
      expect(result, testData);
    });
  });
}
