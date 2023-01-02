import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// String res_name = 'y7b42yskv43l_aleppo';

class DioHelper {
  static Dio? dio;
  static String? restaurantName;
  static String? restaurantBranchName;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://baloons.arrowscars.com/api/dashboard/',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
            "resturant": "y7b42yskv43l_baloons",
          }),
    );
    // restaurantBranchName = branchName;
    // restaurantName = res_name;
    // CacheHelper.saveDataToSharedPrefrence(
    //     'restaurantBranchName', restaurantBranchName);
    //
    // CacheHelper.saveDataToSharedPrefrence('restaurantName', 'y7b42yskv43l_baloons');
    // CacheHelper.saveDataToSharedPrefrence('restaurantName', restaurantName);
  }

  static Future<Response> getData({
    @required String? url,
    dynamic query,
    String? token,
  }) async {
    final translateName =
        await CacheHelper.getDataToSharedPrefrence("localeIsArabic");
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'lang': translateName ? 'ar' : "en",
      'resturant': 'y7b42yskv43l_baloons',
      // 'resturant': restaurantName,
      'Authorization': token == null ? "" : 'Bearer $token',
    };

    return await dio!.get(
      url ?? "",
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    @required String? url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'resturant': 'y7b42yskv43l_baloons',
      // 'resturant': restaurantName,
      'Authorization': token == null ? "" : 'Bearer $token',
    };
    return await dio!.post(
      url ?? "",
      queryParameters: query,
      data: data,
    );
  }
}
