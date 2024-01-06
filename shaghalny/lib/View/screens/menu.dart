import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';

import '/View/components/apply_for_job_screen/job_details.dart';
import '/View/screens/Alerts/delete_account.dart';
import '/View/screens/Alerts/log_out.dart';
import '/View/screens/about_us.dart';
import '/View/screens/app_complaint.dart';
import '/View/screens/edit_personal_info.dart';
import '/color_const.dart';
import '/view/components/core/sign_in_appBar.dart';

import '../../utils/page_route.dart';
import '../components/core/custom_text.dart';
import '../components/menu_page/menu_details.dart';
import 'change_password_screen.dart';
import 'change_phoneNumber_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit =
    BlocProvider.of<PreferenceCubit>(context, listen: true);
    return  Scaffold(
      backgroundColor: primary,
      body:SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 54.h, 24.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkResponse(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              width: 20.w,
              height: 20.h,
              child: SvgPicture.asset(
                'assets/backWhite.svg',
                width: 12.w,
                height: 20.h,
              ),
            ),
          ),
            // IconButton(
            //     onPressed: (){
            //       Navigator.pop(context);
            //     },
            //     icon: SvgPicture.asset("assets/backWhite.svg")
            // ),
            SizedBox(height: 15.h),
            CustomText(
              text: "Account",
              size: 18.sp,
              weight: FontWeight.w400,
              color: Colors.white,),
            SizedBox(height: 10.h),
           /* CustomText(
              text: "Account",
              size: 18.sp,
              weight: FontWeight.w400,
              color: Colors.white,),
            SizedBox(height: 10.h),*/
            MenuDetails(text: "Edit Personal Info", svgIconPath: "assets/profile.svg",color: Colors.white,
                onTap:(){
                  AppNavigator.customNavigator(
                      context: context,
                      screen: const EditInfoScreen(),
                      finish: false);
                }  ),

            if(!preferenceCubit.userModel!.externalSignIn!)
              Column(
                children: [
                  SizedBox(height: 10.h),
                  MenuDetails(text: "Change Password", svgIconPath: "assets/lock.svg",color: Colors.white, onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                  }),
                ],
              ),
            SizedBox(height: 10.h),
            MenuDetails(text: "Change Number", svgIconPath: "assets/change number.svg",color: Colors.white,
                onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePhoneNumber()));
                }    ),
            SizedBox(height: 10.h),
            MenuDetails(text: "Delete Account", svgIconPath: "assets/delete acc.svg",color: Colors.red,
                onTap:(){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertToDeleteAccount();
                      });
                }    ),
            SizedBox(height: 10.h),
            MenuDetails(text: "Log Out", svgIconPath: "assets/log out.svg",color: Colors.red,
                onTap:(){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertToLogOut();
                      });
                }    ),
            SizedBox(height: 20.h),
            CustomText(
              text: "Help",
              size: 18.sp,
              weight: FontWeight.w400,
              color: Colors.white,),
            SizedBox(height: 10.h),
            MenuDetails(text: "About Us", svgIconPath: "assets/about us.svg",color: Colors.white,
                onTap:(){
                  AppNavigator.customNavigator(
                      context: context,
                      screen: const AboutUsScreen(),
                      finish: false);
                } ),
            SizedBox(height: 10.h),
            MenuDetails(text: "Contact Us", svgIconPath: "assets/contact us.svg",color: Colors.white,
                onTap:(){
                  AppNavigator.customNavigator(
                      context: context,
                      screen:  AppComplaint(),
                      finish: false);
                }   ),
            SizedBox(height: 10.h),
            MenuDetails(text: "Complaint", svgIconPath: "assets/Comlaint.svg",color: Colors.white,
                onTap:(){
                  AppNavigator.customNavigator(
                      context: context,
                      screen:  AppComplaint(),
                      finish: false);
                }   ),
          ],

        ),
      )





    );
  }
}
