import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadow_clip/shadow_clip.dart';
import '/color_const.dart';

import '../../../Model/employer_model/employer_model.dart';
import '../../screens/employer_page_screen.dart';

class JobHeader extends StatelessWidget {
  String jobTitle;
  String backgroundImage;
  String companyName;
  String companyLogo;
  double? opacity = 0.7;

  EmployerModel employerModel;

  JobHeader(
      {this.jobTitle='',
      required this.backgroundImage,
      this.companyName='',
      this.companyLogo='',
      this.opacity,
        required this.employerModel,
      });

  @override
  Widget build(BuildContext context) {
    return ClipShadow(
      clipper: CurveClipper(),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0.0, 0.0),
          blurRadius: 10.0,
          spreadRadius: 5.0,
          color: secondary,
        )
      ],
      child: Container(
        width: 380.w,
        height: 253.h,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: NetworkImage(backgroundImage),
            fit: BoxFit.cover,
            opacity: opacity??0.7
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.sp),
              child: Text(
                jobTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: 8.w,
            ),

            if(companyName != '')
              InkResponse(
                onTap : (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployerPageScreen(employerModel: employerModel)));
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25.sp,
                        foregroundImage: NetworkImage("${this.companyLogo}"),
                        backgroundColor: Colors.red,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 200.w,
                        ),
                        child: Text(
                          "${this.companyName}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.sp,
                            overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
              ),
          ],
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight+1);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
