import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '/Model/employer_model/employer_model.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/buttons.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/screens/submit_complaint_place.dart';
import '/ViewModel/cubits/complaints_review_cubit/complaint_review_cubit.dart';
import '/color_const.dart';
import '/view/components/core/multiline_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../components/core/custom_text.dart';
import 'Alerts/complaint_submitted.dart';
import 'Alerts/review_submitted.dart';


class SubmitReview extends StatefulWidget {
  String employerName;
  String employerId;
  dynamic rate;
  SubmitReview({required this.employerId,required this.employerName,required this.rate, Key? key}) : super(key: key);

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {
  GlobalKey<FormState> reviewKey = new GlobalKey<FormState>();
  TextEditingController reviewController = new TextEditingController();

  double ratingValue=0;
  double rate=0;
  double roundedDoubleRate=0;
  var reviewDay=DateFormat.d().format(DateTime.now());
  var reviewMonth=DateFormat.M().format(DateTime.now());
  var reviewYear=DateFormat.y().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    PreferenceCubit prefCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    return BlocConsumer<ComplaintReviewCubit, ComplaintReviewState>(
  listener: (context, state) {
  },
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
                text: "Leave a review",
                size: 24.sp,
                weight: FontWeight.w400,
                color: Colors.white,),
              Row(
                children: [
                  CustomText(
                    text: "to ",
                    size: 12.sp,
                    weight: FontWeight.w400,
                    color: Colors.grey,),
                  CustomText(
                    text:widget.employerName,
                    size: 12.sp,
                    weight: FontWeight.w400,
                    color: Colors.white,),
                ],
              ),          Center(
            child:SmoothStarRating(
                allowHalfRating: true,
                onRatingChanged: (rating) {
                  ratingValue = rating;
                  setState(() {});
                  print(rating);
                },
                starCount: 5,
                rating: ratingValue,
                size: 40.0,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                color: secondary,
                borderColor: secondary,
                spacing:0.0
            )


       /*     RatingBar.builder(
              unratedColor: secondary,
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star_border,
                color:secondary,

              ),
              onRatingUpdate: (rating) {
                ratingValue=rating;
                print(rating);
              },
            ),*/
          ),
              SizedBox(height: 10.h),

              MultiLineTextField(
                hintText: "Share your opinion with us..",
                formKey: reviewKey,
                controller: reviewController,
                onchange: (val) {
                  print(val);
                },
                onTap: ()  {},
                validate: (text) {
                  if (text==null||text.isEmpty) {
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryButton(
                    text: 'Submit your review',
                    onTap: ()  {
                      if(ratingValue == 0){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('The rating must be more than 0')));
                      }
                      else{

                        if(widget.rate == 0){
                          rate = ratingValue;
                        }
                        else{
                          rate= (widget.rate+ratingValue)/2;
                        }

                        String rateInString = rate.toStringAsFixed(1);
                        roundedDoubleRate = double.parse(rateInString);
                        ComplaintReviewCubit.get(context).reviewData(prefCubit, review: reviewController.text,
                            rating: ratingValue.toStringAsFixed(1), day: reviewDay,
                            month: reviewMonth, year: reviewYear, employerId: widget.employerId,rate:roundedDoubleRate);

                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertReviewSubmitted();
                            }
                        );

                        debugPrint("done");
                      }
                      // rate=rate+ratingValue/2;
                      // String rateInString = rate.toStringAsFixed(1);
                      // roundedDoubleRate = double.parse(rateInString);
                      // ComplaintReviewCubit.get(context).reviewData(prefCubit, review: reviewController.text,
                      //     rating: ratingValue.toStringAsFixed(1), day: reviewDay,
                      //     month: reviewMonth, year: reviewYear, employerId: widget.employerId,rate:roundedDoubleRate);
                      //
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return const AlertReviewSubmitted();
                      //     }
                      // );
                      //
                      // debugPrint("done");
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