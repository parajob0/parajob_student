import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/page_route.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/color_const.dart';

import '../../ViewModel/cubits/pic_id_cubit/pic_id_cubit.dart';
import '../components/core/id_container.dart';
import '../components/core/skip_button.dart';
import 'app_complaint.dart';
import 'id_confirmation_screen.dart';

class PIC_IDScan extends StatelessWidget {
  const PIC_IDScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PicCubit picIdCubit = BlocProvider.of<PicCubit>(context, listen: true);
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignInAppBar(text: 'Picture with ID', size: 24.sp, progress: 40, subText: "Time to verify your Identity",),

              picIdCubit.isTaken ? IDContainer(imagePath: picIdCubit.imagePath)
                  : IDContainer(imageHolder: 'assets/picID_scan.svg', hintText: 'Take a picture holding the ID',),

              SizedBox(height: 62.h),
              Row(
                children: [
                  // SvgPicture.asset('assets/check.svg', width: 16.w, height: 16.h),
                  Image.asset('assets/check.png'),
                  Expanded(
                    child: Opacity(
                        opacity: 0.7,
                        child: CustomText(text: ' Make sure you’re looking up at the camera facing the light.', weight: FontWeight.w500, size: 13.sp, color: Colors.white)
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
                        child: CustomText(text: ' Make sure the the details are easy to read.', weight: FontWeight.w500, size: 13.sp, color: Colors.white)
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              PrimaryButton(text: 'Confirm', onTap: (){
                if(picIdCubit.isTaken){
                  // picIdCubit.uploadImage(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const IDConfirmation()));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick an image or skip')));
                }

                // Navigator.push(context, MaterialPageRoute(builder: (context)=> const IDConfirmation()));
              }),
              SizedBox(height: 16.h),
              BlocConsumer<PicCubit, PicState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return SecondaryButton(text: 'Take a new pic', onTap: () async{
                    await picIdCubit.takeImage();
                  });
                },
              ),

              SizedBox(height: 16.h),
              InkResponse(onTap: (){ AppNavigator.customNavigator(context: context, screen: AppComplaint(), finish: false);},
                child: CustomText(
                    text: "Contact Us",
                    weight: FontWeight.w400,
                    size: 14.sp,
                    color: secondary),
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