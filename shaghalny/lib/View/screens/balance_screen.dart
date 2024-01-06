import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shaghalny/View/components/balance_screen/interval_section.dart';
import 'package:shaghalny/View/components/core/loading_indicator.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import 'package:shaghalny/utils/dateTime/get_month.dart';
import '../../utils/dateTime/get_month.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/profile_screen/user_chart.dart';
import '/color_const.dart';
import '../../ViewModel/cubits/balance_screen/balance_screen_cubit.dart';

class BalanceScreen extends StatefulWidget {
  BalanceScreen({Key? key}) : super(key: key);

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var balanceCubit = BalanceScreenCubit.get(context);
    balanceCubit.resetData();
    balanceCubit.getWeekData();
    balanceCubit.getMonthData();
    balanceCubit.getYearData();
    balanceCubit.changeChartView(index: 0);
  }


  @override
  Widget build(BuildContext context) {
    var balanceCubit = BalanceScreenCubit.get(context);
    PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/backWhite.svg',
                    width: 12.w,
                    height: 20.h,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              "assets/big_balance.svg",
              width: 125.w,
              height: 86.h,
            ),
            SizedBox(
              height: 18.h,
            ),
            CustomText(
                text: "Your balance",
                weight: FontWeight.w400,
                size: 16.sp,
                color: Colors.white.withOpacity(0.6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                    text: "EGP ",
                    weight: FontWeight.w300,
                    size: 16.sp,
                    color: Colors.white.withOpacity(0.6)),
                CustomText(
                    text: "${preferenceCubit.userModel!.totalIncome}",
                    weight: FontWeight.w700,
                    size: 24.sp,
                    color: Colors.white),
              ],
            ),
            SizedBox(
              height: 24.h,
            ),



            BlocConsumer<BalanceScreenCubit, BalanceScreenState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                print(state);
                return Column(
                  children: [
                    DefaultTabController(
                      length: 3,
                      child: TabBar(
                        indicatorColor: secondary,
                        enableFeedback: false,
                        physics: const BouncingScrollPhysics(),
                        // padding: EdgeInsets.fromLTRB(55.w, 0, 55.w, 0),
                        indicatorPadding:
                        EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                        indicatorWeight: 1,
                        splashFactory: NoSplash.splashFactory,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            65.0.sp,
                          ),
                          color: Colors.white.withOpacity(0.15),
                        ),
                        tabs: [
                          Tab(
                            child: Text(
                              "Week",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Month",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Year",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                        onTap: (value) {
                          balanceCubit.changeChartView(index: value);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 47.h,
                    ),
                    UserChart(
                      view: balanceCubit.chartView, // 0  1 2
                      monthName: monthAbbreviations[balanceCubit.currentMonth - 1],

                      acc:(balanceCubit.chartView==0)?balanceCubit.accWeek: (balanceCubit.chartView==1)?balanceCubit.accMonth:balanceCubit.accYear ,
                      startDay: balanceCubit.currentDay,
                      year: balanceCubit.currentYear,
                      month: balanceCubit.currentMonth,
                    ),

                    //WEEK
                    if(balanceCubit.chartView==0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 1,
                        separatorBuilder: (context,index){return Container();},
                        itemBuilder: (context,index){
                          // List<int>startDays=[1,8,15,22];
                          return IntervalSection(start:balanceCubit.currentDay ,monthNum: balanceCubit.currentMonth,jobs: balanceCubit.jobByWeek, type: 0,);
                        },
                      ),

                    //Month View
                    if(balanceCubit.chartView==1)
                       ListView.separated(
                         shrinkWrap: true,
                           physics: const BouncingScrollPhysics(),
                           itemCount: balanceCubit.jobByMonth.length,
                           separatorBuilder: (context,index){return Container();},
                           itemBuilder: (context,index){
                             List<int>startDays=[1,8,15,22,22];
                             return IntervalSection(
                               type: 1,
                               start: startDays[index],
                               end:(startDays[index]==22)?DateTime(balanceCubit.currentYear, balanceCubit.currentMonth + 1, 0).day : startDays[index]+6,
                               monthNum: balanceCubit.currentMonth,
                               jobs: balanceCubit.jobByMonth[index],);
                           },

                       ),


                    // YEAR
                    if(balanceCubit.chartView==2)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: balanceCubit.jobByYear.length,
                        separatorBuilder: (context, index) {
                          return Container();
                        },
                        itemBuilder: (context, index) {
                          return IntervalSection(
                              type: 2,
                              year: DateTime.now().year,
                              monthNum: index,
                              jobs: balanceCubit.jobByYear[index],
                          );
                        },
                      ),
                    SizedBox(height: 16.h,),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

