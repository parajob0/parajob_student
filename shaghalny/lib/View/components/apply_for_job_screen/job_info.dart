import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobInfo extends StatelessWidget {
  String title;
  List<dynamic> list;
  JobInfo({required this.title, required this.list});

  List<String> text = [
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
    "Lorem ipsum dolor sitmet",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${this.title}",
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        ListView.separated(
          itemCount: list.length??0,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: EdgeInsets.fromLTRB(5.w, 8.h, 0, 0),
          itemBuilder: (context, index) {
            return Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Icon(
                    Icons.circle,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    size: 4,
                  ),
                ),
                SizedBox(width: 4.w,),
                Expanded(
                  child: Text(
                    list[index],
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 6.h,
            );
          },
        ),
      ],
    );
  }
}