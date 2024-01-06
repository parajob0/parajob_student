import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../color_const.dart';
import 'custom_text.dart';

class RatedBar extends StatelessWidget {
  dynamic rating;

  RatedBar({required this.rating, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          CustomText(text: '$rating', weight: FontWeight.w800, size: 20.sp, color: secondary),
          SizedBox(width: 8.w),
          RatingBar(
            initialRating: rating.toDouble(),
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemSize: 14.sp,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: SvgPicture.asset('assets/rate.svg', color: secondary,),
              half: SvgPicture.asset('assets/half_rate.svg'),
              empty: SvgPicture.asset('assets/empty_rate.svg'),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
            onRatingUpdate: (rating) {},
          ),
        ],
      );
  }
}
