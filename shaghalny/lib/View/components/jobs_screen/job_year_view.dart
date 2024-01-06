import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Model/jobs_model/job_year_model.dart';
import 'job_item.dart';
import 'job_month_view.dart';

class JobYearView extends StatelessWidget {

  JobYearModel jobYearModel;
  int containerType; // 0 applyForJobContainer , 1 SmallJobContainer
  JobYearView({required this.jobYearModel , this.containerType = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [

            Text(
              (DateTime.now().year.toString() != jobYearModel.year)?"${jobYearModel.year}":"",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h,),
        ListView.separated(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index){
            return JobMonthView(monthModel: jobYearModel.monthsList[index],containerType: containerType,);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20.h,
            );
          },
          itemCount: jobYearModel.monthsList.length,
        ),
        SizedBox(
          height: 8.h,
        ),
      ],
    );
  }
}