import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/screens/Alerts/complaint_submitted.dart';
import '/View/screens/app_complaint.dart';
import '/ViewModel/cubits/complaints_review_cubit/complaint_review_cubit.dart';
import '/color_const.dart';
import '/view/components/core/multiline_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Model/user_model/user_model.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../components/core/custom_text.dart';

class SubmitComplaintAboutJob extends StatelessWidget {
  String jobId;
  String employerName;

  SubmitComplaintAboutJob({required this.jobId, required this.employerName, Key? key}) : super(key: key);
  String firstName = "UserModel.getFirstName()";
  String lastName = "UserModel.getLastName()";
  late String fullName = "$firstName $lastName";
  GlobalKey<FormState> complaintKey = new GlobalKey<FormState>();
  TextEditingController complaintController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    PreferenceCubit prefCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    return BlocConsumer<ComplaintReviewCubit, ComplaintReviewState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primary,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkResponse(
                    onTap: () {Navigator.pop(context);},
                    child: SvgPicture.asset(
                      'assets/backWhite.svg',
                      width: 12.w,
                      height: 20.h,),),
                  SizedBox(height: 25.h),
                  CustomText(
                    text: "Submit a complaint",
                    size: 24.sp,
                    weight: FontWeight.w400,
                    color: Colors.white,),
                  Row(
                    children: [
                      CustomText(
                        text: "about ",
                        size: 12.sp,
                        weight: FontWeight.w400,
                        color: Colors.grey,),
                      CustomText(
                        text: "$employerName's job",
                        size: 12.sp,
                        weight: FontWeight.w400,
                        color: Colors.white,),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  /*SignInAppBar(
                      text: 'Submit a complaint',
                      size: 24.sp,
                      progress: 0,
                      subText: "about ",
                      showProgressBar: false),*/
                  MultiLineTextField(
                    hintText: "Share your issues with us..",
                    formKey: complaintKey,
                    controller: complaintController,
                    onchange: (val) {
                      print(val);
                    },
                    onTap: () {},
                    validate: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Must enter data';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0.w, 24.w, 0.w),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                PrimaryButton(
                    text: 'Submit your complaint',
                    onTap: () {if (complaintKey.currentState!.validate()) {
                        ComplaintReviewCubit.get(context).complaintAboutJob(
                          prefCubit,
                          jobId:jobId,
                          complaint: complaintController.text);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertComplaintSubmitted();
                          });
                    }
                    }),
                SizedBox(height: 15.h),
              ])),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
