import 'package:arrows/modules/product_details/models/drinks_model.dart';
import 'package:arrows/modules/product_details/services/get_all_drinks_service.dart';
import 'package:arrows/modules/sub_categories/controllers/sub_categories_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/loading_spinner.dart';
import '../../../constants/colors.dart';
import '../../../helpers/shared_prefrences.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/models/new_cart_model.dart';
import '../../home/models/ProductModel.dart';
import '../../product_details2/model/ProductDetailsModel.dart' as productDetails;
import '../../sign_up/screens/sign_up_screen.dart';
import '../../sub_categories/models/SubCategories.dart';

class ProductDetailsController extends GetxController {
  final SubCategoriesController subCategoriesController = Get.put(SubCategoriesController());
  final otherAddition = <bool>[].obs;
  final suaces = <bool>[].obs;
  final component = <bool>[].obs;
  final addition = <bool>[].obs;
  RxInt orderCounter = 1.obs;
  List<Drink>? drinks = <Drink>[].obs;
  Drink? drinkDropDownValue;
  RxDouble productPrice = 0.0.obs;
  RxDouble orderPrice = 0.0.obs;
  Drink selectedDrink = Drink();
  Sizes selectedSize=Sizes() ;
  List<bool> selectedAdditions = <bool>[].obs;
  List<bool> selectedComponents = <bool>[].obs;
  final priceList = <String>[].obs;
  List<Products> products = <Products>[].obs;
  var value ;
  var addressesBox;
  var cartBox;
  String dropDownValue = '';
  List<productDetails.ProductDetailsModel> productDetailsModel = <productDetails.ProductDetailsModel>[].obs;
  bool? typeValue;
  void change(vlaue) {
   value =vlaue;
   update();
   }
  Future<void> getAllRestaurantDrinks() async {
    AllDrinksResponse? response;
    try {
      response = await AllDrinksService.getAllDrinks();
    } catch (e) {
      print(e);
    }
    drinks!.addAll(response!.drinks);
    print(response.drinks);
  }

  @override
  Future<void> onInit() async {
    totalPrice.value = data.price!.toDouble();

    super.onInit();
  }

  @override
  void dispose() {
     super.dispose();
   }
  selectType(newValue) {
    typeValue = newValue;
    update();
  }

  updatePriceList(String price) {
    priceList.add(price);
    print(priceList);
  }
/*******new*********/
  ProductData data=ProductData();
  NewCartModel2 oneProduct = NewCartModel2();
  String message='';
  final totalPrice = 0.0.obs;

  addToCart(context,{price ,category,name,
    image})async{
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

    String dateID =   dateFormat.format(DateTime.now());
    CacheHelper.saveDataToSharedPrefrence('dateOfTheOrder', dateID);

    if (await data.availability == 0) {
      Get.defaultDialog(
          content: Text(' غير متوفرة'),
          title: '');
    }
    else if (CacheHelper.loginShared == null) {
      showLoaderDialog(context);
      Get.offAll(SignUpScreen());
    }
    else {
      oneProduct = NewCartModel2(
        id: dateID,
        name: name,
         price: price.toString(),
         photo: image,
         quantity: orderCounter.value.toString(),
         category:category.toString(),
         message: message,
         total_price: totalPrice.value.toStringAsFixed(2),
      );
      CacheHelper.getDataToSharedPrefrence('userID') != null
          ? FirebaseDatabase.instance
          .reference()
          .child('Cart')
          // .child('branch1')
          .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
          .child(CacheHelper.getDataToSharedPrefrence('userID'))
          .child(dateID)
          .set(oneProduct.toJson())
          .then((value) {
        return Get.snackbar('done'.tr, 'one_item_added_successfully'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: kPrimaryColor,
            duration: Duration(seconds: 2),
            dismissDirection: DismissDirection.startToEnd,
            barBlur: 10,
            colorText: Colors.white);
      })
          : printError(info: '___________________');
      CartController().update();
      Get.back();
    }}

  decreaseOrderCounter( price) {
    if (orderCounter.value > 1) {
         orderCounter.value--;
        totalPrice.value = price * orderCounter.value;
        print(totalPrice.value);

    } else {
      Get.snackbar('sorry'.tr, 'you_can\'t_order_less_than_one'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.startToEnd,
          barBlur: 10,
          colorText: Colors.white);
    }
  }
  increaseOrderCounter(num limit,double price) {
     if (orderCounter.value < limit) {
         orderCounter.value++;
        totalPrice.value =  orderCounter.value * price ;
         print(totalPrice.value);

    } else {
      Get.snackbar('sorry'.tr, 'there_is_no_sufficient_quantity'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.startToEnd,
          barBlur: 10,
          colorText: Colors.white);
    }
  }




}
