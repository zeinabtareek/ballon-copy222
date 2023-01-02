// import 'package:arrows/modules/MainBranches/models/fireBase_branches.dart';
// import 'package:arrows/modules/where_to_deliver/models/branches_addresses_model.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:get/get.dart';
//
// import '../../../helpers/shared_prefrences.dart';
//
// class MainBranchesController extends GetxController{
//
//
// FireBaseBranchesModel? mainBranchDropDownValue;
// final isLoading=false.obs; //bool variable created
// var  selectedValue ;
//
//
//   RxList<FireBaseBranchesModel> firebaseBranches = [FireBaseBranchesModel(
//
//       name_en: 'choose_branch_drop_down'.tr,
//       dataBase: 'Demo DataBase',
//       available:false,
//       name_ar: 'choose_branch_drop_down'.tr,
//       id: '',
//       address_ar: '',
//       address_en: '',
//       lat: '',
//       lng: ''
//   )].obs;
//
//   void getFirebaseBranches()async {
//     isLoading.value=true;
//     await FirebaseDatabase.instance.reference()
//         .child('branches').get().then((snapShot){
//       var values = snapShot.value;
//       values.forEach((key, value){
//         firebaseBranches.add(FireBaseBranchesModel.fromJson(value));
//         print(value);
//       });
//       isLoading.value=false;
//
//       update();
//     });
//    }
//   @override
//   void onInit() {
//     mainBranchDropDownValue =   firebaseBranches[0];
//     CacheHelper.saveDataToSharedPrefrence('restaurantBranchID',mainBranchDropDownValue!.id);
//     firebaseBranches;
//     getFirebaseBranches();
//     super.onInit();
//   }
//
//   switchFunc(value){
//       selectedValue=value;
//       update();
//    }
// }
import 'package:arrows/modules/MainBranches/models/fireBase_branches.dart';
import 'package:arrows/modules/where_to_deliver/models/branches_addresses_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../../helpers/shared_prefrences.dart';

class MainBranchesController extends GetxController {
  FireBaseBranchesModel? mainBranchDropDownValue;
  final isLoading = false.obs; //bool variable created
  var selectedValue;

  RxList<FireBaseBranchesModel> firebaseBranches = [
    FireBaseBranchesModel(
        name_en: 'choose_branch_drop_down'.tr,
        dataBase: 'Demo DataBase',
        available: false,
        name_ar: 'choose_branch_drop_down'.tr,
        id: '',
        address_ar: '',
        address_en: '',
        lat: '',
        lng: '')
  ].obs;

  List<FireBaseBranchesModel> stations = [];


  getFirebaseBranches() async {
    isLoading.value = true;
    await FirebaseDatabase.instance
        .reference()
        .child('branches')
        .get()
        .then((snapShot) {
      var values = snapShot.value;
      values.forEach((key, value) {
        stations.add(FireBaseBranchesModel.fromJson(value));
        firebaseBranches.add(FireBaseBranchesModel.fromJson(value));
        print(stations[0].id);
        CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchID', stations[0].id);
     CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchAddressAr', stations[0].address_ar);
     CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchAddressEn', stations[0].address_en);
    CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchNameAr', stations[0].name_ar);
 CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchNameEn', stations[0].name_en);
 CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchLat', stations[0].lat);
CacheHelper.saveDataToSharedPrefrence(
            'restaurantBranchLng', stations[0].lng);


      });
      isLoading.value = false;

      update();
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getFirebaseBranches();
    print(CacheHelper.getDataToSharedPrefrence('restaurantBranchID',));
    print(stations[0].lat);
  }

  switchFunc(value) {
    selectedValue = value;
    update();
  }
}