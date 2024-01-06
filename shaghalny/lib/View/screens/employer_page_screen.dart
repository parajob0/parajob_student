import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numeral/ext.dart';
import 'package:shaghalny/View/screens/submit_review.dart';
import '../components/core/buttons.dart';
import '/View/screens/reviews_screen.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import '../../Model/employer_model/employer_model.dart';
import '../../ViewModel/cubits/employer_page_cubit/employer_page_cubit.dart';
import '../../color_const.dart';
import '../components/apply_for_job_screen/job_header.dart';
import '../components/core/custom_text.dart';
import '../components/core/progress_bar.dart';
import '../components/core/rated_bar.dart';
import '../components/employer_page_screen/employer_info_container.dart';
import '../components/reviews_screen/review_container.dart';

class EmployerPageScreen extends StatelessWidget {
  EmployerModel employerModel;

  EmployerPageScreen({required this.employerModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmployerPageCubit()..getReviews(empModel: employerModel),
      child: Scaffold(
        backgroundColor: primary,
        body: BlocConsumer<EmployerPageCubit, EmployerPageState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            EmployerPageCubit employerCubit = EmployerPageCubit.get(context);
            return employerCubit.gotReviews == false
                ? const Center(
                    child: CircularProgressIndicator(
                      color: secondary,
                    ),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JobHeader(
                              backgroundImage: employerModel.image,
                              opacity: 1,
                              employerModel: employerModel,
                            ),
                            SizedBox(height: 24.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      text: employerModel.name,
                                      weight: FontWeight.w700,
                                      size: 24.sp,
                                      color: Colors.white),
                                  Opacity(
                                      opacity: 0.5,
                                      child: CustomText(
                                          text: employerModel.industry,
                                          weight: FontWeight.w400,
                                          size: 14.sp,
                                          color: Colors.white)),
                                  RatedBar(
                                    rating: employerModel.rate,
                                  ),
                                  SizedBox(height: 24.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      EmployerInfoContainer(
                                        title: 'Jobs',
                                        subText:
                                            employerModel.jobs.length.numeral(fractionDigits: 1),
                                      ),
                                      EmployerInfoContainer(
                                        title: 'Employees',
                                        subText:
                                            employerModel.employees.numeral(fractionDigits: 1),
                                      ),
                                      EmployerInfoContainer(
                                        title: 'Reviews',
                                        subText: employerCubit.reviewModel.length.numeral(fractionDigits: 1),
                                            // employerModel.reviews.length.numeral(fractionDigits: 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  employerCubit.gotPositiveReviews ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                          text: 'Positive reviews',
                                          weight: FontWeight.w400,
                                          size: 14.sp,
                                          color: Colors.white),
                                      SizedBox(width: 16.w),
                                      CustomProgressBar(
                                        progress: employerCubit.positiveReviewsPercent.toDouble(),
                                        width: 100.w,
                                        height: 6.h,
                                      ),
                                      SizedBox(width: 11.w),
                                      CustomText(
                                          text: '${employerCubit.positiveReviewsPercent.toDouble()} %',
                                          weight: FontWeight.w500,
                                          size: 10.sp,
                                          color: secondary),
                                    ],
                                  )
                                  :Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                          text: 'Positive reviews',
                                          weight: FontWeight.w400,
                                          size: 14.sp,
                                          color: Colors.white),
                                      SizedBox(width: 16.w),
                                      CustomProgressBar(
                                        progress: 0.0,
                                        width: 100.w,
                                        height: 6.h,
                                      ),
                                      SizedBox(width: 11.w),
                                      CustomText(
                                          text: '0%',
                                          weight: FontWeight.w500,
                                          size: 10.sp,
                                          color: secondary),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  CustomText(
                                      text: 'Reviews',
                                      weight: FontWeight.w600,
                                      size: 22.sp,
                                      color: Colors.white),
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          employerCubit.reviewModel.length > 3
                                              ? 3
                                              : employerCubit
                                                  .reviewModel.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            ReviewContainer(
                                              name: employerCubit
                                                  .reviewModel[index].userName,
                                              rate: double.parse(employerCubit
                                                  .reviewModel[index].rate),
                                              review: employerCubit
                                                  .reviewModel[index].review,
                                              date: "${employerCubit
                                                  .reviewModel[index].date.day}."
                                                  "${employerCubit
                                                  .reviewModel[index].date.month}."
                                                  "${employerCubit
                                                  .reviewModel[index].date.year}",
                                            ),
                                            SizedBox(height: 8.h),
                                          ],
                                        );
                                      }),
                                  SizedBox(height: 24.h),

                                  if(employerCubit.reviewModel.isNotEmpty)
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkResponse(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReviewScreen(reviewModel: employerCubit.reviewModel,
                                                          employerModel: employerModel,
                                                          )));
                                          },
                                          child: CustomText(
                                              text: 'View all >>',
                                              weight: FontWeight.w500,
                                              size: 14.sp,
                                              color: Colors.white)),
                                    ],
                                  ),
                                  if(employerCubit.reviewModel.isEmpty)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                                text: 'No reviews yet',
                                                weight: FontWeight.w500,
                                                size: 14.sp,
                                                color: Colors.white),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        PrimaryButton(text: 'Leave a review', onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitReview(employerId: employerModel.id,employerName:employerModel.name, rate: employerModel.rate)));
                                        }),
                                      ],
                                    ),

                                  SizedBox(height: 31.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                //TODO UNCOMMENT BACK BUTTON
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                "assets/back.svg",
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}
