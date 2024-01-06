import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/components/menu_page/complaint_details.dart';
import '/View/components/menu_page/menu_details.dart';
import '/View/screens/Alerts/complaint_submitted.dart';
import '/View/screens/edit_personal_info.dart';
import '/ViewModel/cubits/complaints_review_cubit/complaint_review_cubit.dart';
import '/color_const.dart';
import '/view/components/core/multiline_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Model/admin_model/admin_model.dart';
import '../../Model/user_model/user_model.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../components/core/custom_text.dart';
import 'home_screen.dart';


class AppComplaint extends StatelessWidget {
  AppComplaint({Key? key}) : super(key: key);
  String? supportMail;
  String? supportNumber;
  String firstName="UserModel.getFirstName()";
  String lastName="UserModel.getLastName()";
  late String fullName="$firstName $lastName";
 static GlobalKey<FormState> complaintKey = new GlobalKey<FormState>();
  TextEditingController complaintController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    /*FirebaseFirestore.instance.collection("admin").doc('ijON2lGYNt410JUskAcc').get().then((value){
      supportMail=value.data()!['support_mail'];
      supportNumber=value.data()!['support_number'];

      AdminModel.setSupportMail(supportMail!);
      AdminModel.setSupportNumber(supportNumber!);
      print(AdminModel.getSupportMail());
      print(AdminModel.getSupportNumber());
    });*/
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);

    return BlocConsumer<ComplaintReviewCubit, ComplaintReviewState>(
  listener: (context, state) {},
  builder: (context, state) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: 1.sh - 0.04.sh,
          padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkResponse(
                onTap: () {Navigator.pop(context);},
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  child: SvgPicture.asset(
                    'assets/backWhite.svg',
                    width: 12.w,
                    height: 20.h,),
                ),),
              SizedBox(height: 25.h),
              CustomText(
                text: "Complaint or Suggest",
                size: 24.sp,
                weight: FontWeight.w400,
                color: Colors.white,),
              SizedBox(height: 10.h),
              MultiLineTextField(
                hintText: "Share your issues with us..",
                formKey: complaintKey,
                controller: complaintController,
                onchange: (val) {
                  print(val);
                },
                onTap: ()  {

                },
                validate: (text) {
                  if (text==null||text.isEmpty) {
                    return 'Must enter data';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Contact us",
                size: 24.sp,
                weight: FontWeight.w600,
                color: Colors.white,),
              SizedBox(height: 10.h),
              ComplaintDetails(text: "Email us on", subText: preferenceCubit.adminModel!.supportMail, width: 12.sp, color: Colors.white,
              onTap: (){},),
              SizedBox(height: 10.h),
              ComplaintDetails(text: "By phone", subText: preferenceCubit.adminModel!.supportNumber, width: 12.sp, color: Colors.white,
                onTap: (){},),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.w),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryButton(
                    text: 'Submit your complaint',
                    onTap: ()  {if (complaintKey.currentState!.validate()) {
                      ComplaintReviewCubit.get(context).appComplaint(
                          id: preferenceCubit.userModel!.id,
                          complaint: complaintController.text);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertComplaintSubmitted();
                          });
                    }
                    }),
                SizedBox(height: 15.h),
              ])
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  },
);
  }
}