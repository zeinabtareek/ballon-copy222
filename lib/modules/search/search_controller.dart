import 'package:arrows/modules/search/SearchModel.dart';
import 'package:arrows/modules/search/search_services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../home/models/ProductModel.dart';

class SearchController extends GetxController {
  final services = SearchService();

  final loading = false.obs;
  final searchList = <SearchList>[].obs;
  // final searchListProductData = <ProductData>[].obs;
  final pageNumber = 0.obs;
  final search = ''.obs;
  final RefreshController refreshController = RefreshController();

  @override
  onInit() {
    super.onInit();
    // search("b");
  }

  loadMore() async {
    if (searchList.isNotEmpty) {
      pageNumber.value++;
      SearchModel? data =
          await services.searchProduct(search.value, pageNumber.value);
      searchList.addAll(await data!.data!);
      print(searchList.length);
      print("loading");
      print(pageNumber.value);
    } else {
      print("no subcategories");
    }
  }

  Future<void> searchData() async {
    loading.value = true;
    SearchModel? data =
        await services.searchProduct(search.value, pageNumber.value);
    if (data!.data != null) {
      searchList.assignAll(await data.data ?? []);
       loading.value = false;
    } else if (data.data == null) {
      loading.value = false;
      searchList.clear();
    }
    print(searchList.length);
    loading.value = false;
  }
}
