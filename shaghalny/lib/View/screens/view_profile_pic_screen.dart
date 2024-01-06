import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shaghalny/View/components/core/bottom_sheet_item.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/View/screens/edit_photo_screen.dart';
import 'package:shaghalny/View/screens/profile_screen.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/utils/image_helper/image_helper.dart';
import 'package:shaghalny/utils/page_route.dart';
import '../../ViewModel/cubits/change_profile_pic/change_profile_pic_cubit.dart';

class ViewProfilePicScreen extends StatefulWidget {
  String image;

  ViewProfilePicScreen({required this.image});

  @override
  State<ViewProfilePicScreen> createState() => _ViewProfilePicScreenState();
}

class _ViewProfilePicScreenState extends State<ViewProfilePicScreen> {
  ImageHelper imageHelper = ImageHelper();

  @override
  Widget build(BuildContext context) {
    var preferenceCubit = PreferenceCubit.get(context);
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context,preferenceCubit.userModel?.profilePic??"");
        return false;
      },
      child: Scaffold(
        backgroundColor: primary,
        // color: Colors.blue,
        body: BlocConsumer<ChangeProfilePicCubit, ChangeProfilePicState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            var cubit = ChangeProfilePicCubit.get(context);
            return Stack(
              fit: StackFit.expand,
              children: [
                // iIMAGE
                (cubit.selectedImage == null)
                    ? Image.network(preferenceCubit.userModel?.profilePic??"")
                    : Image.file(File(cubit.selectedImage?.path ?? "")),

                // Content
                InteractiveViewer(
                  scaleEnabled:false,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.srcOut),
                    // This one will create the magic
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // grey container
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.dstIn,
                          ), // This one will handle background + difference out
                        ),
                        // white circle
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 380.sp,
                            width: 380.sp,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(390.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // APP BAR
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 0),
                  child: Container(
                    height: 30.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context,preferenceCubit.userModel?.profilePic??"");
                            },
                            child: SvgPicture.asset(
                              'assets/backWhite.svg',
                              width: 12.w,
                              height: 16.h,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            if (cubit.selectedImage != null)
                              BlocConsumer<ChangeProfilePicCubit, ChangeProfilePicState>(
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  var cubit = ChangeProfilePicCubit.get(context);
                                  return Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () async {
                                        final uid =
                                            CacheHelper.getData(key: "uid");
                                        String newPic = await cubit.uploadNewProfilePic(uid, cubit.selectedImage!, preferenceCubit);
                                        widget.image = newPic;
                                        cubit.selectedImage = null;
                                        print("saved");
                                      },
                                      child: CustomText(
                                        text: 'Save',
                                        weight: FontWeight.w500,
                                        size: 16.sp,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: primary,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              24.w, 0, 24.w, 0),
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Container(
                                                width: 50.w,
                                                height: 3.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.sp),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 27,
                                              ),
                                              BottomSheetItem(
                                                text: "Choose photo",
                                                ontap: () async {
                                                  final image =
                                                      await imageHelper
                                                          .pickImage();
                                                  if (image != null) {
                                                    final croppedImage =
                                                        await imageHelper
                                                            .cropImage(
                                                                file: image);
                                                    if (croppedImage != null) {
                                                      //save image
                                                      cubit.setSelectedImage(File(
                                                          croppedImage.path));
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                },
                                                editProfilePic: true,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              BottomSheetItem(
                                                text: "Take photo",
                                                ontap: () async {
                                                  final ImagePicker picker =
                                                      ImagePicker();
                                                  // Pick an image.
                                                  final XFile? image =
                                                      await picker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera)
                                                          .then((value) async {
                                                    print("----------------");
                                                    print(value?.path);
                                                    print("----------------");
                                                    if (value != null) {
                                                      final croppedImage =
                                                          await imageHelper
                                                              .cropImage(
                                                                  file: value);
                                                      if (croppedImage !=
                                                          null) {
                                                        //save image
                                                        cubit.setSelectedImage(File(
                                                            croppedImage
                                                                .path));
                                                        Navigator.pop(
                                                            context);
                                                      }
                                                    }
                                                  });
                                                  if (image != null) {
                                                    AppNavigator.customNavigator(
                                                            context: context,
                                                            screen:
                                                                EditPhotoScreen(
                                                                    image:
                                                                        image),
                                                            finish: false);
                                                  }
                                                },
                                                editProfilePic: true,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              BottomSheetItem(
                                                text: "Remove photo",
                                                ontap: () {},
                                                editProfilePic: true,
                                                textColor: Colors.red,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: CustomText(
                                  text: 'Edit',
                                  weight: FontWeight.w500,
                                  size: 16.sp,
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              (state is UploadNewProfilePicLoading)?LoadingIndicator():Container(),

              ],
            );
          },
        ),
      ),
    );
  }
}
