import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/more_info_constants.dart';
import 'package:arrows/helpers/map_launch_helper.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/MainBranches/controllers/main_branches_controller.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/home/controllers/home_controller.dart';
import 'package:arrows/modules/main_category/controllers/main_categories_controller.dart';
import 'package:arrows/modules/more_info/controllers/more_info_controller.dart';
import 'package:arrows/modules/sign_up/controllers/signup_controller.dart';
import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:arrows/shared_object/firebase_order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import '../../../components/arrows_app_bar.dart';
import '../../../components/custom_button.dart';
import '../../../components/loading_spinner.dart';
import '../../../constants/styles.dart';
import '../../chat_screen/chat_screen.dart';
import '../../sign_up/screens/sign_up_screen.dart';
import 'barcod_screen.dart';

class MoreInfoScreen extends StatefulWidget {
  MoreInfoScreen({Key? key}) : super(key: key);


  @override
  State<MoreInfoScreen> createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends State<MoreInfoScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  final moreInfoController = Get.put(MoreInfoController());

  final cartController = Get.put(CartController());
  final moreController = Get.put(MainBranchesController());
  final SignUpController signUpController = Get.put(SignUpController());

  late AnimationController transitionAnimationController;

  @override
  void initState() {
    cartController.totalPoints;
    transitionAnimationController = BottomSheet.createAnimationController(this);
    transitionAnimationController.duration = Duration(seconds: 1);

    super.initState();
  }

  Order? order;


  void dispose() {
    transitionAnimationController.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainBranchesController mainBranchesController =
    Get.put(MainBranchesController());
    final   whereToController = Get.put(WhereToController());

    Future.delayed(const Duration(seconds: 1), () {
      CacheHelper.getDataToSharedPrefrence("localeIsArabic");
      cartController.update();
      cartController.getSystemPoints();
    });

    return Obx(() =>
    moreInfoController.isLoading.value
        ? Center(
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: mainColor,
              ),
            ),
          )),
    )
        : Scaffold(
      appBar: ArrowsAppBar('${k.restName}'.tr,
          icon: PopupMenuButton<int>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Get.locale!.languageCode == "ar"
                        ? Text("english")
                  :  Text("arabic".tr),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: 50.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(50),
                          shape: BoxShape.circle,
                          border: Border.all(color: mainColor)),
                      child: Image.asset(Get.locale!.languageCode == "ar"
                          ? "assets/images/en.png"
                          : "assets/images/ar.png"
                      ),
                    ),
                  ],
                ),
              ),
              // PopupMenuItem 2
            ],
            offset: Offset(0, 100),
            color: Colors.white,
            elevation: 2,
            icon: Icon(Icons.settings, color: mainColor,size: 20.sp,),
            // on selected we show the dialog box
            onSelected: (value) async {
              Get.delete<HomeController>();

              // if value 1 show dialog
              if (Get.locale!.languageCode == "ar") {
                mainBranchesController.switchFunc('en');
                Get.updateLocale(
                    Locale(mainBranchesController.selectedValue));
              await  CacheHelper.saveDataToSharedPrefrence("localeIsArabic", false);
              } else {
                mainBranchesController.switchFunc('ar');
                Get.updateLocale(
                    Locale(mainBranchesController.selectedValue));
                await CacheHelper.saveDataToSharedPrefrence("localeIsArabic", true);

              }

            },
          )),
      body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              child: Padding(
                  padding:
                  EdgeInsets.only(top: 35.h, right: 10.w, left: 10.w),
                  child: GetBuilder<CartController>(
                      init: CartController(),
                      builder: (cartController) {
                        return ListView(
                          shrinkWrap: true,
                          controller: _scrollController,
                          children: [

                            FutureBuilder(
                                future: cartController.getUserPoints(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasError) {
                                    return SizedBox();
                                  } else if (cartController.totalPoints !=
                                      0 &&
                                      cartController.totalPoints != '0' &&
                                      cartController.forsale != null &&
                                      cartController.totalPoints != null) {
                                    return GetBuilder<MoreInfoController>(
                                        init: MoreInfoController(),
                                        builder: (controller) {
                                          return (cartController
                                              .totalPoints !=
                                              0 &&
                                              cartController
                                                  .totalPoints !=
                                                  '0' &&
                                              cartController.forsale !=
                                                  null &&
                                              cartController
                                                  .totalPoints !=
                                                  null)
                                              ? SizedBox(
                                            height: Get.height / 10.h, //*****
                                          )
                                              : SizedBox();
                                        });
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.pinkAccent
                                      .shade100
                                      .withOpacity(.7),

                                  radius: 20.r,
                                  child: IconButton(
                                    onPressed: () {
                                      Get.to(BarcodeScreen());
                                    },
                                    icon: ImageIcon(
                                      AssetImage(
                                          "assets/icons/gift.png"),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.pinkAccent
                                      .shade100
                                      .withOpacity(.7),
                                  radius: 20.r,
                                  child: IconButton(
                                      onPressed: () {
                                        Get.to(ChatScreen());
                                      },
                                      icon: Icon(
                                        Icons.chat,
                                        size: 18.sp,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                            Obx(() {
                              return (whereToController.branches.length == 1)
                                  ? SizedBox()
                                  : Text(
                                "branches".tr,
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                            // ListView.builder(
                            //     shrinkWrap: true,
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: 1,
                            //     itemBuilder: (context, index) {
                            //       if (whereToController.branches.length ==
                            //           1) {
                            //         print("empty");
                            //         return const SizedBox();
                            //       } else {
                            //         if (index == 0) {
                            //           return const SizedBox();
                            //         } else {
                            //           return InkWell(
                            //             onTap: () {
                            //               print(CacheHelper
                            //                   .getDataToSharedPrefrence(
                            //                   'restaurantBranchLat'));
                            //             },
                            //             child: Stack(children: [
                            //               Image.asset(
                            //                 'assets/images/cloud.png',
                            //                 // height: 30.h,
                            //                 width: Get.width,
                            //                 fit: BoxFit.fill,
                            //               ),
                            //               Positioned(
                            //                 left: 22.w,
                            //                 right: 22.w,
                            //                 top: 5.h,
                            //                 bottom: 5.h,
                            //                 child: Row(
                            //                   children: [
                            //                     Icon(
                            //                       Icons.location_on_sharp,
                            //                       size: 30.r,
                            //                       color: kPrimaryColor,
                            //                     ),
                            //                     SizedBox(
                            //                       width: ScreenUtil
                            //                           .defaultSize.width -
                            //                           50.w,
                            //                       child: Column(
                            //                         mainAxisAlignment:
                            //                         MainAxisAlignment
                            //                             .start,
                            //                         crossAxisAlignment:
                            //                         CrossAxisAlignment
                            //                             .start,
                            //                         children: [
                            //                           Text('branch'),
                            //                           Text('')
                            //
                            //                         ],
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ]),
                            //           );
                            //         }
                            //       }
                            //     }),
                            Obx(() {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  // itemCount:1,
                                  itemCount: whereToController.branches
                                      .toSet()
                                      .length,
                                  itemBuilder: (context, index) {
                                    if (whereToController.branches.length >
                                        1) {
                                      print("empty");
                                      return const SizedBox();
                                    }
                                    else {
                                      return Theme(
                                          data: ThemeData(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              MapUtils.openMap(
                                                //
                                                double.parse(CacheHelper
                                                    .getDataToSharedPrefrence(
                                                    'restaurantBranchLat') ??
                                                    ""),
                                                double.parse(CacheHelper
                                                    .getDataToSharedPrefrence(
                                                    'restaurantBranchLng') ??
                                                    ""),);
                                            },
                                            child: Stack(children: [
                                              Image.asset(
                                                'assets/images/cloud.png',
                                                height: 120.h,
                                                width: Get.width,
                                                fit: BoxFit.fill,
                                              ),
                                              Positioned(
                                                top: 5.h,
                                                bottom: 5.h,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    Icon(
                                                      // Icons.library_add,
                                                      Icons.location_on_sharp,
                                                      size: 30.r,
                                                      color: mainColor,
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    SizedBox(
                                                      width: ScreenUtil
                                                          .defaultSize.width.w,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Text('${CacheHelper
                                                              .getDataToSharedPrefrence(
                                                              'restaurantBranchID')}',style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.bold
                                                          ),),
                                                          mainBranchesController
                                                              .selectedValue ==
                                                              'ar'
                                                              ?
                                                          Text('${CacheHelper
                                                              .getDataToSharedPrefrence(
                                                              'restaurantBranchAddressAr')}')
                                                              :
                                                          Text('${CacheHelper
                                                              .getDataToSharedPrefrence(
                                                              'restaurantBranchAddressEn')}',style: TextStyle(
                                                            fontSize: 14.sp,fontWeight: FontWeight.bold
                                                          ),),


                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),)
                                      );
                                    }
                                  });
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(() {
                              return (moreInfoController
                                  .restaurantPhoneNumbers.isEmpty)
                                  ? const SizedBox()
                                  : Text(
                                "contact_us".tr,
                                style: TextStyle(
                                    color: mainColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                            Obx(() {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(bottom: 20),
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  itemCount:  moreInfoController
                                      .restaurantPhoneNumbers
                                      .toSet()
                                      .length-1,
                                   itemBuilder: (context, index) {
                                    return (moreInfoController
                                        .restaurantPhoneNumbers[
                                    index] !=
                                        'null')
                                        ? Theme(
                                        data: ThemeData(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: InkWell(
                                            onTap: () {
                                              MapUtils.makePhoneCall(
                                                  moreInfoController
                                                      .restaurantPhoneNumbers[
                                                  index]
                                                      .toString());
                                            },
                                            child: Theme(
                                              data: ThemeData(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors
                                                    .transparent,
                                              ),
                                              child: Stack(children: [
                                                Image.asset(
                                                  'assets/images/cloud.png',
                                                  height: 50.h,
                                                  width: Get.width,
                                                  fit: BoxFit.fill,
                                                ),
                                                Positioned(
                                                  left: 22.w,
                                                  right: 22.w,
                                                  top: 5.h,
                                                  bottom: 5.h,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.phone,
                                                        size: 30.r,
                                                        color: mainColor,
                                                      ),
                                                      SizedBox(
                                                        width: 20.w,
                                                      ),
                                                      Text(
                                                        moreInfoController
                                                            .restaurantPhoneNumbers[
                                                        index]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        )
                                    )
                                        : const SizedBox();
                                  });
                            }),
                            Text(
                              "socials".tr,
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: InkWell(
                                  onTap: () {
                                    MapUtils.launchInBrowser(moreInfoController
                                        .restaurantMoreInfo!.facebook
                                        .toString());
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/cloud.png',
                                        height: 50.h,
                                        width: Get.width,
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        left: 22.w,
                                        right: 22.w,
                                        top: 5.h,
                                        bottom: 5.h,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.facebook_sharp,
                                              size: 30.r,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Text(
                                              "facebook".tr,
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: InkWell(
                                  onTap: () {
                                    MapUtils.launchInBrowser(moreInfoController
                                        .restaurantMoreInfo!.instagram
                                        .toString());
                                  },
                                  child: Theme(
                                    data: ThemeData(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/cloud.png',
                                          height: 50.h,
                                          width: Get.width,
                                          fit: BoxFit.fill,
                                        ),
                                        Positioned(
                                          left: 22.w,
                                          right: 22.w,
                                          top: 5.h,
                                          bottom: 5.h,
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.instagram,
                                                size: 30.r,
                                                color: Colors.pinkAccent
                                                    .shade100
                                                    .withOpacity(.7),
                                              ),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Text(
                                                "instagram".tr,
                                                style: TextStyle(
                                                    fontSize: 16.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.sp),
                                child: InkWell(
                                  onTap: () {
                                    MapUtils.launchInBrowser(moreInfoController
                                        .restaurantMoreInfo!.website
                                        .toString());
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/cloud.png',
                                        height: 50.h,
                                        width: Get.width,
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        left: 22.w,
                                        right: 22.w,
                                        top: 5.h,
                                        bottom: 5.h,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FaIcon(FontAwesomeIcons.globe,
                                                size: 30.r, color: Colors.blue),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Text(
                                              k.restWebSite.tr,
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /***********************v***/
                            SizedBox(
                              height: 20.h,
                            ),
                            /***********************v***/
                           GetBuilder<WhereToController>(
                             init:WhereToController(),
                                 builder:(whereToController)=> Center(
                              child: Button(
                                  isFramed: true,
                                  text: 'delete_account'.tr,
                                  fontSize: 14,
                                  // size: 50,
                                  size: Get.width/2,
                                  height:Get.height/20.h,

                                  onPressed: ()async {
                                    if (CacheHelper.loginShared == null) {
                                      Get.defaultDialog(
                                          title: 'error'.tr,
                                          content: Text('no_account'.tr));
                                    } else {
                                      Get.defaultDialog(
                                        title: 'delete_account_alert'.tr,
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                child: Text(
                                                  'yes'.tr,
                                                  style: TextStyle(color: kPrimaryColor),
                                                ),
                                                onPressed:()async {
                                                  await FirebaseDatabase
                                                      .instance
                                                      .reference()
                                                      .child('Cart')
                                                      .child(CacheHelper
                                                      .getDataToSharedPrefrence(
                                                      'restaurantBranchID'))
                                                      .child(CacheHelper
                                                      .getDataToSharedPrefrence(
                                                      'userID'))
                                                      .remove()
                                                      .then((_) async {
                                                    await FirebaseDatabase
                                                        .instance
                                                        .reference()
                                                        .child('Orders')
                                                        .child(CacheHelper
                                                        .getDataToSharedPrefrence(
                                                        'restaurantBranchID'))
                                                        .remove()
                                                        .then((_) async {
                                                        FirebaseDatabase
                                                          .instance
                                                          .reference()
                                                          .child(
                                                          'UserOrders')
                                                          .child(CacheHelper
                                                          .getDataToSharedPrefrence(
                                                          'restaurantBranchID'))
                                                          .child(CacheHelper
                                                          .getDataToSharedPrefrence(
                                                          'userID'))
                                                          .remove()
                                                          .then((_) async {
                                                        await FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child('Users')
                                                            .child(CacheHelper
                                                            .getDataToSharedPrefrence(
                                                            'userID'))
                                                            .remove();
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!=null?
                                                        await FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .delete()
                                                            .then((_) async {
                                                          setState(() {
                                                            cartController
                                                                .update();
                                                            whereToController
                                                                .update();
                                                          });
                                                          await CacheHelper
                                                              .saveDataToSharedPrefrence(
                                                              "user",
                                                              null);
                                                          final user =
                                                          await FirebaseAuth
                                                              .instance;
                                                          user.currentUser!
                                                              .delete();
                                                          setState(() {
                                                            CacheHelper
                                                                .loginShared =
                                                            null;
                                                            cartController
                                                                .cartItemList2
                                                                .clear();

                                                            order != null
                                                                ? order!
                                                                .list_of_product
                                                                .clear()
                                                                : null;
                                                            signUpController
                                                                .fullPhoneNumber =
                                                            '';
                                                            signUpController
                                                                .pinTextEditingController
                                                                .clear();
                                                            signUpController
                                                                .phoneTextEditingController
                                                                .clear();

                                                            setState(() {
                                                              cartController
                                                                  .update();
                                                              whereToController
                                                                  .update();
                                                              CacheHelper.loginShared=null;
                                                            });
                                                          });
                                                        }):print('retry');
                                                      });
                                                    });
                                                  });
                                                  Get.back();
                                                  Get.snackbar(
                                                      '',
                                                      'deletion_successful'
                                                          .tr);
                                                }),
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  'no'.tr,
                                                  style: TextStyle(
                                                      color: mainColor),
                                                )),
                                            SizedBox(
                                              height: 50.h,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        );
                      })),
            ),
            /******points******/
            FutureBuilder(
              future: cartController.getUserPoints(),
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return SizedBox();
                } else if (cartController.totalPoints != 0 &&
                    cartController.totalPoints != '0' &&
                    cartController.forsale != null &&
                    cartController.totalPoints != null) {
                  return GetBuilder<MoreInfoController>(
                      init: MoreInfoController(),
                      builder: (controller) {
                        return Positioned(
                          // top: 0,
                          child: new Container(
                            height:90.h,
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5.h,
                                  right: 50.w,
                                  left: 30.w,
                                  child: Column(
                                    children: [
                                      Card(
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(15.r))),
                                          elevation: 3,
                                          color: mainColor,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'balance'.tr,
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.white),
                                              ),
                                              cartController.balance != null
                                                  ? Text(
                                                '${cartController.balance
                                                    .toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    // height: 2,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )
                                                  : Text('0'),
                                            ],
                                          )),
                                      Card(
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                  Radius.circular(15))),
                                          elevation: 3,
                                          color: mainColor,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'your_points'.tr,
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.white),
                                              ),
                                              cartController.balance != null
                                                  ? Text(
                                                  '${cartController
                                                      .totalPoints}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,

                                                      // height: 2,
                                                      fontSize: 16.sp,
                                                      color: Colors.white))
                                                  : Text('0'),
                                            ],
                                          )),

                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 2.h,
                                  right: 10.w,
                                  child: InkWell(
                                    onTap: () {
                                      print('helo');
                                      print(CacheHelper.loginShared!.phone);
                                      print('*******${FirebaseAuth.instance
                                              .currentUser!.phoneNumber}');
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                        'assets/images/point.png',),
                                      radius: 40.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return SizedBox();
                }
              },
            ),
          ])),
      floatingActionButton: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ScrollingFabAnimated(
              color: Colors.pinkAccent.shade100.withOpacity(.7),
              icon: Icon(
                Icons.contact_support_outlined,
                color: Colors.white,
                semanticLabel: ' Feedback',
                size: 25.sp,
              ),
              text: Text(
                'Feedback',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w400),
              ),
              onPress: () {
                showModalBottomSheet<void>(
                    barrierColor: kPrimaryColor.withOpacity(.49),
                    backgroundColor: mainColor,
                    isScrollControlled: true,
                    context: context,
                    transitionAnimationController:
                    transitionAnimationController,
                    builder: (BuildContext context) {
                      return AnimatedContainer(
                        // margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            // color: Colors.white,

                              borderRadius: BorderRadius.circular(30)),
                          duration: Duration(seconds: 1),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery
                                      .of(context)
                                      .viewInsets
                                      .bottom),
                              child: AnimatedCrossFade(
                                firstChild: Form(
                                    key: moreInfoController.formKey,
                                    child: GetBuilder<MoreInfoController>(
                                      init: MoreInfoController(),
                                      builder: (controller) =>
                                          Padding(
                                            padding: EdgeInsets.all(5.0.sp),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  autofocus: true,
                                                  // controller.passwordVisible.value,
                                                  maxLines: 4,
                                                  controller: controller
                                                      .feedbackMessageController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                    'send_feedback'.tr,
                                                    labelStyle: TextStyle(
                                                        color: kPrimaryColor),
                                                    isDense: true,
                                                    // Added this
                                                    contentPadding:
                                                    EdgeInsets.all(13.w),
                                                    hintStyle: TextStyle(
                                                        color: kPrimaryColor),
                                                    border:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.red,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8.r),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 2.w,
                                                        color: kPrimaryColor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8.r),
                                                    ),
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: kPrimaryColor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8.r),
                                                    ),
                                                    disabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: kPrimaryColor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8.r),
                                                    ),
                                                    filled: true,
                                                  ),

                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                Button(
                                                  text: 'send_feedback'.tr,
                                                  size: 250,
                                                  height: Get.height / 20.h,
                                                  onPressed: () async {
                                                    if (moreInfoController
                                                        .formKey.currentState!
                                                        .validate()) {
                                                      if (CacheHelper
                                                          .loginShared ==
                                                          null) {
                                                        showLoaderDialog(
                                                            context);
                                                        Get.offAll(
                                                            SignUpScreen());
                                                      } else {
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child(
                                                            "FeedbackMessages")
                                                            .push()
                                                            .set({
                                                          'feedbackMessage':
                                                          moreInfoController
                                                              .feedbackMessageController
                                                              .text,
                                                          'userName':
                                                          CacheHelper
                                                              .loginShared!
                                                              .name,
                                                          'userPhone':
                                                          CacheHelper
                                                              .loginShared!
                                                              .phone,
                                                        }).then((value) {
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        });
                                                        Get.back();
                                                      }
                                                    } else {
                                                      Get.snackbar(
                                                          'error'.tr, '',
                                                          snackPosition:
                                                          SnackPosition
                                                              .TOP,
                                                          backgroundColor:
                                                          kPrimaryColor,
                                                          duration: Duration(
                                                              microseconds:
                                                              400),
                                                          dismissDirection:
                                                          DismissDirection
                                                              .startToEnd,
                                                          barBlur: 10,
                                                          colorText:
                                                          mainColor);
                                                    }
                                                    moreInfoController
                                                        .feedbackMessageController
                                                        .clear();
                                                  },
                                                  isFramed: false,
                                                )
                                              ],
                                            ),
                                          ),
                                    )),
                                duration: Duration(seconds: 1),
                                secondChild: SizedBox(),
                                crossFadeState: CrossFadeState.showFirst,
                              )));
                    });
              },
              scrollController: _scrollController,
              animateIcon: true,
              limitIndicator: 5,
              inverted: false,
              width: Get.width / 3,
              height: Get.height / 18.h
            // radius: 30.0,

          )),
    ));
  }
}
