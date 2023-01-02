import 'dart:async';
import 'package:arrows/components/arrows_app_bar.dart';
import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/styles.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/main.dart';
import 'package:arrows/modules/add_address/screens/add_address_screen.dart';
import 'package:arrows/modules/reciept/screens/reciept_screen.dart';
import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:arrows/modules/where_to_deliver/models/firebase_address_model.dart';
import 'package:arrows/modules/where_to_deliver/screens/new_where_to_delivery.dart';
import 'package:arrows/shared_object/posted_order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/custom_button.dart';
import '../../../helpers/map_launch_helper.dart';

class WhereToDeliverScreen extends StatefulWidget {
  WhereToDeliverScreen({Key? key}) : super(key: key);

  @override
  State<WhereToDeliverScreen> createState() => _WhereToDeliverScreenState();
}

Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);

class _WhereToDeliverScreenState extends State<WhereToDeliverScreen> {
  final WhereToController whereToController = Get.put(WhereToController());
  Set<Marker> markers = {};
  final translateName =
  CacheHelper.getDataToSharedPrefrence("localeIsArabic");

  @override
  Widget build(BuildContext context) {
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    whereToController.getAllUserAddressees();

    return Scaffold(
      appBar: ArrowsAppBar(
        'checkOut_onOrder',
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Text(
                "checkOut_onOrder_title".tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, color: kPrimaryColor),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                // Obx(() {
                //   return
                FutureBuilder(
                  future: whereToController.getAllBranchAddresses(),
                  builder: (context, snapShot) => Expanded(
                    child: Button(
                        text: "  ${'receive_from'.tr} :",
                        size: 150,
                        fontSize: 14,
                        height: !landScape ? Get.height / 20.h : 100.h,
                        isFramed: whereToController.showPickUpBranches.value
                            ? false
                            : true,
                        onPressed: () async {
                          PostedOrder.order.address = null;
                          PostedOrder.order.branch =
                              await whereToController.branches.first.name;
                          whereToController.showPickUpBranches.value = true;
                          print(
                              '%%%%%5${whereToController.showPickUpBranches.value}');
                        }),
                  ),
                ),

                SizedBox(
                  width: 10.w,
                ),
                FutureBuilder(
                    future: whereToController.getAllUserAddresseesv,
                    builder: (context, snapShot) => Expanded(
                          child: Button(
                            size: 150,
                            fontSize: 14,
                            height: !landScape ? Get.height / 20.h : 100.h,
                            isFramed: whereToController.showPickUpBranches.value
                                ? true
                                : false,
                            text: "  ${'deliver_to'.tr} :",
                            onPressed: () async {
                              try {
                                PostedOrder.order.branch = null;
                                whereToController.showPickUpBranches.value =
                                    false;
                                whereToController.showPickUpBranches.value =
                                    false;
                                (whereToController.selectedUserAddress !=
                                            null &&
                                        whereToController.selectedUserAddress
                                            .address!.isNotEmpty)
                                    ? PostedOrder.order.address =
                                        whereToController.selectedUserAddress
                                    : printError(
                                        info: 'mnnnnnnnvnnnnnvvnvnvnvn');
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                        )),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
            Obx(
              () => (whereToController.showPickUpBranches.value)
                  ? FutureBuilder(
                      future: whereToController.getAllBranchAddresses(),
                      builder: (context, snapShot) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "  ${'receive_from'.tr} :",
                            style: TextStyle(fontSize: 20.sp, color: mainColor),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Container(
                              padding: EdgeInsets.only(top: 15.h),
                              width: ScreenUtil().screenWidth,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: mainColor,
                                ),
                              ),
                              child: (snapShot.connectionState ==
                                      ConnectionState.waiting)
                                  ? Center(
                                      child: CupertinoActivityIndicator(
                                        radius: 20,
                                        color: kPrimaryColor,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child:  Row(
                                            children: [

                                              Icon(
                                                Icons.location_on_sharp,
                                                size: 30.r,
                                                color: mainColor,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              SizedBox(
                                                width: ScreenUtil
                                                    .defaultSize.width .w,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    // SizedBox(
                                                    //   height: 10.h,
                                                    // ),
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${'your_address'.tr}  :  ',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20.sp,
                                                          color: Colors.white),
                                                    ),  Text('${CacheHelper.getDataToSharedPrefrence('restaurantBranchID')}', style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20.sp,
                                                        color: Colors.white),),]),
                                                    translateName?
                                                    Text('${CacheHelper.getDataToSharedPrefrence('restaurantBranchAddressAr')}', style: TextStyle(
                                                        fontSize: 20.sp,
                                                        color: Colors.white),):
                                                    Text('${CacheHelper.getDataToSharedPrefrence('restaurantBranchAddressEn')}', style: TextStyle(
                                                        fontSize: 20.sp,
                                                        color: Colors.white),),


                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(
                                        //       bottom: 8.0.h,
                                        //       left: 8.w,
                                        //       right: 8.w),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.start,
                                        //     children: [
                                        //       Text(
                                        //         '${'your_address'.tr}  :  ',
                                        //         style: TextStyle(
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: 20.sp,
                                        //             color: Colors.white),
                                        //       ),
                                        //       Container(
                                        //           // color: Colors.green,
                                        //           width: Get.width / 2.w,
                                        //           child: Text(
                                        //             '${CacheHelper.getDataToSharedPrefrence('restaurantBranchAddress')}',
                                        //             style: TextStyle(
                                        //                 fontSize: 20.sp,
                                        //                 color: Colors.white),
                                        //           )),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : whereToController.dbref == null
                      ? SizedBox()
                      : GetBuilder<WhereToController>(
                          builder: (whereToController) => Container(
                                decoration: CommonStyles.customBoxDecoration,
                                margin: EdgeInsets.only(top: 20.h),
                                width: ScreenUtil().screenWidth,
                                child: FirebaseAnimatedList(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    query: whereToController.dbref,
                                    itemBuilder: (
                                      BuildContext context,
                                      DataSnapshot snapshot,
                                      Animation<double> animation,
                                      int index,
                                    ) {
                                      return Obx(() => RadioListTile(
                                          groupValue: whereToController
                                              .radioValue.value,
                                          value: snapshot.value.toString(),
                                          onChanged: (onChanged) async {
                                            whereToController.radioValue.value =
                                                snapshot.value.toString();
                                            PostedOrder.order.address =
                                                UserAddress.fromJson(snapshot
                                                        .value
                                                    as Map<dynamic, dynamic>);
                                            whereToController
                                                    .selectedUserAddress =
                                                UserAddress.fromJson(snapshot
                                                        .value
                                                    as Map<dynamic, dynamic>);
                                            // whereToController.selectedAreaPrice =snapshot.value!['branch1']['price'];
                                            whereToController
                                                    .selectedAreaPrice.value =
                                                snapshot.value['user_area']
                                                    ['price'];
                                            var x = await CacheHelper
                                                .saveDataToSharedPrefrence(
                                                    'dropdownAreaPrice',
                                                    snapshot.value['user_area']
                                                        ['price']);
                                            print(whereToController
                                                .selectedAreaPrice.value);
                                          },
                                          title: Text(
                                            "${snapshot.value["address"]} - ${snapshot.value['user_area']['area'] ?? ""}",
                                            style: TextStyle(fontSize: 14.sp),
                                          )));
                                    }),
                              )),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(
                    () => (whereToController.showPickUpBranches.value)
                        ? SizedBox()
                        : Button(
                            text: "add_new_address".tr,
                            isFramed: true,
                      fontSize: 14,
                            size: Get.width / 2.w,
                            height: Get.height / 20.h,
                            onPressed: () async {
                              Future.delayed(Duration(seconds: 2), () {
                                // setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddNewAddress()));
                              });
                              // });
                            },
                          ),
                  ),
                  Button(
                    isFramed: true,
                    text: 'check_out'.tr,
                    fontSize: 14,
                    size: Get.width / 2.w,
                    height: Get.height / 20.h,
                    onPressed: () async {
                      if (whereToController.showPickUpBranches.value) {
                        CacheHelper.saveDataToSharedPrefrence(
                            'dropDownValuePrice',
                            whereToController.selectedDropDownValue?.price);
                        /**************KK****/
                        Get.to(() => ReceiptScreen(
                            selectedAreaPrice: whereToController
                                .selectedDropDownValue?.price));

                        /**************KK****/
                      } else {
                        if (whereToController.radioValue.value == "") {
                          Get.defaultDialog(
                              title: "",
                              content: Text(
                                "please_choose_branch".tr,
                                style: TextStyle(fontSize: 14),
                              ));
                        } else {
                          Get.to(() => ReceiptScreen(
                              selectedAreaPrice: (whereToController
                                          .selectedAreaPrice.value !=
                                      null)
                                  ? '${whereToController.selectedAreaPrice.value}'
                                  : 0.0));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
