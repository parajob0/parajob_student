import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/Model/jobs_model/job_month_model.dart';
import 'package:shaghalny/View/components/core/small_job_container.dart';
import 'package:shaghalny/ViewModel/cubits/home_cubit/home_cubit.dart';
import 'package:shaghalny/color_const.dart';
import 'package:shaghalny/utils/dateTime/get_month.dart';
import 'job_item.dart';

class JobMonthView extends StatelessWidget {

  JobMonthModel monthModel;
  int containerType;
  JobMonthView({required this.monthModel,this.containerType = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${monthModel.month}",
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
          itemCount: monthModel.jobList.length,
          itemBuilder: (context, index) {
            Color color;
            List<int>list = [0, 1, 2];
            if (list.contains(monthModel.jobList[index].state)) {
              color = const Color.fromRGBO(184, 186, 187, 1);
            } else {
              color = secondary;
            }
            // if history return small item
            // else return job item
            if (containerType == 0) {

              return JobItem(job: monthModel.jobList[index], borderColor: color);
            }
            else {
              return SmallJobContainer(
                position: monthModel.jobList[index].jobModel.position,
                employer: monthModel.jobList[index].jobModel.employerModel.name,
                salary: double.parse("${monthModel.jobList[index].jobModel.salary}"),
                date: getMonth(monthModel.jobList[index].jobModel.startDate.toDate().month),
                imagUrl: monthModel.jobList[index].jobModel.employerModel.image,
                containerType: "recommended",
              );
            }
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10.h,
            );
          },

        ),
      ],
    );
  }
}