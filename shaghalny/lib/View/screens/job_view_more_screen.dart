import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shaghalny/color_const.dart';

import '../../Model/jobs_model/job_model.dart';
import '../components/core/custom_text.dart';
import '../components/core/small_job_container.dart';
import 'apply_for_job_screen.dart';

class JobViewMore extends StatelessWidget {

  String type;
  List<JobModel> modelList;

  JobViewMore({required this.type, required this.modelList, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            24.w, 68.h, 24.h, 0.h),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkResponse(
              onTap: () {
                //TODO UNCOMMENT BACK BUTTON
                Navigator.pop(context);
              },
              child: Container(
                width: 20.w,
                  height: 20.h,
                  child: SvgPicture.asset("assets/backWhite.svg")),
            ),
            SizedBox(height: 10.h,),
            CustomText(
                text: type,
                weight: FontWeight.w700,
                size: 24.sp,
                color: Colors.white,
                textAlign: TextAlign.left
            ),

            ListView.builder(
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: modelList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context,
                    int index) {
                  return Column(
                    children: [
                      InkResponse(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ApplyForJobScreen(
                                          model: modelList[
                                          index])));
                        },
                        child: SmallJobContainer(
                          position: modelList[
                          index]
                              .position,
                          employer: modelList[
                          index]
                              .employerModel
                              .name,
                          salary: modelList[
                          index]
                              .salary
                              .toDouble(),
                          date:
                          "${modelList[index].startDate.toDate().day} ${DateFormat('MMMM').format(modelList[index].startDate.toDate())}",
                          imagUrl: modelList[
                          index]
                              .employerModel
                              .image,
                          containerType:
                          'recommended',
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
