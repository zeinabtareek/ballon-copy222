import 'package:arrows/api_base/api_endpoints.dart';
import 'package:arrows/api_base/dio_helper.dart';
import 'package:arrows/modules/home/models/ProductModel.dart';
import 'package:arrows/modules/home/models/category_model.dart';
import 'package:arrows/modules/home/models/home_response_body.dart';
import 'package:arrows/modules/home/models/subCategoryModel.dart';
import 'package:dio/dio.dart';

class HomeServices {
  static Future<HomeAds?> getHomeAds() async {
    Response? response;
    try {
      response = await DioHelper.getData(url: endpoint[Endpoint.getHomeAds]);
      print(response);
      return HomeAds.fromJson(response.data);
    } on DioError catch (e) {
      print("----------------");
      print("error : ${e.message}");
    }
  }

  Future<CategoryModel?> getMainCategories() async {
    Response? response;
    try {
      response =
          await DioHelper.getData(url: endpoint[Endpoint.getMainCategories]);
      print(response);
      return CategoryModel.fromJson(response.data);
    } on DioError catch (e) {
      print("----------------");
      print("error : ${e.message}");
    }
    return null;
  }

  Future<SubCategoryModel?> getSubCategory() async {
    Response? response;
    try {
      response = await DioHelper.getData(url: endpoint[Endpoint.subCategories]);
      print(response.data);
      print("object");
      return SubCategoryModel.fromJson(response.data);
    } on DioError catch (e) {
      print("----------------");
      print("error : ${e.message}");
    }
    return null;
  }

}
