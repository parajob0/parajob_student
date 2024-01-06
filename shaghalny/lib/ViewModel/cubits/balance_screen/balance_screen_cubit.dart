import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

import '../../../Model/jobs_model/job_model.dart';
import '../preference_cubit/preference_cubit.dart';

part 'balance_screen_state.dart';

int getStartDayOfTheWeek(int d) {
  List<int> list = [1, 8, 15, 22];
  int num = 0;
  list.forEach((element) {
    if (element <= d) {
      num = element;
    }
  });
  return num;
}

class BalanceScreenCubit extends Cubit<BalanceScreenState> {
  PreferenceCubit preferenceCubit;

  BalanceScreenCubit(this.preferenceCubit) : super(BalanceScreenInitial());

  static BalanceScreenCubit get(context) => BlocProvider.of<BalanceScreenCubit>(context);

  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  CollectionReference jobRef = FirebaseFirestore.instance.collection('jobs');
  CollectionReference empRef = FirebaseFirestore.instance.collection('employer');

  int chartView = 0;
  DateTime date = DateTime.now();
  String monthName = '';

  int currentDay = getStartDayOfTheWeek(DateTime.now().day);
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  void previous() {
    DateTime currentDate = DateTime.now();
    if (chartView == 0) {
      subtractDay();
    } else if (chartView == 1) {
      subtractMonth();
    } else {
      subtractYear();
    }
    getWeekData();
    getMonthData();
    getYearData();
    emit(PreviousSuccess());
  }

  void next() {
    if (chartView == 0) {
      addDay();
    } else if (chartView == 1) {
      addMonth();
    } else {
      addYear();
    }
    getWeekData();
    getMonthData();
    getYearData();
    emit(NextSuccess());
  }

  void addDay() {
    // I'm sure the the day is always the start of the week
    // if want to find start of the next week [1,8,15,22];
    if (currentDay == 22) {
      currentDay = 1;
      addMonth();
    } else {
      currentDay += 7;
    }
  }

  void addMonth() {
    if (currentMonth == 12) {
      currentMonth = 1;
      addYear();
    } else {
      currentMonth++;
    }
  }

  void addYear() {
    currentYear++;
  }

  void subtractDay() {
    // I'm sure the the day is always the start of the week
    // if want to find start of the previous week [1,8,15,22];
    if (currentDay == 1) {
      currentDay = 22;
      subtractMonth();
    } else {
      currentDay -= 7;
    }
  }

  void subtractMonth() {
    if (currentMonth - 1 == 0) {
      currentMonth = 12;
      subtractYear();
    } else {
      currentMonth--;
    }
  }

  void subtractYear() {
    currentYear--;
  }

  void changeChartView({required int index}) {
    chartView = index;
    emit(ChartViewSuccess());
  }

  void resetData() {
    currentDay = getStartDayOfTheWeek(DateTime.now().day);
    currentMonth = DateTime.now().month;
    currentYear = DateTime.now().year;
    emit(ResetData());
  }

  List<JobModel> jobHistory = [];
  Set<String>companies={};
  Future<void> getJobHistory({required PreferenceCubit prefCubit}) async {
    emit(GetJobHistoryLoading());
    if (jobHistory.isEmpty) {
      for (int i = 0; i < prefCubit.userModel!.jobHistory!.keys.length; i++) {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await jobRef
            .doc(prefCubit.userModel!.jobHistory!.keys.elementAt(i))
            .get() as DocumentSnapshot<Map<String, dynamic>>;

        // String ?id = snapshot['employer_id'];
        if (snapshot.data()!['employer_id'] == null) continue;
        String? id = snapshot.data()!['employer_id'];
        DocumentSnapshot employerSnapshot = await empRef.doc(id).get();

        jobHistory.add(JobModel.fromDocumentSnapshot(snapshot, employerSnapshot as DocumentSnapshot<Map<String, dynamic>>));
        companies.add(snapshot.id);
      }
      jobHistory.sort((a, b) => a.startDate.millisecondsSinceEpoch.compareTo(b.startDate.millisecondsSinceEpoch));
      print("job history size is ${jobHistory.length}");
    }
    emit(GetJobHistorySuccess());
  }



  List<JobModel> jobByWeek = []; // current week // done
  List<int> accWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  void getWeekData() {
    jobByWeek.clear();
    accWeek.clear();

    int start = currentDay; // start of the week
    int end = (start == 22) ? 31 : (start + 6);

    jobByWeek = jobHistory
        .where((e) =>
            e.startDate.toDate().month == currentMonth &&
            e.startDate.toDate().year == currentYear)
        .where((e) =>
            e.startDate.toDate().day >= start &&
            e.startDate.toDate().day <= end)
        .toList();
    getAccWeek();
    emit(GetWeekData());
  }

  void getAccWeek() {
    accWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    // fit 22 -> 30 in array from index 0 -> end of array
    jobByWeek.forEach((element) {
      int cd = currentDay;
      int minus = int.parse(preferenceCubit.userModel!.jobHistory![element.jobId].toString().split('--')[1]);
      int jobStartDay = element.startDate.toDate().day;
      accWeek[jobStartDay-cd] += (element.salary - minus);
    });
  }

  List<List<JobModel>> jobByMonth = List.generate(4, (_) => []);
  List<int> accMonth =[0, 0, 0, 0, 0, 0,0];

  void getMonthData() {
    jobByMonth = List.generate(4, (_) => []); // clearData
    accMonth = [0, 0, 0, 0, 0, 0,0];
    final filteredList = jobHistory
        .where((element) =>
            element.startDate.toDate().year == currentYear &&
            element.startDate.toDate().month == currentMonth)
        .toList();
    jobByMonth[0] = filteredList
        .where((element) =>
            element.startDate.toDate().day >= 1 &&
            element.startDate.toDate().day <= 7)
        .toList();
    jobByMonth[1] = filteredList
        .where((element) =>
            element.startDate.toDate().day >= 8 &&
            element.startDate.toDate().day <= 14)
        .toList();
    jobByMonth[2] = filteredList
        .where((element) =>
            element.startDate.toDate().day >= 15 &&
            element.startDate.toDate().day <= 21)
        .toList();
    jobByMonth[3] = filteredList
        .where((element) =>
            element.startDate.toDate().day >= 22 &&
            element.startDate.toDate().day <= 31)
        .toList();
    getAccMonth();
    emit(GetMonthData());
  }

  void getAccMonth() {
    for (int i = 0; i < jobByMonth.length; i++) {
      int total = 0;
      for (int j = 0; j < jobByMonth[i].length; j++) {
        int minus = int.parse(preferenceCubit
            .userModel!.jobHistory![jobByMonth[i][j].jobId]
            .toString()
            .split('--')[1]);
        total += jobByMonth[i][j].salary - minus;
      }
      accMonth[i + 1] = total;
    }
    print("done");
  }

  List<List<JobModel>> jobByYear = List.generate(12, (_) => []);
  List<int> accYear = List.generate(12, (_) => 0);

  void getYearData() {
    //clear Lists
    jobByYear = List.generate(12, (_) => []);
    accYear = List.generate(12, (_) => 0);
    for (int i = 0; i <= 11; i++) {
      int month = i + 1;
      jobByYear[i] = jobHistory
          .where((element) =>
              element.startDate.toDate().year == currentYear &&
              element.startDate.toDate().month == month)
          .toList();
    }
    getAccYear();
    emit(GetYearData());
  }
  void getAccYear() {
    for (int i = 0; i < jobByYear.length; i++) {
      int total = 0;
      for (int j = 0; j < jobByYear[i].length; j++) {
        int minus = int.parse(preferenceCubit
            .userModel!.jobHistory![jobByYear[i][j].jobId]
            .toString()
            .split('--')[1]);
        total += jobByYear[i][j].salary - minus;
      }
      accYear[i] = total;
    }
  }


  void clearAllData(){
    try{
      jobByYear = List.generate(12, (_) => []);
      accYear = List.generate(12, (_) => 0);
      accMonth = [0];
      jobByMonth = List.generate(4, (_) => []);
      jobByWeek = [];
      accWeek = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      jobHistory = [];
      companies={};
      chartView = 0;
    }catch(e){
      print(e.toString());
    }

  }
}
