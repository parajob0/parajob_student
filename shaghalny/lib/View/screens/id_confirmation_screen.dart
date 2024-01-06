import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shaghalny/utils/page_route.dart';
import '../components/core/loading_indicator.dart';
import '/View/screens/back_ID_scan_screen.dart';
import '/View/screens/front_ID_scan_screen.dart';
import '/View/screens/pic_ID_screen.dart';
import '/ViewModel/cubits/pic_id_cubit/pic_id_cubit.dart';
import '/view/screens/education_screen.dart';

import '../../ViewModel/cubits/ID_scan_cubit/id_scan_cubit.dart';
import '../../color_const.dart';
import '../components/core/custom_text.dart';

import '../components/core/buttons.dart';
import '../components/core/id_container.dart';
import '../components/core/sign_in_appBar.dart';
import '../components/core/skip_button.dart';
import 'app_complaint.dart';
import 'bank_information_screen.dart';

class IDConfirmation extends StatelessWidget {
  const IDConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IdScanCubit idCubit = BlocProvider.of<IdScanCubit>(context, listen: true);
    PicCubit picIdCubit = BlocProvider.of<PicCubit>(context, listen: true);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: primary,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignInAppBar(
                    text: 'ID Confirmation',
                    size: 24.sp,
                    progress: 40,
                    subText: "Scroll down to the final check",
                  ),
                  InkResponse(
                      onTap: () {
                        idCubit.showFrontEditButton();
                      },
                      child: Stack(
                        children: [
                          IDContainer(
                            hintText: '',
                            imagePath: idCubit.frontImagePath,
                          ),

                          if (idCubit.isFrontEditShown)
                            Container(
                              height: 220.h,
                              width: 342.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                                border: Border.all(color: Colors.white, width: 2.sp),
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Center(
                                child: InkResponse(
                                  onTap: (){
                                    idCubit.showFrontEditButton();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const FrontIDScan()));
                                  },
                                  child: Container(
                                    width: 65.sp,
                                    height: 65.sp,
                                    padding: EdgeInsets.all(20.0.sp),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: BoxShape.circle),
                                    child: SvgPicture.asset(
                                      'assets/edit.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )),
                  SizedBox(height: 16.h),
                  InkResponse(
                    onTap: () {
                      idCubit.showBackEditButton();
                    },
                    child: Stack(
                      children: [
                        IDContainer(
                          hintText: '',
                          imagePath: idCubit.backImagePath,
                        ),
                        if (idCubit.isBackEditShown)
                          Container(
                            height: 220.h,
                            width: 342.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.sp)),
                              border: Border.all(color: Colors.white, width: 2.sp),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Center(
                              child: InkResponse(
                                onTap: () {
                                  idCubit.showBackEditButton();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BackIDScan()));
                                },
                                child: Container(
                                  width: 65.sp,
                                  height: 65.sp,
                                  padding: EdgeInsets.all(20.0.sp),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    'assets/edit.svg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  InkResponse(
                    onTap: () {
                      picIdCubit.showEditButton();
                    },
                    child: Stack(
                      children: [
                        IDContainer(
                          hintText: '',
                          imagePath: picIdCubit.imagePath,
                        ),
                        if (picIdCubit.isEditShown)
                          Container(
                            height: 220.h,
                            width: 342.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.sp)),
                              border: Border.all(color: Colors.white, width: 2.sp),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Center(
                              child: InkResponse(
                                onTap: () {
                                  picIdCubit.showEditButton();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PIC_IDScan()));
                                },
                                child: Container(
                                  width: 65.sp,
                                  height: 65.sp,
                                  padding: EdgeInsets.all(20.0.sp),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    'assets/edit.svg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  PrimaryButton(
                      text: 'Upload',
                      onTap: () async{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Uploading Images')));
                        await idCubit.uploadImages();
                        await picIdCubit.uploadImage();
                        idCubit.isFilesUploaded && picIdCubit.isUploaded
                            ?
                       /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EducationScreen()))*/
                        AppNavigator.customNavigator(context: context, screen: EducationScreen(), finish: true)
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Something went wrong pleas try again')));
                      }),
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
        ),
        // BlocConsumer<IdScanCubit, IdScanState>(
        //   listener: (context, state) {
        //     // TODO: implement listener
        //   },
        //   builder: (context, state) {
        //     // var signJobContractCubit = SignJobContractCubit.get(context);
        //     return (idCubit.isLoading == true)
        //         ? const LoadingIndicator()
        //         : Container();
        //   },
        // ),
        (idCubit.isLoading == true || picIdCubit.isLoading == true)
            ? const LoadingIndicator()
            : Container()
      ],
    );
  }
}
