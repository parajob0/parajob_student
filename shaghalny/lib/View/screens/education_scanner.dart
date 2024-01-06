import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/page_route.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/screens/bank_information_screen.dart';
import '/View/screens/pic_ID_screen.dart';
import '/ViewModel/cubits/education_scanner_cubit/education_scanner_cubit.dart';
import '/color_const.dart';
import '../../ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';
import '../components/core/id_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../components/core/skip_button.dart';
import 'back_ID_scan_screen.dart';

class EducationScanner extends StatelessWidget {
  const EducationScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EducationScannerCubit idCubit = BlocProvider.of<EducationScannerCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignInAppBar(text: 'Education', size: 24.sp, progress: 60, subText: "It's Time to verify your University",),

              idCubit.idScanned ? IDContainer(imagePath: idCubit.imagePath)
                  : IDContainer(imageHolder: 'assets/id_scan.svg', hintText: 'education',),

              SizedBox(height: 16.h),
              Row(
                children: [
                  // SvgPicture.asset('assets/check.svg', width: 16.w, height: 16.h),
                  Image.asset('assets/check.png'),
                  Expanded(
                    child: Opacity(
                        opacity: 0.7,
                        child: CustomText(text: ' Make sure your surroundings are well-lit.', weight: FontWeight.w500, size: 13.sp, color: Colors.white)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SvgPicture.asset('assets/check.svg', width: 16.w, height: 16.h),
                  Image.asset('assets/check.png'),
                  Expanded(
                    child: Opacity(
                        opacity: 0.7,
                        child: CustomText(text: ' Make sure the photo is inside the frame and details are easy to read.', weight: FontWeight.w500, size: 13.sp, color: Colors.white)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              PrimaryButton(text: 'Confirm', onTap: (){
                if(idCubit.idScanned){
                  idCubit.uploadImage(context);
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>BankInformation()));*/
                  AppNavigator.customNavigator(
                      context: context,
                      screen: BankInformation(),
                      finish: true);
                } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick an image or skip')));
                }

              }),
              SizedBox(height: 16.h),
              BlocConsumer<EducationScannerCubit, EducationScannerState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return SecondaryButton(text: 'Take a new pic', onTap: () async{
                    await idCubit.scanID();
                  },);
                },
              ),

              SizedBox(height: 16.h),
              const SkipButton(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}