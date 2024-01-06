import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shaghalny/Model/jobs_model/job_model.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
import 'package:shaghalny/View/components/core/dialog.dart';
import 'package:shaghalny/View/components/core/small_job_container.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';

import '../../screens/Alerts/deduction_alert.dart';

List<String> monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

class IntervalSection extends StatelessWidget {
  int? start;
  int? end;
  int? monthNum;
  int? year;
  int type;
  List<JobModel> jobs = [];

  IntervalSection(
      {required this.type,
      this.start,
      this.year,
      this.end,
      this.monthNum,
      required this.jobs,
      Key? key})
      : super(key: key);

  String getTextForWeek(int day, int month) {
    List<int> list = [1, 8, 15, 22];
    int start = 1;
    int end = 0;
    list.forEach((element) {
      if (element <= day) {
        start = element;
      }
    });
    if (start == 22) {
      end = DateTime(DateTime.now().year, month + 1, 0).day;
    } else {
      end = start + 7;
    }
    return "From $start to $end ${monthAbbreviations[month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    var preferenceCubit = PreferenceCubit.get(context);

    return (jobs.isNotEmpty)
        ? Container(
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (type == 0) // week i have startday & month &
                  CustomText(
                      text: getTextForWeek(start!, monthNum!),
                      weight: FontWeight.w500,
                      size: 14.sp,
                      color: const Color.fromRGBO(255, 255, 255, 0.7)),
                if (type == 1) // month
                  CustomText(
                      text:
                          "From $start to $end ${monthAbbreviations[monthNum! - 1]}",
                      weight: FontWeight.w500,
                      size: 14.sp,
                      color: const Color.fromRGBO(255, 255, 255, 0.7)),
                if (type == 2)
                  CustomText(
                      text: "${monthAbbreviations[monthNum ?? 0]} ${year}",
                      weight: FontWeight.w500,
                      size: 14.sp,
                      color: const Color.fromRGBO(255, 255, 255, 0.7)),
                SizedBox(height: 10.h,),
                ListView.separated(
                  itemCount: jobs.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.h,
                    );
                  },
                  itemBuilder: (context, index) {
                    List<String>? list = preferenceCubit
                        .userModel?.jobHistory?[jobs[index].jobId]
                        .toString()
                        .split("--");
                    return InkResponse(
                      onTap: () {
                        if(list[0] == "yes") {
                          customDialog(
                              context: context,
                              dialog: Container(
                                height: 380.h,
                                child: DeductionScreen(
                                  amount: list[1],
                                  reason: list[2],
                                  jobModel: jobs[index],
                                ),
                              ));
                        }
                      },
                      child: SmallJobContainer(
                        borderColor:
                            (list?[0] == "no") ? Colors.grey : Colors.red,
                        // or red
                        balance: true,
                        position: jobs[index].position,
                        employer: jobs[index].employerModel.name,
                        salary: jobs[index].salary.toDouble() - double.parse(list![1]),
                        date: "${jobs[index].startDate.toDate().day} ${DateFormat('MMMM').format(jobs[index].startDate.toDate())}",
                        //TODO fix date
                        imagUrl: jobs[index].employerModel.image,
                        containerType: "recommended",
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          )
        : Container();
  }
}
