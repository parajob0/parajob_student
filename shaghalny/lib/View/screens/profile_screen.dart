import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numeral/ext.dart';
import 'package:shaghalny/ViewModel/cubits/balance_screen/balance_screen_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/change_profile_pic/change_profile_pic_cubit.dart';
import 'package:shaghalny/utils/dateTime/get_month.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/core/level_badge.dart';
import '/View/components/core/progress_bar.dart';
import '/View/components/core/small_job_container.dart';
import '/View/components/profile_screen/profile_container.dart';
import '/View/components/profile_screen/user_avatar.dart';
import '/View/screens/balance_screen.dart';
import '/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '/utils/page_route.dart';
import '../../color_const.dart';
import 'menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var preferenceCubit = PreferenceCubit.get(context);
    var balanceCubit = BalanceScreenCubit.get(context)
      ..getJobHistory(prefCubit: preferenceCubit);
    String image = preferenceCubit.userModel?.profilePic ?? "";
    return Scaffold(
      backgroundColor: primary,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60.h),
                child: Container(
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkResponse(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BalanceScreen()));
                          },
                          child: SvgPicture.asset(
                            'assets/coin.svg',
                            width: 28.w,
                            height: 26.h,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          child: InkResponse(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MenuScreen()));
                            },
                            child: SvgPicture.asset(
                              'assets/menu.svg',
                              width: 18.w,
                              height: 15.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        BlocConsumer<ChangeProfilePicCubit,
                            ChangeProfilePicState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            return UserAvatar(
                              image:
                                  preferenceCubit.userModel?.profilePic ?? "",
                              level: "${preferenceCubit.userModel?.level}",
                            );
                          },
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        CustomText(
                          text: preferenceCubit.userModel?.firstName ?? "",
                          weight: FontWeight.w600,
                          size: 18.sp,
                          textAlign: TextAlign.center,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocConsumer<PreferenceCubit, PreferenceState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                var preferenceCubit =
                                    PreferenceCubit.get(context);
                                return CustomText(
                                  text: "${preferenceCubit.userModel?.xp}/3500",
                                  weight: FontWeight.w500,
                                  size: 10.sp,
                                  color: secondary,
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            CustomProgressBar(
                              progress:
                                  (preferenceCubit.userModel!.xp! / 3500) * 100,
                              width: 140.w,
                              height: 6.h,
                            ),
                            SizedBox(width: 5.w),
                            BlocConsumer<PreferenceCubit, PreferenceState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                var preferenceCubit =
                                    PreferenceCubit.get(context);
                                //TODO add one here in profile screen
                                int nextLevel =
                                    (preferenceCubit.userModel?.level ?? 0) + 1;
                                return BigLevelBadge(
                                  level: "$nextLevel",
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  BlocConsumer<PreferenceCubit, PreferenceState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      var preferenceCubit = PreferenceCubit.get(context);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileContainer(
                            title: "JOBS",
                            number: (preferenceCubit.userModel?.jobHistory !=
                                    null)
                                ? "${preferenceCubit.userModel?.jobHistory?.length.numeral(fractionDigits: 1)}+"
                                : "0",
                          ),
                          ProfileContainer(
                            title: "INCOME",
                            number: (preferenceCubit.userModel?.totalIncome !=
                                    null)
                                ? "${preferenceCubit.userModel?.totalIncome?.numeral(fractionDigits: 1)}+"
                                : "0",
                          ),
                          ProfileContainer(
                            title: "COMPANIES",
                            number: (preferenceCubit
                                        .userModel?.employersCount.length !=
                                    null)
                                ? "${balanceCubit.companies.length.numeral(fractionDigits: 1)}+"
                                : "0",
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomText(
                    text: "Your job history",
                    weight: FontWeight.w600,
                    size: 18.sp,
                    textAlign: TextAlign.start,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  BlocConsumer<BalanceScreenCubit, BalanceScreenState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is GetJobHistoryLoading) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: secondary,
                        ));
                      } else {
                        return balanceCubit.jobHistory.isNotEmpty
                            ? ListView.separated(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    min(3, balanceCubit.jobHistory.length),
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 16.h,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  debugPrint("\n\nemployer name ==> ${balanceCubit.jobHistory[index].employerModel.name}\n\n");
                                  return SmallJobContainer(
                                    position:
                                        balanceCubit.jobHistory[index].position,
                                    employer: balanceCubit
                                        .jobHistory[index].employerModel.name,
                                    salary: balanceCubit
                                        .jobHistory[index].salary
                                        .toDouble(),
                                    date:
                                        '${balanceCubit.jobHistory[index].startDate.toDate().day} ${getMonth(balanceCubit.jobHistory[index].startDate.toDate().month)}',
                                    imagUrl:
                                        balanceCubit.jobHistory[index].employerModel.image,
                                    containerType: 'recommended',
                                    borderColor:
                                        const Color.fromRGBO(184, 186, 187, 1),
                                  );
                                },
                              )
                            : Center(
                                child: Padding(
                                padding: EdgeInsets.only(top: 60.h),
                                child: CustomText(
                                    text: "No jobs yet",
                                    weight: FontWeight.w300,
                                    size: 15.sp,
                                    color: Colors.white.withOpacity(0.6)),
                              ));
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  if (balanceCubit.jobHistory.length > 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            AppNavigator.customNavigator(
                                context: context,
                                screen: BalanceScreen(),
                                finish: false);
                          },
                          child: CustomText(
                            text: "View more",
                            weight: FontWeight.w500,
                            size: 16.sp,
                            textAlign: TextAlign.start,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/homeNext.svg',
                                width: 5.w,
                                height: 8.h,
                              ),
                              SvgPicture.asset(
                                'assets/homeNext.svg',
                                width: 5.w,
                                height: 8.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
