import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/custom_text.dart';
import '/View/screens/submit_review.dart';
import '/color_const.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Model/employer_model/employer_model.dart';
import '../../Model/review_model/ReviewModel.dart';
import '../../ViewModel/cubits/employer_page_cubit/employer_page_cubit.dart';
import '../components/core/rated_bar.dart';
import '../components/reviews_screen/review_container.dart';

class ReviewScreen extends StatelessWidget {


  List<ReviewModel> reviewModel;
  EmployerModel employerModel;


  ReviewScreen({required this.reviewModel, required this.employerModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/back.svg',
                    color: Colors.white,
                    width: 12.w,
                    height: 20.h,
                  ),
                ),
                SizedBox(height: 5.5.h),
                CustomText(
                    text: 'Reviews',
                    weight: FontWeight.w600,
                    size: 22.sp,
                    color: Colors.white),
                SizedBox(height: 4.5.h),
                RatedBar(rating: employerModel.rate),
                SizedBox(height: 0.h),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviewModel.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ReviewContainer(
                            name: reviewModel[index].userName,
                            rate: double.parse(reviewModel[index].rate),
                            review: reviewModel[index].review,
                            date: "${reviewModel[index].date.day}."
                                "${reviewModel[index].date.month}."
                                "${reviewModel[index].date.year}",
                          ),
                          SizedBox(height: 8.h),
                        ],
                      );
                    }),
                SizedBox(height: 70.h),
              ],
            ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: PrimaryButton(text: 'Leave a review', onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitReview(employerId: employerModel.id,employerName:employerModel.name, rate: employerModel.rate)));
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    //
    // return BlocProvider(
    //   //todo add employer id
    //   create: (context) =>
    //       EmployerPageCubit()
    //         ..getEmployerData(id: 'dFodxnQKbxvC287ojVTB'),
    //   child: Scaffold(
    //     backgroundColor: primary,
    //     body: SingleChildScrollView(
    //       physics: const BouncingScrollPhysics(),
    //       padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 0),
    //       child: BlocConsumer<EmployerPageCubit, EmployerPageState>(
    //         listener: (context, state) {
    //           // TODO: implement listener
    //         },
    //         builder: (context, state) {
    //           EmployerPageCubit employerCubit = EmployerPageCubit.get(context);
    //           return employerCubit.employerModel == null
    //               ? const Center(
    //                   child: CircularProgressIndicator(
    //                     color: secondary,
    //                   ),
    //                 )
    //               : Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     InkResponse(
    //                       onTap: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: SvgPicture.asset(
    //                         'assets/back.svg',
    //                         color: Colors.white,
    //                         width: 12.w,
    //                         height: 20.h,
    //                       ),
    //                     ),
    //                     SizedBox(height: 5.5.h),
    //                     CustomText(
    //                         text: 'Reviews',
    //                         weight: FontWeight.w600,
    //                         size: 22.sp,
    //                         color: Colors.white),
    //                     SizedBox(height: 4.5.h),
    //                     RatedBar(rating: employerCubit.employerModel!.rate),
    //                     SizedBox(height: 0.h),
    //                     ListView.builder(
    //                         physics: const NeverScrollableScrollPhysics(),
    //                         itemCount: employerCubit.reviewsNames.length,
    //                         shrinkWrap: true,
    //                         scrollDirection: Axis.vertical,
    //                         itemBuilder: (BuildContext context, int index) {
    //                           return Column(
    //                             children: [
    //                               ReviewContainer(
    //                                 name: employerCubit.reviewsNames[index],
    //                                 rate: double.parse(employerCubit.reviewValue[index].split("--")[1]),
    //                                 review:
    //                                 employerCubit.reviewValue[index].split("--")[0],
    //                                 date: employerCubit.reviewValue[index].split("--")[2],
    //                               ),
    //                               SizedBox(height: 8.h),
    //                             ],
    //                           );
    //                         }),
    //                   ],
    //                 );
    //         },
    //       ),
    //     ),
    //     floatingActionButton: Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 24.w),
    //       child: PrimaryButton(text: 'Leave a review', onTap: () {}),
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   ),
    // );
  }
}
