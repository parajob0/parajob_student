import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '/View/components/apply_for_job_screen/job_details.dart';
import '/View/screens/about_the_application.dart';
import '/color_const.dart';
import '/view/components/core/sign_in_appBar.dart';

import '../../utils/page_route.dart';
import '../components/core/custom_text.dart';
import '../components/menu_page/about_us_details.dart';
import '../components/menu_page/menu_details.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: SingleChildScrollView(
          child: Container(
            //height: 1.sh - 0.04.sh,
            padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SignInAppBar(
                  text: "",
                  size: 1.sp,
                  progress: 0,
                  showProgressBar: false,
                ),
                AboutUsDetails(
                  text: "About the application",
                  svgIconPath: "assets/Go to.svg",
                  color: Colors.white,
                  width: 110.w,
                  onTap: () {
                    AppNavigator.customNavigator(
                        context: context,
                        screen: const AboutTheApplicationScreen(),
                        finish: false);
                  },
                ),
                // SizedBox(height: 10.h),
                // AboutUsDetails(text: "Rate us on App store", svgIconPath: "assets/Go to.svg",color: Colors.white,width: 110.w,
                // onTap: (){},),
                SizedBox(height: 10.h),
                AboutUsDetails(
                    text: "Follow us on instagram",
                    svgIconPath: "assets/Go to.svg",
                    color: Colors.white,
                    width: 90.w,
                    onTap: () async {
                      if (!await launchUrl(Uri.parse(
                          "https://instagram.com/parajob_eg?igshid=OGQ5ZDc2ODk2ZA%3D%3D&utm_source=qr"))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Couldn't open the Link")));
                      }
                    }),
                // SizedBox(height: 10.h),
                // AboutUsDetails(text: "Follow us on Twitter", svgIconPath: "assets/Go to.svg",color: Colors.white,width: 110.w,
                //     onTap: (){}),
                SizedBox(height: 10.h),
                AboutUsDetails(
                    text: "Like us on facebook",
                    svgIconPath: "assets/Go to.svg",
                    color: Colors.white,
                    width: 110.w,
                    onTap: () async{
                      if (!await launchUrl(Uri.parse(
                          "https://www.facebook.com/profile.php?id=61552287592129&mibextid=LQQJ4d"))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Couldn't open the Link")));
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
