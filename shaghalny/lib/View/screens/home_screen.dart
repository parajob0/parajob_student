import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shaghalny/ViewModel/database/cache_helper/cache_helper.dart';
import '../../ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import '/View/screens/apply_for_job_screen.dart';
import 'dart:ui' as ui;
import '../../ViewModel/cubits/home_cubit/home_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../color_const.dart';
import '../components/core/custom_text.dart';
import '../components/core/level_badge.dart';
import '../components/core/small_job_container.dart';
import '../components/home_screen/carousel_container.dart';
import '../components/home_screen/specialForYouContainer.dart';
import 'dart:math';
import 'dart:io' show Platform;

import 'job_view_more_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget levelInfo({required int currentLevel, required int specialLevel}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 70.h),
      child: AlertDialog(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.sp))),
        content: Container(
          color: primary,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset("assets/level_to_level.svg"),
                    Positioned(
                      right: 15.w,
                      top: 10.h,
                      child: Column(
                        children: [
                          CustomText(
                              text: "Level",
                              weight: FontWeight.w600,
                              size: 20.sp,
                              color: Colors.white),
                          CustomText(
                              text: "$currentLevel",
                              weight: FontWeight.w600,
                              size: 20.sp,
                              color: Colors.white),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 15.w,
                      bottom: 10.h,
                      child: Column(
                        children: [
                          CustomText(
                              text: "Level",
                              weight: FontWeight.w600,
                              size: 20.sp,
                              color: Colors.white),
                          CustomText(
                              text: "$specialLevel",
                              weight: FontWeight.w600,
                              size: 20.sp,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                CustomText(
                    text: "You are now on level",
                    weight: FontWeight.w300,
                    size: 16.sp,
                    color: Colors.white.withOpacity(0.7)),
                SizedBox(height: 4.h),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SvgPicture.asset(
                      "assets/profileLevel.svg",
                      width: 40.w,
                      height: 42.h,
                    ),
                    CustomText(
                        text: "$currentLevel",
                        weight: FontWeight.w600,
                        size: 24.sp,
                        color: Colors.white)
                  ],
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text:
                      "You need to reach level $specialLevel to unlock this category",
                  weight: FontWeight.w600,
                  size: 20.sp,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                )
              ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferenceCubit preferenceCubit =
        BlocProvider.of<PreferenceCubit>(context, listen: true);
    var jobCubit = JobsCubit.get(context);
    HomeCubit homeCubit = HomeCubit.get(context)
      ..getNewJobs(preferenceCubit)
      ..getAllJobs(preferenceCubit)
      ..getSpecialJobs(preferenceCubit)
      // ..getRecommendedJobs(preferenceCubit)
      ..getHighRatedEmployeesJob(preferenceCubit);

    if (jobCubit.appliedJobYearModelList.isEmpty) {
      jobCubit.fillJobs(preferenceCubit, context);
    }
    return preferenceCubit.userModel != null &&
            preferenceCubit.adminModel != null
        ? Scaffold(
            backgroundColor: primary,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //JOBS IN CAIRO
                  BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      HomeCubit homeCubit = HomeCubit.get(context);
                      return homeCubit.gotAllJobs
                          ? homeCubit.allJobModel.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          24.w, 68.h, 0, 10.h),
                                      child: Row(
                                        children: [
                                          CustomText(
                                              text: 'Jobs in ',
                                              weight: FontWeight.w700,
                                              size: 24.sp,
                                              color: Colors.white),
                                          CustomText(
                                              text: preferenceCubit
                                                  .userModel!.city
                                                  .toString(),
                                              weight: FontWeight.w700,
                                              size: 24.sp,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 20.h),
                                      height: 200.h,
                                      child: CarouselSlider(
                                          options: CarouselOptions(
                                              enlargeStrategy:
                                                  CenterPageEnlargeStrategy.zoom,
                                              enlargeFactor: 0.35,
                                              autoPlay: false,
                                              aspectRatio: 1.3.sp,
                                              enlargeCenterPage: true,
                                              enableInfiniteScroll: false),
                                          items: homeCubit.allJobModel.map((e) {
                                            return Builder(
                                                builder: (BuildContext context) {
                                              int time =
                                                  homeCubit.getSalaryPerHour(e);

                                              return InkResponse(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ApplyForJobScreen(
                                                                model: e,
                                                              )));
                                                },
                                                child: CarouselContainer(
                                                  employerName:
                                                      e.employerModel.name,
                                                  employerImage:
                                                      e.employerModel.image,
                                                  employerRate:
                                                      e.employerModel.rate,
                                                  jobSalary: e.salary.toDouble(),
                                                  position: e.position.toString(),
                                                  date:
                                                      "${e.startDate.toDate().day} ${DateFormat('MMMM').format(e.startDate.toDate())}",
                                                  location: e.location.toString(),
                                                  perHour: time.toString(),
                                                  per: homeCubit.per,
                                                ),
                                              );
                                            });
                                          }).toList()),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 80.h),
                                    child: CustomText(
                                        text: "No Jobs available right now",
                                        weight: FontWeight.w700,
                                        size: 15.sp,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                )
                          : const Center(
                              child: CircularProgressIndicator(
                              color: secondary,
                            ));
                    },
                  ),

                  // SizedBox(height: 130.h),
                  //SPECIAL FOR YOU
                  BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      HomeCubit homeCubit = HomeCubit.get(context);
                      return preferenceCubit.userModel != null &&
                                  preferenceCubit.adminModel != null &&
                                  homeCubit.gotSpecialJobs ||
                              state is! LoadingAllJobs
                          ? homeCubit.specialJobsModel.isNotEmpty
                              ? preferenceCubit.userModel!.level! >=
                                      preferenceCubit
                                          .adminModel!.specialJobsLevel
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          24.w, 32.h, 24.h, 0.h),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                      text: 'Special for you ',
                                                      weight: FontWeight.w700,
                                                      size: 24.sp,
                                                      color: Colors.white),

                                                  SvgPicture.asset(
                                                      'assets/special_for_you.svg',
                                                      width: 24.w,
                                                      height: 25.h)
                                                ],
                                              ),
                                              if(homeCubit.specialJobsModel.length > 3)
                                                InkResponse(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => JobViewMore(modelList: homeCubit.specialJobsModel, type: "Special for you")));
                                                  },
                                                  child: CustomText(
                                                      text: 'view all',
                                                      weight: FontWeight.w400,
                                                      size: 14.sp,
                                                      color: secondary),
                                                ),
                                            ],
                                          ),
                                          CustomText(
                                              text:
                                                  'This category is based on your level, with higher levels you’ll get better jobs.',
                                              weight: FontWeight.w400,
                                              size: 10.sp,
                                              color: Colors.white
                                                  .withOpacity(0.7)),
                                          SizedBox(height: 16.h),
                                          Container(
                                            height: 162.h,
                                            child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: homeCubit
                                                    .specialJobsModel.length > 3 ? 3 : homeCubit
                                                    .specialJobsModel.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Row(
                                                    children: [
                                                      InkResponse(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ApplyForJobScreen(
                                                                          model:
                                                                              homeCubit.specialJobsModel[index])));
                                                        },
                                                        child: SpecialContainer(
                                                          employer: homeCubit
                                                              .specialJobsModel[
                                                                  index]
                                                              .employerModel
                                                              .name,
                                                          salary: (homeCubit
                                                                  .specialJobsModel[
                                                                      index]
                                                                  .salary)
                                                              .toString(),
                                                          imageUrl: homeCubit
                                                              .specialJobsModel[
                                                                  index]
                                                              .employerModel
                                                              .image,
                                                        ),
                                                      ),
                                                      SizedBox(width: 16.w),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    )
                                  : InkResponse(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return levelInfo(
                                                currentLevel: preferenceCubit
                                                    .userModel!.level as int,
                                                specialLevel: preferenceCubit
                                                    .adminModel!
                                                    .specialJobsLevel);
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            24.w, 32.h, 24.h, 0.h),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CustomText(
                                                    text: 'Special for you ',
                                                    weight: FontWeight.w700,
                                                    size: 24.sp,
                                                    color: Colors.white),
                                                SvgPicture.asset(
                                                    'assets/special_for_you.svg',
                                                    width: 24.w,
                                                    height: 25.h)
                                              ],
                                            ),
                                            CustomText(
                                                text:
                                                    'This category is based on your level, with higher levels you’ll get better jobs.',
                                                weight: FontWeight.w400,
                                                size: 10.sp,
                                                color: Colors.white
                                                    .withOpacity(0.7)),
                                            Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              children: [
                                                Padding(
                                                  // padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.h, 0.h),
                                                  padding: EdgeInsets.all(0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 16.h),
                                                      Container(
                                                        height: 145.h,
                                                        child: ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: homeCubit
                                                                .specialJobsModel
                                                                .length,
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Row(
                                                                children: [
                                                                  SpecialContainer(
                                                                    employer: homeCubit
                                                                        .specialJobsModel[
                                                                            index]
                                                                        .employerModel
                                                                        .name,
                                                                    salary: (homeCubit
                                                                            .specialJobsModel[index]
                                                                            .salary)
                                                                        .toString(),
                                                                    imageUrl: homeCubit
                                                                        .specialJobsModel[
                                                                            index]
                                                                        .employerModel
                                                                        .name,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          16.w),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRect(
                                                  child: BackdropFilter(
                                                    filter: ui.ImageFilter.blur(
                                                        sigmaX: 5.0,
                                                        sigmaY: 5.0),
                                                    child: Container(
                                                      height: 200.h,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.0)),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: CustomText(
                                                    text:
                                                        'This category will be unlocked at level 8',
                                                    weight: FontWeight.w700,
                                                    size: 22.sp,
                                                    color: Colors.white,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                              : Container()
                          : const Center(
                              child:
                                  CircularProgressIndicator(color: secondary));
                    },
                ),

                  //RECOMMENDED FOR YOU
                  if(Platform.isAndroid)
                    BlocConsumer<HomeCubit, HomeState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        HomeCubit homeCubit = HomeCubit.get(context);
                        return homeCubit.gotRecommendedJobs
                            ? homeCubit.recommendedJobModel.isNotEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(24.w, 0.h, 24, 24.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [

                                            Expanded(
                                              child: RichText(
                                                  text: TextSpan(
                                                      children: [
                                                        TextSpan(text: 'Recommended for you',
                                                          style: GoogleFonts.poppins(
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 24.sp,
                                                              color: Colors.white),
                                                        ),
                                                      ]
                                                  )
                                              ),
                                            ),


                                            // CustomText(
                                            //     text: 'Recommended for you',
                                            //     weight: FontWeight.w700,
                                            //     size: 24.sp,
                                            //     color: Colors.white),
                                            if (homeCubit
                                                    .recommendedJobModel.length >
                                                3)
                                              InkResponse(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => JobViewMore(
                                                              modelList: homeCubit
                                                                  .recommendedJobModel,
                                                              type:
                                                                  "Recommended for you")));
                                                },
                                                child: CustomText(
                                                    text: 'view all',
                                                    weight: FontWeight.w400,
                                                    size: 14.sp,
                                                    color: secondary),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 0.h),
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: homeCubit
                                                .recommendedJobModel.length > 3 ? 3 : homeCubit
                                                .recommendedJobModel.length,
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
                                                                      model: homeCubit
                                                                              .recommendedJobModel[
                                                                          index])));
                                                    },
                                                    child: SmallJobContainer(
                                                      position: homeCubit
                                                          .recommendedJobModel[
                                                              index]
                                                          .position,
                                                      employer: homeCubit
                                                          .recommendedJobModel[
                                                              index]
                                                          .employerModel
                                                          .name,
                                                      salary: homeCubit
                                                          .recommendedJobModel[
                                                              index]
                                                          .salary
                                                          .toDouble(),
                                                      date:
                                                          "${homeCubit.recommendedJobModel[index].startDate.toDate().day} ${DateFormat('MMMM').format(homeCubit.recommendedJobModel[index].startDate.toDate())}",
                                                      imagUrl: homeCubit
                                                          .recommendedJobModel[
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
                                  )
                                : Container()
                            : const Center(
                                child:
                                    CircularProgressIndicator(color: secondary));
                      },
                    ),

                  //HIGH RATED EMPLOYEES
                  BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      HomeCubit homeCubit = HomeCubit.get(context);
                      return homeCubit.gotHighRatedJobs
                          ? homeCubit.highRatedJobModel.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      24.w, 0.h, 24.w, 24.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Expanded(
                                            child: RichText(
                                                text: TextSpan(
                                                    children: [
                                                      TextSpan(text: 'High rated employers',
                                                        style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 24.sp,
                                                            color: Colors.white),
                                                      ),
                                                    ]
                                                )
                                            ),
                                          ),

                                          // CustomText(
                                          //     text: 'High rated employees',
                                          //     weight: FontWeight.w700,
                                          //     size: 24.sp,
                                          //     color: Colors.white),
                                          if (homeCubit.highRatedJobModel.length >
                                              3)
                                            InkResponse(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => JobViewMore(
                                                            modelList: homeCubit.highRatedJobModel,
                                                            type:
                                                            "High rated employees")));
                                              },
                                              child: CustomText(
                                                  text: 'view all',
                                                  weight: FontWeight.w400,
                                                  size: 14.sp,
                                                  color: secondary),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 0.h),
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: homeCubit
                                              .highRatedJobModel.length > 3 ? 3 : homeCubit
                                              .highRatedJobModel.length,
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
                                                                    model: homeCubit
                                                                            .highRatedJobModel[
                                                                        index])));
                                                  },
                                                  child: SmallJobContainer(
                                                    position: homeCubit
                                                        .highRatedJobModel[
                                                            index]
                                                        .position,
                                                    employer: homeCubit
                                                        .highRatedJobModel[
                                                            index]
                                                        .employerModel
                                                        .name,
                                                    salary: homeCubit
                                                        .highRatedJobModel[
                                                            index]
                                                        .salary
                                                        .toDouble(),
                                                    date:
                                                        "${homeCubit.highRatedJobModel[index].startDate.toDate().day} ${DateFormat('MMMM').format(homeCubit.highRatedJobModel[index].startDate.toDate())}",
                                                    imagUrl: homeCubit
                                                        .highRatedJobModel[
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
                                )
                              : Container()
                          : const Center(
                              child:
                                  CircularProgressIndicator(color: secondary));
                    },
                  ),

                  //NEW JOBS
                  BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      HomeCubit homeCubit = HomeCubit.get(context);
                      return homeCubit.gotNewJobs
                          ? homeCubit.newJobs.isNotEmpty
                              ? Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 0.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          text: 'New Jobs',
                                          weight: FontWeight.w700,
                                          size: 24.sp,
                                          color: Colors.white),
                                      SizedBox(height: 0.h),
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          // itemCount: homeCubit
                                          //     .newJobMap.length,
                                          itemCount: 1,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var keys = homeCubit.newJobMap.keys
                                                .toList();
                                            Random random = Random();

                                            int rand = random.nextInt(
                                                homeCubit.newJobMap.length);
                                            try{
                                              if (CacheHelper.doesExist(
                                                  key: 'rand') && int.parse(CacheHelper.getData(key: 'rand')) < homeCubit.newJobMap.length) {
                                                debugPrint("\n\nfirst \n\n");
                                                rand = int.parse(
                                                    CacheHelper.getData(
                                                        key: 'rand'));
                                              } else {
                                                debugPrint("\n\nsecond \n\n");
                                                rand = random.nextInt(
                                                    homeCubit.newJobMap.length);
                                                CacheHelper.setData(
                                                    key: 'rand',
                                                    value: rand.toString());
                                              }
                                            }catch(e){
                                              CacheHelper.removeData(key: "rand");
                                            }


                                            debugPrint(
                                                "\n\n random here is --> ${int.parse(CacheHelper.getData(key: 'rand'))} \n\n");

                                            return Column(
                                              children: [
                                                InkResponse(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ApplyForJobScreen(
                                                                    model: homeCubit
                                                                            .newJobMap[
                                                                        keys[
                                                                            rand]]![0])));
                                                  },
                                                  child: SmallJobContainer(
                                                    position: homeCubit
                                                        .newJobMap[keys[rand]]![
                                                            0]
                                                        .position,
                                                    employer: homeCubit
                                                        .newJobMap[keys[rand]]![
                                                            0]
                                                        .employerModel
                                                        .name,
                                                    salary: homeCubit
                                                        .newJobMap[keys[rand]]![
                                                            0]
                                                        .salary
                                                        .toDouble(),
                                                    date:
                                                        "${homeCubit.newJobMap[keys[rand]]![0].startDate.toDate().day} ${DateFormat('MMMM').format(homeCubit.newJobMap[keys[rand]]![0].startDate.toDate())}",
                                                    imagUrl: homeCubit
                                                        .newJobMap[keys[rand]]![
                                                            0]
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
                                )
                              : Container()
                          : const Center(
                              child:
                                  CircularProgressIndicator(color: secondary));
                    },
                  ),

                  // //LEVEL UP TO UNLOCK
                  // BlocConsumer<HomeCubit, HomeState>(
                  //   listener: (context, state) {
                  //     // TODO: implement listener
                  //   },
                  //   builder: (context, state) {
                  //     HomeCubit homeCubit = HomeCubit.get(context);
                  //     return preferenceCubit.userModel != null && preferenceCubit.adminModel != null
                  //         ? preferenceCubit.userModel!.level! > preferenceCubit.adminModel!.leaderLevel
                  //             ? Padding(
                  //                 padding: EdgeInsets.fromLTRB(
                  //                     24.w, 0.h, 24.w, 24.h),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     Row(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.center,
                  //                       children: [
                  //                         CustomText(
                  //                             text: 'Level up to unlock  ',
                  //                             weight: FontWeight.w700,
                  //                             size: 24.sp,
                  //                             color: Colors.white),
                  //                         BigLevelBadge(
                  //                           level: '12',
                  //                         )
                  //                       ],
                  //                     ),
                  //                     CustomText(
                  //                         text:
                  //                             'This category is also based on your level, with higher levels you will be assigned to different kinds of jobs.',
                  //                         weight: FontWeight.w400,
                  //                         size: 10.sp,
                  //                         color:
                  //                             Colors.white.withOpacity(0.7)),
                  //                     SizedBox(height: 16.h),
                  //                     SmallJobContainer(
                  //                       position: 'Supervisor',
                  //                       employer: 'Spotify',
                  //                       salary: 1500.00,
                  //                       date: '9 March',
                  //                       imagUrl:
                  //                           'https://e1.pxfuel.com/desktop-wallpaper/706/920/desktop-wallpaper-spotify-logo-spotify.jpg',
                  //                       containerType: 'recommended',
                  //                     ),
                  //                     SizedBox(height: 16.h),
                  //                     SmallJobContainer(
                  //                       position: 'Usher',
                  //                       employer: 'Anghami',
                  //                       salary: 500.00,
                  //                       date: '9 March',
                  //                       imagUrl:
                  //                           'https://e1.pxfuel.com/desktop-wallpaper/706/920/desktop-wallpaper-spotify-logo-spotify.jpg',
                  //                       containerType: 'recommended',
                  //                     ),
                  //                     SizedBox(height: 16.h),
                  //                     SmallJobContainer(
                  //                       position: 'Intern',
                  //                       employer: 'Red bull',
                  //                       salary: 500.00,
                  //                       date: '9 March',
                  //                       imagUrl:
                  //                           'https://e1.pxfuel.com/desktop-wallpaper/706/920/desktop-wallpaper-spotify-logo-spotify.jpg',
                  //                       containerType: 'recommended',
                  //                     ),
                  //                   ],
                  //                 ),
                  //               )
                  //             : Padding(
                  //                 padding: EdgeInsets.fromLTRB(
                  //                     24.w, 32.h, 24.h, 0.h),
                  //                 child: Column(
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         CustomText(
                  //                             text: 'Level up to unlock  ',
                  //                             weight: FontWeight.w700,
                  //                             size: 24.sp,
                  //                             color: Colors.white),
                  //                         BigLevelBadge(
                  //                           level: '12',
                  //                         )
                  //                       ],
                  //                     ),
                  //                     CustomText(
                  //                         text:
                  //                             'This category is also based on your level, with higher levels you will be assigned to different kinds of jobs.',
                  //                         weight: FontWeight.w400,
                  //                         size: 10.sp,
                  //                         color:
                  //                             Colors.white.withOpacity(0.7)),
                  //                     Stack(
                  //                       alignment: Alignment.center,
                  //                       children: [
                  //                         Padding(
                  //                           // padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.h, 0.h),
                  //                           padding: EdgeInsets.all(0),
                  //                           child: Column(
                  //                             children: [
                  //                               SizedBox(height: 16.h),
                  //                               Column(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .spaceBetween,
                  //                                 children: [
                  //                                   SmallJobContainer(
                  //                                     position: 'Supervisor',
                  //                                     employer: 'Spotify',
                  //                                     salary: 1500.00,
                  //                                     date: '9 March',
                  //                                     imagUrl:
                  //                                         'https://e1.pxfuel.com/desktop-wallpaper/706/920/desktop-wallpaper-spotify-logo-spotify.jpg',
                  //                                     containerType:
                  //                                         'recommended',
                  //                                     isBlurred: true,
                  //                                   ),
                  //                                   SizedBox(height: 16.h),
                  //                                   SmallJobContainer(
                  //                                     position: 'Usher',
                  //                                     employer: 'Anghami',
                  //                                     salary: 500.00,
                  //                                     date: '9 March',
                  //                                     imagUrl:
                  //                                         'https://e1.pxfuel.com/desktop-wallpaper/706/920/desktop-wallpaper-spotify-logo-spotify.jpg',
                  //                                     containerType:
                  //                                         'recommended',
                  //                                     isBlurred: true,
                  //                                   ),
                  //                                   SizedBox(height: 16.h),
                  //                                   SmallJobContainer(
                  //                                     position: 'Intern',
                  //                                     employer: 'Red bull',
                  //                                     salary: 500.00,
                  //                                     date: '9 March',
                  //                                     imagUrl:
                  //                                         'https://e1.pxfuel.com/desktop-wallpaper/706/920/desktop-wallpaper-spotify-logo-spotify.jpg',
                  //                                     containerType:
                  //                                         'recommended',
                  //                                     isBlurred: true,
                  //                                   ),
                  //                                 ],
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         ClipRect(
                  //                           child: BackdropFilter(
                  //                             filter: ui.ImageFilter.blur(
                  //                                 sigmaX: 3.0, sigmaY: 3.0),
                  //                             child: Container(
                  //                               height: 300.h,
                  //                               decoration: BoxDecoration(
                  //                                   color: Colors.white
                  //                                       .withOpacity(0.0)),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         CustomText(
                  //                           text:
                  //                               'This category will be unlocked at level X',
                  //                           weight: FontWeight.w700,
                  //                           size: 22.sp,
                  //                           color: Colors.white,
                  //                           textAlign: TextAlign.center,
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               )
                  //         : const Center(
                  //             child: CircularProgressIndicator(
                  //                 color: secondary));
                  //   },
                  // ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: secondary,
            ),
          );
  }
}
