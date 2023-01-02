import 'package:arrows/api_base/dio_helper.dart';
import 'package:arrows/modules/search/SearchModel.dart';
import 'package:dio/dio.dart';

class SearchService {
  Future<SearchModel?> searchProduct(String name, int page) async {
    try {
      Response? response = await DioHelper.getData(
        url: "products/search/name=$name/page=$page",
      );
      if (response.statusCode == 200) {
        SearchModel model = SearchModel.fromJson(response.data);
        print(model.toJson());
        return model;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }
}
