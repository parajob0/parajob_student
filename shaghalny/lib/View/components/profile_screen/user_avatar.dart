import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/screens/view_profile_pic_screen.dart';
import 'package:shaghalny/ViewModel/cubits/change_profile_pic/change_profile_pic_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/utils/page_route.dart';

class UserAvatar extends StatefulWidget {
  String image;
  String level;

  UserAvatar({required this.image, required this.level});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    var preferenceCubit = PreferenceCubit.get(context);


    // print(preferenceCubit.userModel?.firstName);
    return Container(
      width: 104.w,
      height: 114.h,
      // color: Colors.red,
      child: Stack(
        children: [
          Container(
            width: 104.w,
            height: 104.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: secondary,
                  spreadRadius: 1,
                )
              ],
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () async{
                // AppNavigator.customNavigator(context: context, screen: ViewProfilePicScreen(image: image), finish: false);
                final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewProfilePicScreen(image: widget.image)),
                );
                setState(() {
                  widget.image = result; // Update the UI with the new data
                });
              },
              child: BlocConsumer<ChangeProfilePicCubit, ChangeProfilePicState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return CircleAvatar(
                    radius: 52.w,
                    backgroundImage: NetworkImage(widget.image),
                    backgroundColor: primary,
                  );
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SvgPicture.asset(
                    'assets/profileLevel.svg',
                    width: 32.w,
                    height: 33.h,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: CustomText(
                      text: "${widget.level}",
                      weight: FontWeight.w700,
                      size: 13.sp,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}