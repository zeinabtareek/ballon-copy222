import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/more_info_constants.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../modules/search/search_screen.dart';

class ArrowsAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final Widget? icon;

  ArrowsAppBar(
    this.title, {
    this.icon,
    Key? key,
  })  : preferredSize = Size.fromHeight(70.h),
        super(key: key);

  @override
  State<ArrowsAppBar> createState() => _ArrowsAppBarState();
}

class _ArrowsAppBarState extends State<ArrowsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      title: Image.asset(
        'assets/images/appBar.png',
        // width: 120.w,
        height: 35.h,
        fit: BoxFit.cover,
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            icon: Icon(
              Icons.search,
              color: Colors.grey,
              size: 30.sp,
            )),
      ],
      leading: widget.icon,
    );
  }
}
