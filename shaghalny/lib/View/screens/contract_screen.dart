import 'dart:typed_data';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaghalny/Model/user_model/user_model.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/Alerts/contract_signed_successfully.dart';
import 'package:shaghalny/View/screens/bottom_navigation_screen.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/sign_job_contract/sign_job_contract_cubit.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import 'package:shaghalny/utils/contract_functions/contract_functions.dart';
import 'package:shaghalny/utils/page_route.dart';
import 'package:shaghalny/utils/snackbar.dart';
import 'package:signature/signature.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../color_const.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';

class ContractScreen extends StatefulWidget {
  ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  // String contractText =
  //     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).\n\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).";

  String contractText = '''
  1. The student confirms that he will personally appear at the job location in the specified time.
  2. The employee confirms that he is currently a student.
  3. Late check-ins lead to salary deduction.
  4. The student confirms that he has checked all the requirements, descriptions and the location of the job.
  5. Make sure to check-in/check-out o time to receive your salary.
  6. The transfer of wages will be initiated upon finishing the job shift, and you can expect to receive the amount within the next 3-7 business days
  7. Every instance of student absence will be recorded as one strike, this includes: 
      - late arrivals
      - unplanned early leaves
      - unapproved absences
  8. Accumulating 3 strikes will result in permanent suspension of the employee's account.
  ''';

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.white,
    exportBackgroundColor: primary,
    // exportPenColor: Colors.white,
    // onDrawStart: () => print('onDrawStart called!'),
    // onDrawEnd: () => print('onDrawEnd called!'),
  );
  bool checked = false;

  void initState() {
    super.initState();
    // _controller.addListener(() => print('Value changed'));
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  Future<String> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return "";
    }
    Uint8List? data = await _controller.toPngBytes();
    String s = ContractFunctions.fromImageToString(data!);
    print(s.length);
    if (data == null) {
      return "";
    }
    if (!mounted) return "";
    return s;

    // child: Container(
    //   color: Colors.transparent,
    //   child: Image.memory(data),
    // ),
  }

  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
    return BlocProvider(
      create: (context) => SignJobContractCubit(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: primary,
            body: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: InkWell(
                        onTap: () {
                          //TODO UNCOMMENT BACK BUTTON
                          //Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/backWhite.svg"),
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    CustomText(
                      text: "Sign the job contract",
                      weight: FontWeight.w600,
                      size: 24.sp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomText(
                      text: contractText,
                      weight: FontWeight.w400,
                      size: 15.sp,
                      color: hintColor,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.0.h,
                          width: 24.0.w,
                          child: BlocConsumer<SignJobContractCubit, SignJobContractState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              var cubit = SignJobContractCubit.get(context);
                              return Checkbox(
                                value: cubit.checked,
                                checkColor: Colors.black,
                                activeColor: Colors.white,
                                onChanged: (val) {
                                  cubit.changeCheckedValue();
                                  checked = cubit.checked;
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.sp),
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                      (states) =>
                                  const BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 3.h),
                            child: CustomText(
                              text:
                              "Yes, I agree to all the terms\nand conditions.",
                              weight: FontWeight.w400,
                              size: 15.sp,
                              color: hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    CustomText(
                      text: "Please sign with your signature here",
                      weight: FontWeight.w600,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Container(
                      height: 130.h,
                      child: Signature(
                        key: const Key('signature'),
                        controller: _controller,
                        height: 130.h,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const DottedLine(
                        dashLength: 5,
                        dashGapLength: 5,
                        dashGapRadius: 5,
                        dashColor: hintColor),
                    SizedBox(
                      height: 120.h,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
              child: BlocConsumer<SignJobContractCubit, SignJobContractState>(
                listener: (context, state) {
                  // TODO: implement listener
                  var signJobContractCubit = SignJobContractCubit.get(context);
                  if (state is AddContractSuccess) {
                    signJobContractCubit.changeContractLoadingIndicator(false);
                    AppNavigator.customNavigator(context: context, screen: AlertContractSigned(), finish: false);
                  }
                  if(state is AddContractFail){
                    signJobContractCubit.changeContractLoadingIndicator(false);
                  }
                },
                builder: (context, state) {
                  var signJobContractCubit = SignJobContractCubit.get(context);
                  return BlocConsumer<JobsCubit, JobsState>(
                    listener: (context, state) {
                      // TODO: implement listener

                    },
                    builder: (context, state) {
                      var jobsCubit = JobsCubit.get(context);
                      return PrimaryButton(
                        text: 'Finish',
                        onTap: () async {
                          String imageData = await exportImage(context);
                          if (checked && imageData != "") {
                            String jobid = SignJobContractCubit.jobId;
                            signJobContractCubit.changeContractLoadingIndicator(true);
                            String uid = preferenceCubit.userModel?.id??"";
                            await signJobContractCubit.addContract(userId: uid , jobID: jobid, contract: imageData,context: context);
                            jobsCubit.changeApprovedJobState(SignJobContractCubit.jobId,imageData);
                            preferenceCubit.changeJobStateInUserModel(jobId: jobid,state: '3');

                          } else {
                            snackbarMessage("Agree to the terms", context);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          BlocConsumer<SignJobContractCubit, SignJobContractState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var signJobContractCubit = SignJobContractCubit.get(context);
              return (signJobContractCubit.contractLoadingIndicator == true)
                  ? LoadingIndicator()
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}