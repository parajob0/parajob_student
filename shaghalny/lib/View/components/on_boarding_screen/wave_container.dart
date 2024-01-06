// import 'package:flutter/material.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../screens/signin_screen.dart';
// import '/view/screens/bottom_navigation_screen.dart';
// import 'dart:ui' as ui;
//
// // import '../../screens/on_boarding/employer_on_boarding_screen.dart';
// import '../core/custom_text.dart';
//
// class WaveContainer extends StatelessWidget {
//   bool isStudent;
//   WaveContainer({required this.isStudent, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       child: ClipPath(
//         clipper: WaveClipperTwo(reverse: true),
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(
//               sigmaX: 200.0, sigmaY: 200.0),
//           child: Container(
//             padding: EdgeInsets.fromLTRB(24.w, 47.h, 24.w, 0.h),
//             height: 400.h,
//             width: double.infinity,
//             color: Colors.black.withOpacity(0.4),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(text: "Para-Job", weight: FontWeight.w700, size: 32.sp, color: Colors.white),
//                 CustomText(text: isStudent ? "for Students" : "for Employers", weight: FontWeight.w700, size: 32.sp, color: Colors.white),
//
//                 SizedBox(height: 24.h),
//
//                 CustomText(text: isStudent ? "We bring all great opportunities to you students to find individual shifts with our partner companies,  & book the job you like best."
//                     : "We ease the recruitment process for you to post your offers for shifts and connect with some enthusiastic students.",
//                     weight: FontWeight.w500, size: 16.sp, color: Colors.white),
//
//                 SizedBox(height: 87.h),
//
//                 InkResponse(
//                   onTap: (){
//                     isStudent ? Navigator.push(context, MaterialPageRoute(builder: (context)=> const EmployerOnBoarding()))
//                         : Navigator.push(context, MaterialPageRoute(builder: (context)=> SigninScreen()));
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomText(text: "Continue >>", weight: FontWeight.w500, size: 16.sp, color: Colors.white),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }