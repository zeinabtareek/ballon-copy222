import 'package:arrows/modules/home/models/ProductModel.dart';
import 'package:arrows/modules/home/models/category_model.dart';
import 'package:arrows/modules/home/models/subCategoryModel.dart';
import 'package:get/get.dart';

import '../../home/services/home_services.dart';

class HomeController extends GetxController {
  final services = HomeServices();
  SubCategoryModel? category;
  List homeAds = [].obs;
  List homeAdsImages = [].obs;
  final currentImageIndex = 0.obs;
  final isLoading = true.obs;

  Future<void> getHomeAd() async {
    var response = await HomeServices.getHomeAds();

    for (int i = 0; i < response!.data!.length; i++) {
      homeAds.add(response.data![i]);
    }

    for (int i = 0; i < homeAds.length; i++) {
      homeAdsImages.add(homeAds[i].ads);
    }
    print(homeAds);
    print(homeAdsImages);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    await getHomeAd();
    homeAdsImages;
    category = await services.getSubCategory();
    isLoading.value = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    Get.delete<HomeController>();
  }
}
