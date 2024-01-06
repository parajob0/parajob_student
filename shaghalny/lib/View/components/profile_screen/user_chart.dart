// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/color_const.dart';

import '../../../ViewModel/cubits/balance_screen/balance_screen_cubit.dart';
import '../core/custom_text.dart';


class UserChart extends StatelessWidget {

  int view;
  int startDay;
  int month;
  int year;
  String monthName;
  List<int>acc;
  UserChart({required this.month,required this.year,required this.startDay,required this.acc,required this.view, required this.monthName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BalanceScreenCubit balanceCubit = BlocProvider.of<BalanceScreenCubit>(context, listen: true);
    int lastDay = DateTime(year, month + 1, 0).day;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: LineChart(
            mainData(acc,balanceCubit,lastDay),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 55.w, right: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkResponse(
                  onTap: (){
                    balanceCubit.previous();
                  },
                  child: SvgPicture.asset('assets/backWhite.svg', width: 8.w, height: 12.h)
              ),
              InkResponse(
                  onTap: (){
                    balanceCubit.next();
                  },
                  child: SvgPicture.asset('assets/go_to.svg', width: 8.w, height: 12.h)
              ),

            ],
          ),
        )

      ],
    );
  }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;

    if(view == 0){
      switch (value.toInt()) {
        case 0:
          text = '${startDay}';
          break;
        case 1:
          text = '${startDay+1}';
          break;
        case 2:
          text = '${startDay+2}';
          break;
        case 3:
          text = '${startDay+3}';
          break;
        case 4:
          text = '${startDay+4}';
          break;
        case 5:
          text = '${startDay+5}';
          break;
        case 6:
          text = '${startDay+6}';
          break;
        case 7:
          text = '${startDay+7}';
          break;
        case 8:
          text = '${startDay+8}';
          break;
        case 9:
          text = '${startDay+9}';
          break;
        case 10:
          text = '${startDay+10}';
          break;

        default:
          text = '${startDay+6}';
          break;
      }
    }
    else if(view == 1){
      switch (value.toInt()) {
        case 0:
          text = '1';
          break;
        case 1:
          text = '7';
          break;
        case 2:
          text = '15';
          break;
        case 3:
          text = '21';
          break;
        default:
          text = '${DateTime(year, month + 1, 0).day}';
      }
    }
    else{
      switch (value.toInt()) {
        case 0:
          text = 'Jan';
          break;
        case 1:
          text = 'Feb';
          break;
        case 2:
          text = 'Mar';
          break;
        case 3:
          text = 'Apr';
          break;
        case 4:
          text = 'May';
          break;
        case 5:
          text = 'Jun';
          break;
        case 6:
          text = 'July';
          break;
        case 7:
          text = 'Aug';
          break;
        case 8:
          text = 'Sep';
          break;
        case 9:
          text = 'Oct';
          break;
        case 10:
          text = 'Nov';
          break;
        default:
          text = 'Dec';
          break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: view == 0 || view == 2 ?
        CustomText(text: text, weight: FontWeight.w600, size: 11.sp, color: const Color(0xFFB8BABB))
      : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(text: text, weight: FontWeight.w600, size: 11.sp, color: const Color(0xFFB8BABB)),
          CustomText(text: monthName.substring(0, 3), weight: FontWeight.w700, size: 7.sp, color: const Color(0xFFB8BABB)),
        ],
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {

    String text;
    switch (value.toInt()) {
      case 0:
        text = '0.00  ';
        break;
      case 0:
        text = '0.00  ';
        break;
      case 1000:
        text = '1000  ';
        break;
      case 1000:
        text = '1000  ';
        break;
      case 2000:
        text = '2000  ';
        break;
      case 2000:
        text = '2000  ';
        break;
      case 3000:
        text = '3000  ';
        break;
      default:
        text = '3000  ';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(text: "EGP ", weight: FontWeight.w300, size: 10, color: Colors.white.withOpacity(0.6)),
        CustomText(text: text, weight: FontWeight.w700, size: 10, color: Colors.white),
      ],
    );
  }

  LineChartData mainData(List<int>acc , BalanceScreenCubit balanceCubit,int lastDay ) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1000,
        verticalInterval: view == 2 ? 3: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.h,
            interval: view == 2 ? 3 : 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1000,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 52.w,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: view == 0 ?((startDay==22)?(lastDay.toDouble()-22):6) : view == 1 ? 4 : 12,
      minY: 0,
      maxY: 3000,
      lineBarsData: [
        view == 0 ?
        LineChartBarData(
          spots:(startDay==22)
              ?List.generate(lastDay-22+1, (index) => FlSpot(index.toDouble(), acc[index].toDouble()))
              :List.generate(7, (index) => FlSpot(index.toDouble(), acc[index].toDouble())),
          isCurved: true,
          color: secondary,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                secondary,
                primary,
              ]
                  .map((color) => color.withOpacity(0.2))
                  .toList(),
            ),
          ),
        )

        : view == 1 ?
        LineChartBarData(
          spots: [
            FlSpot(0, acc[0].toDouble()),
            FlSpot(1, acc[1].toDouble()),
            FlSpot(2, acc[2].toDouble()),
            FlSpot(3, acc[3].toDouble()),
            FlSpot(4, acc[4].toDouble()),
          ],
          isCurved: true,
          color: secondary,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                secondary,
                primary,
              ]
                  .map((color) => color.withOpacity(0.2))
                  .toList(),
            ),
          ),
        )

        : LineChartBarData(
          spots:  [
            FlSpot(0, acc[0].toDouble()),
            FlSpot(1, acc[1].toDouble()),
            FlSpot(2, acc[2].toDouble()),
            FlSpot(3, acc[3].toDouble()),
            FlSpot(4, acc[4].toDouble()),
            FlSpot(5, acc[5].toDouble()),
            FlSpot(6, acc[6].toDouble()),
            FlSpot(7, acc[7].toDouble()),
            FlSpot(8, acc[8].toDouble()),
            FlSpot(9, acc[9].toDouble()),
            FlSpot(10, acc[10].toDouble()),
            FlSpot(12, acc[11].toDouble()),
          ],
          isCurved: true,
          color: secondary,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                secondary,
                primary,
              ]
                  .map((color) => color.withOpacity(0.2))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}


//
// class UserChart extends StatefulWidget {
//
//
//
//   const UserChart({super.key});
//
//   @override
//   State<UserChart> createState() => _UserChartState();
// }
//
// class _UserChartState extends State<UserChart> {
//   List<Color> gradientColors = [
//     secondary,
//     secondary,
//   ];
//
//   bool showAvg = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.center,
//       children: <Widget>[
//         AspectRatio(
//           aspectRatio: 1.70,
//           child: LineChart(
//             mainData(),
//           ),
//         ),
//
//         Padding(
//           padding: EdgeInsets.only(left: 55.w, right: 5.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkResponse(
//                 onTap: (){},
//                 child: SvgPicture.asset('assets/backWhite.svg', width: 8.w, height: 12.h)
//               ),
//               InkResponse(
//                 onTap: (){},
//                 child: SvgPicture.asset('assets/go_to.svg', width: 8.w, height: 12.h)
//               ),
//
//             ],
//           ),
//         )
//
//       ],
//     );
//   }
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.bold,
//       fontSize: 10,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = 'Jan';
//         break;
//       case 1:
//         text = 'Feb';
//         break;
//       case 2:
//         text = 'Mar';
//         break;
//       case 3:
//         text = 'Apr';
//         break;
//       case 4:
//         text = 'May';
//         break;
//       case 5:
//         text = 'Jun';
//         break;
//       case 6:
//         text = 'July';
//         break;
//       case 7:
//         text = 'Aug';
//         break;
//       case 8:
//         text = 'Sep';
//         break;
//       case 9:
//         text = 'Oct';
//         break;
//       case 10:
//         text = 'Nov';
//         break;
//       case 11:
//         text = 'Dec';
//         break;
//       default:
//         text = '';
//         break;
//     }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: CustomText(text: text, weight: FontWeight.w600, size: 9.sp, color: const Color(0xFFB8BABB)),
//     );
//   }
//
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//
//     String text;
//     switch (value.toInt()) {
//       case 0:
//         text = '0.00  ';
//         break;
//       case 1:
//         text = '0.00  ';
//         break;
//       case 500:
//         text = '500  ';
//         break;
//       case 3:
//         text = '500  ';
//         break;
//       case 1000:
//         text = '1000  ';
//         break;
//       case 1500:
//         text = '1500  ';
//         break;
//       case 6:
//         text = '1500  ';
//         break;
//       default:
//         text = '2000  ';
//     }
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         CustomText(text: "EGP ", weight: FontWeight.w300, size: 10, color: Colors.white.withOpacity(0.6)),
//         CustomText(text: text, weight: FontWeight.w700, size: 10, color: Colors.white),
//       ],
//     );
//   }
//
//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 500,
//         verticalInterval: 3,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: Colors.white.withOpacity(0.15),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: Colors.white.withOpacity(0.15),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 3,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 500,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 52.w,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: 11,
//       minY: 0,
//       maxY: 1500,
//       lineBarsData: [
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 900),
//             FlSpot(2.6, 600),
//             FlSpot(4.9, 1100),
//             FlSpot(6.8, 10),
//             FlSpot(8, 346),
//             FlSpot(9.5, 1500),
//             FlSpot(11, 1500),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 1.5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 secondary,
//                 primary,
//               ]
//                   .map((color) => color.withOpacity(0.2))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }