import 'package:arrows/modules/home/models/category_model.dart';
import 'package:arrows/modules/home/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewSubCategoryController extends GetxController {
  final services = HomeServices();
  CategoryModel? category;
  final loading = false.obs;
  final listSubCategory = <SubCategories>[].obs;
  int? currentIndex;
  int contNo = 1;
  final checkIsClicked = false.obs;
  String imgPath = 'assets/images/Artboard5.png';

  final List<String> labels = [
    'Birthdays',
    'Gender Reveal',
    'Arrangement',
    'Decoration'
  ];

  final List<Map<String, dynamic>> items = [
    {
      'Category': {
        'ImagePath': 'assets/images/boy.png',
        'ItemsLabel': 'btd test',
        'ItemsCount': 1
      }
    },
    {
      'Category': {
        'ImagePath': 'assets/images/Artboard5.png',
        'ItemsLabel': 'gr test',
        'ItemsCount': 3
      }
    },
    {
      'Category': {
        'ImagePath': 'assets/images/Artboard5.png',
        'ItemsLabel': 'ar test',
        'ItemsCount': 5
      }
    },
    {
      'Category': {
        'ImagePath': 'assets/images/boy.png',
        'ItemsLabel': 'deco test',
        'ItemsCount': 7
      }
    },
  ];

  isClicked(index) {
    checkIsClicked.value = !checkIsClicked.value;
  }

  void changeScreens(int index) {
    currentIndex = index;
    update();
  }

  @override
  Future<void> onInit() async {
    loading.value = true;
    category = await services.getMainCategories();
    listSubCategory.value = category!.data!.first.subCategories!;
    loading.value = false;
  }

  final load = false.obs;

  onTap(int index) {
    load.value = true;
    listSubCategory.value = category!.data![index].subCategories!;
    print(listSubCategory.length);
    load.value = false;
  }

  final selectedIndex = 0.obs;
  final check = false.obs;

  selected(int index) {
    selectedIndex.value = index;
  }
}
