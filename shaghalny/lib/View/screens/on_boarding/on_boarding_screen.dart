import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shaghalny/view/screens/signin_screen.dart';
// import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaghalny/View/components/core/custom_text.dart';
// import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:shaghalny/View/screens/signup_screen.dart';
import '../../../ViewModel/cubits/on_boarding_cubit/on_boarding_cubit.dart';
import '../../../color_const.dart';
import '../../components/core/animated_splash_screen.dart';
import 'package:introduction_slider/introduction_slider.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "assets/mockup1.svg",
      "assets/mockup2.svg",
      "assets/mockup3.svg",
    ];

    List<Color> colors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
    ];

    List<Widget> text = [
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Browse to find the ',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.white),
            ),
            TextSpan(
              text: "perfect job  ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: secondary),
            ),
            TextSpan(
              text: 'for you.',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.white),
            ),
          ])),

      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'Find all the ',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.white),
            ),
            TextSpan(
              text: "job details ",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: secondary),
            ),
            TextSpan(
              text: 'you might need.',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.white),
            ),
          ])),

      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'View your approved jobs and sign the ',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: Colors.white),
            ),
            TextSpan(
              text: "job contact.",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: secondary),
            ),
          ])),
    ];

    // return Scaffold(
    //   backgroundColor: primary,
    //   // body: OnBoardingSlider(
    //   //   headerBackgroundColor: primary,
    //   //   finishButtonText: 'Register',
    //   //   pageBackgroundColor: primary,
    //   //   // hasSkip: true,
    //   //   // hasFloatingButton: true,
    //   //   finishButtonStyle: const FinishButtonStyle(
    //   //     backgroundColor: secondary,
    //   //   ),
    //   //   // indicatorPosition: 90,
    //   //   controllerColor: secondary,
    //   //   // skipTextButton: Text('Skip'),
    //   //   // trailing: Text('Login'),
    //   //   background: [
    //   //     SvgPicture.asset('assets/mockup1.svg'),
    //   //     SvgPicture.asset('assets/mockup2.svg'),
    //   //     SvgPicture.asset('assets/mockup3.svg'),
    //   //   ],
    //   //   totalPage: 3,
    //   //   speed: 1.8,
    //   //   pageBodies: [
    //   //     Container(
    //   //       padding: EdgeInsets.symmetric(horizontal: 40.w),
    //   //       child: Column(
    //   //         children: <Widget>[
    //   //           SizedBox(
    //   //             height: 480.h,
    //   //           ),
    //   //           RichText(
    //   //               textAlign: TextAlign.center,
    //   //               text: TextSpan(children: [
    //   //                 TextSpan(
    //   //                   text: 'Browse to find the ',
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w400,
    //   //                       fontSize: 16.sp,
    //   //                       color: Colors.white),
    //   //                 ),
    //   //                 TextSpan(
    //   //                   text: "perfect job  ",
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w600,
    //   //                       fontSize: 16.sp,
    //   //                       color: secondary),
    //   //                 ),
    //   //                 TextSpan(
    //   //                   text: 'for you.',
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w400,
    //   //                       fontSize: 16.sp,
    //   //                       color: Colors.white),
    //   //                 ),
    //   //               ])),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //     Container(
    //   //       padding: EdgeInsets.symmetric(horizontal: 40.w),
    //   //       child: Column(
    //   //         children: <Widget>[
    //   //           SizedBox(
    //   //             height: 480.h,
    //   //           ),
    //   //           RichText(
    //   //               textAlign: TextAlign.center,
    //   //               text: TextSpan(children: [
    //   //                 TextSpan(
    //   //                   text: 'Find all the ',
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w400,
    //   //                       fontSize: 16.sp,
    //   //                       color: Colors.white),
    //   //                 ),
    //   //                 TextSpan(
    //   //                   text: "job details ",
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w600,
    //   //                       fontSize: 16.sp,
    //   //                       color: secondary),
    //   //                 ),
    //   //                 TextSpan(
    //   //                   text: 'you might need.',
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w400,
    //   //                       fontSize: 16.sp,
    //   //                       color: Colors.white),
    //   //                 ),
    //   //               ])),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //     Container(
    //   //       padding: EdgeInsets.symmetric(horizontal: 40.w),
    //   //       child: Column(
    //   //         children: <Widget>[
    //   //           SizedBox(
    //   //             height: 480.h,
    //   //           ),
    //   //           RichText(
    //   //               textAlign: TextAlign.center,
    //   //               text: TextSpan(children: [
    //   //                 TextSpan(
    //   //                   text: 'View your approved jobs and sign the ',
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w400,
    //   //                       fontSize: 16.sp,
    //   //                       color: Colors.white),
    //   //                 ),
    //   //                 TextSpan(
    //   //                   text: "job contact.",
    //   //                   style: GoogleFonts.poppins(
    //   //                       fontWeight: FontWeight.w600,
    //   //                       fontSize: 16.sp,
    //   //                       color: secondary),
    //   //                 ),
    //   //               ])),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //   ],
    //   //   onFinish: (){
    //   //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));
    //   //   },
    //   // ),
    //   body: IntroductionSlider(
    //     items: [
    //       IntroductionSliderItem(
    //         logo: FlutterLogo(),
    //         title: Text("Title 1"),
    //         backgroundColor: Colors.red,
    //       ),
    //       IntroductionSliderItem(
    //         logo: FlutterLogo(),
    //         title: Text("Title 2"),
    //         backgroundColor: Colors.green,
    //       ),
    //       IntroductionSliderItem(
    //         logo: FlutterLogo(),
    //         title: Text("Title 3"),
    //         backgroundColor: Colors.blue,
    //       ),
    //     ],
    //     showStatusBar: true,
    //     done: Done(
    //       child: Icon(Icons.done),
    //       home: SignupScreen(),
    //     ),
    //     // next: Next(child: Icon(Icons.arrow_forward)),
    //     // back: Back(child: Icon(Icons.arrow_back)),
    //     dotIndicator: DotIndicator(
    //       selectedColor: secondary,
    //       unselectedColor: Colors.white.withOpacity(0.5)
    //     ),
    //   ),
    // );


    final PageController controller = PageController();
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        alignment: AlignmentDirectional.center,

        children: [

          const AnimatedSplash(),

          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                  sigmaX: 50.0, sigmaY: 50.0),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 40.h),
                  margin: EdgeInsets.symmetric(
                      horizontal: 32.w, vertical: 39.h),
                  // height: double.infinity,
                  // width: double.infinity,
                  width: 300.w,
                  height: 600.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(25.sp)),
                      color: Colors.black.withOpacity(0.3)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      // text[boardingCubit.index],
                      // SizedBox(height: 32.h),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          //todo the carousel dot indicator
                          SmoothPageIndicator(
                              controller: controller,  // PageController
                              count: 3,
                              effect: ExpandingDotsEffect(
                                activeDotColor: secondary,
                                dotWidth: 12.w,
                                dotHeight: 10.h,
                              ),  // your preferred effect
                              onDotClicked: (index){

                              }
                          ),

                          InkResponse(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninScreen()));
                            },
                            child: CustomText(
                                text: "Skip >>",
                                weight: FontWeight.w500,
                                size: 16.sp,
                                color: Colors.white),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h, bottom: 100.h),
            child: PageView(
              controller: controller,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //     width: 200.w, height: 100.h, color: Colors.red),
                    // SvgPicture.asset('assets/mockup1.svg', height: 400.h,),
                    Image.asset("assets/mockup1.png", height: 380.h),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Browse to find the ',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text: "perfect job  ",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: secondary),
                            ),
                            TextSpan(
                              text: 'for you.',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                          ])),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //     width: 200.w, height: 100.h, color: Colors.red),
                    // SvgPicture.asset('assets/mockup2.svg', height: 400.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/mockup22copy1.png", height: 380.h),
                        Image.asset("assets/mockup22copy.png", height: 380.h),
                        Image.asset("assets/mockup22copy2.png", height: 380.h),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Find all the ',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text: "job details ",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: secondary),
                            ),
                            TextSpan(
                              text: 'you might need.',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                          ])),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //     width: 200.w, height: 100.h, color: Colors.red),
                    // SvgPicture.asset('assets/mockup3.svg', height: 400.h,),
                    Image.asset("assets/mockup3.png", height: 380.h),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'View your approved jobs and sign the ',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            TextSpan(
                              text: "job contact.",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: secondary),
                            ),
                          ])),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // return BlocProvider(
    //   create: (context) => OnBoardingCubit(),
    //   child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
    //     listener: (context, state) {
    //       // TODO: implement listener
    //     },
    //     builder: (context, state) {
    //       OnBoardingCubit boardingCubit = OnBoardingCubit.get(context);
    //       return Scaffold(
    //         backgroundColor: primary,
    //         body: Stack(
    //           alignment: AlignmentDirectional.center,
    //           children: [
    //             const AnimatedSplash(),
    //             Container(
    //                 // child: Container(
    //                 //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
    //                 //   // height: double.infinity,
    //                 //   // width: double.infinity,
    //                 //   // width: 100.w,
    //                 //   // height: 100.h,
    //                 // ),
    //                 // color: Colors.white,
    //                 width: double.infinity,
    //                 height: double.infinity,
    //                 child: Stack(
    //                   children: [
    //                     Stack(
    //                       alignment: AlignmentDirectional.center,
    //                       children: [
    //                         ClipRect(
    //                           child: BackdropFilter(
    //                             filter: ui.ImageFilter.blur(
    //                                 sigmaX: 50.0, sigmaY: 50.0),
    //                             child: Container(
    //                                 padding: EdgeInsets.symmetric(
    //                                     horizontal: 16.w, vertical: 40.h),
    //                                 margin: EdgeInsets.symmetric(
    //                                     horizontal: 32.w, vertical: 39.h),
    //                                 // height: double.infinity,
    //                                 // width: double.infinity,
    //                                 width: 300.w,
    //                                 height: 600.h,
    //                                 decoration: BoxDecoration(
    //                                     borderRadius: BorderRadius.all(
    //                                         Radius.circular(25.sp)),
    //                                     color: Colors.black.withOpacity(0.3)),
    //                                 child: Column(
    //                                   mainAxisAlignment: MainAxisAlignment.end,
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.center,
    //                                   children: [
    //                                     // text[boardingCubit.index],
    //                                     // SizedBox(height: 32.h),
    //                                     Row(
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         //todo the carousel dot indicator
    //                                         DotsIndicator(
    //                                           dotsCount: images.length,
    //                                           position: boardingCubit.index,
    //                                           decorator: DotsDecorator(
    //                                             activeColor: secondary,
    //                                             size: const Size.square(9.0),
    //                                             activeSize:
    //                                                 const Size(18.0, 9.0),
    //                                             activeShape:
    //                                                 RoundedRectangleBorder(
    //                                                     borderRadius:
    //                                                         BorderRadius
    //                                                             .circular(5.0)),
    //                                           ),
    //                                         ),
    //                                         CustomText(
    //                                             text: "Skip >>",
    //                                             weight: FontWeight.w500,
    //                                             size: 16.sp,
    //                                             color: Colors.white)
    //                                       ],
    //                                     )
    //                                   ],
    //                                 )),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.only(top: 59.h),
    //                       child: CarouselSlider(
    //                           options: CarouselOptions(
    //                               enlargeStrategy:
    //                                   CenterPageEnlargeStrategy.scale,
    //                               enlargeFactor: 0.5,
    //                               autoPlay: false,
    //                               aspectRatio: 1.3.sp,
    //                               enlargeCenterPage: true,
    //                               enableInfiniteScroll: false,
    //                               clipBehavior: Clip.none,
    //                               onPageChanged: (index, reason){
    //                                 boardingCubit.changeScreen(ind: index);
    //                               }
    //
    //                           ),
    //                           items: colors.map((e) {
    //                             return Builder(builder: (BuildContext context) {
    //                               return Container(
    //                                   width: 650.w, height: 300.h, color: e);
    //                               // return Column(
    //                               //   mainAxisAlignment: MainAxisAlignment.end,
    //                               //   children: [
    //                               //     Container(
    //                               //         width: 550.w, height: 200.h, color: e),
    //                               //     SizedBox(height: 250.h),
    //                               //     text[boardingCubit.index],
    //                               //   ],
    //                               // );
    //                             });
    //                           }).toList()),
    //                     ),
    //                   ],
    //                 )),
    //             //
    //             //
    //             //     Swiper(
    //             //       layout: SwiperLayout.CUSTOM,
    //             //       onIndexChanged: (index){},
    //             //       customLayoutOption: CustomLayoutOption(
    //             //         startIndex: 0,
    //             //         // stateCount: 3
    //             //       )..addRotate([
    //             //         45.0/180,
    //             //         0.0,
    //             //         -45.0/180
    //             //       ])..addTranslate([
    //             //         Offset(-200.0, -20.0),
    //             //         Offset(0.0, 0.0),
    //             //         Offset(200.0, -20.0)
    //             //       ]),
    //             //       itemBuilder: (context, index){
    //             //         return SvgPicture.asset(images[index], height: 200.h, width: 100.w,);
    //             //       },
    //             //       itemHeight: 200.h,
    //             //       itemWidth: double.infinity,
    //             //       itemCount: 3,
    //             //     )
    //           ],
    //         ),
    //
    //         // body: Swiper(
    //         //   layout: SwiperLayout.CUSTOM,
    //         //   onIndexChanged: (index){},
    //         //   customLayoutOption: CustomLayoutOption(
    //         //     startIndex: 0,
    //         //     stateCount: 3
    //         //   )..addRotate([
    //         //     -45.0/180,
    //         //     0.0,
    //         //     45.0/180
    //         //   ])..addTranslate([
    //         //     Offset(-100.0, -10.0),
    //         //     Offset(0.0, 0.0),
    //         //     Offset(100.0, -10.0)
    //         //   ]),
    //         //   itemBuilder: (context, index){
    //         //     return SvgPicture.asset(images[index], height: 200.h, width: 100.w,);
    //         //     // return Container(
    //         //     //   width: 100.w,
    //         //     //   height: 100.h,
    //         //     //   color: colors[index],
    //         //     // );
    //         //   },
    //         //   itemHeight: 100.h,
    //         //   itemWidth: 100.w,
    //         //   itemCount: images.length,
    //         // ),
    //       );
    //     },
    //   ),
    // );


  }
}
