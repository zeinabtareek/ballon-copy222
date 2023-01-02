import 'package:arrows/constants/colors.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/sub_categories/controllers/sub_categories_controller.dart';
import 'package:arrows/modules/sub_categories/models/SubCategories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../product_details2/product_details.dart';

class SubCategoriesScreen extends StatelessWidget {
  SubCategoriesScreen({Key? key, required this.title, this.id});

  final String? title;
  final int? id;

  @override
  Widget build(BuildContext context) {
    final subCategoriesController = Get.put(SubCategoriesController());
    subCategoriesController.getProducts(id!);

    String replaceFarsiNumber(String input) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const farsi = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

      for (int i = 0; i < farsi.length; i++) {
        input = input.replaceAll(farsi[i], english[i]);
      }
      return input;
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              title.toString().tr,
              style: TextStyle(color: kPrimaryColor,fontSize: 16.sp),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor),
            )),
        body: SingleChildScrollView(
            child: Obx(() => subCategoriesController.isFirstLoadRunning.value
                ? Center(
                    child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: mainColor),
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kPrimaryColor,
                            ),
                          ),
                        )),
                  )
                : Obx(() => subCategoriesController.product.isEmpty
                    ? Center(
                        child: Text(
                        "no_products_meal".tr,
                        style:
                            TextStyle(fontSize: 20.sp, color:kPrimaryColor),
                      ))
                    : Obx(
                        () => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: SmartRefresher(
                            controller:
                                subCategoriesController.refreshController,
                            enablePullUp: true,
                            enablePullDown: false,
                            onLoading: () async {
                              await subCategoriesController.loadMore(id!);
                              subCategoriesController.refreshController
                                  .loadComplete();
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount:
                                    subCategoriesController.product.length,
                                itemBuilder: (context, index) {
                                  final translateName =
                                      CacheHelper.getDataToSharedPrefrence(
                                          "localeIsArabic"); //
                                  print(subCategoriesController.product.length);
                                  return InkWell(
                                    onTap: () async {
                                      Get.to(() => ProductDetails(
                                            data: subCategoriesController
                                                .product[index],
                                          ));
                                    },
                                    child: Card(
                                        elevation: 5,
                                        color: mainColor,
                                        shadowColor: mainColor,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: mainColor, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    subCategoriesController
                                                            .product[index]
                                                            .name ??
                                                        "",
                                                    style: TextStyle(
                                                      fontSize:
                                                          subCategoriesController
                                                                      .product[
                                                                          index]
                                                                      .availability ==
                                                                  0
                                                              ? 22.sp
                                                              : 18.sp,
                                                      color: subCategoriesController
                                                                  .product[
                                                                      index]
                                                                  .availability ==
                                                              1
                                                          ? Colors.black
                                                          : Colors.grey,
                                                      decoration:
                                                          subCategoriesController
                                                                      .product[
                                                                          index]
                                                                      .availability ==
                                                                  0
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : null,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 80.h,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: translateName
                                                            ? BorderRadius.only(
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            15))
                                                            : BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "${replaceFarsiNumber(subCategoriesController.product[index].price.toString() ?? "")} ",
                                                          style: TextStyle(
                                                              fontSize: 25.sp),
                                                        ),
                                                        SizedBox(width: 20.w),
                                                        Text(
                                                          'Price',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.sp),
                                                        ),
                                                        SizedBox(width: 20.w),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15)),
                                              child: CachedNetworkImage(
                                                  height: 120.h,
                                                  width: 150.w,
                                                  imageUrl:
                                                      subCategoriesController
                                                              .product[index]
                                                              .photo ??
                                                          "",
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                            child: SizedBox(
                                                              height: 30,
                                                              width: 30,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: kPrimaryColor
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                            ),
                                                          )),
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                          ),
                        ),
                      )))));
  }
}
