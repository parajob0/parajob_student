import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../Model/employer_model/employer_model.dart';
import '../../../Model/review_model/ReviewModel.dart';

part 'employer_page_state.dart';

class EmployerPageCubit extends Cubit<EmployerPageState> {
  EmployerPageCubit() : super(EmployerPageInitial());

  static EmployerPageCubit get(context) =>
      BlocProvider.of<EmployerPageCubit>(context);

  CollectionReference ref = FirebaseFirestore.instance.collection('employer');
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');

  // Map<String, dynamic>? employerData;

  EmployerModel? employerModel;
  bool gotPositiveReviews = false;

  // List<String> reviewsNames = [];
  // List<String> reviewValue = [];
  // List<Map<String, dynamic>>? reviews;

  List<String> reviewKeys = [];
  List<ReviewModel> reviewModel = [];
  bool gotAll = false;

  void getEmployerData({required String id}){
    DocumentReference employer = ref.doc(id);
    employer.get().then((DocumentSnapshot doc) async {
      employerModel = EmployerModel.fromDocumentSnapshot(
          doc as DocumentSnapshot<Map<String, dynamic>>);


      for (var key in employerModel!.reviews.keys) {
        reviewKeys.add(key);
      }


      // await getReviews();




      // employerModel!.reviews.forEach((key, value) async {
      //   await userRef.doc(key).get().then((DocumentSnapshot docSnapshot) {
      //     // debugPrint("\n\n\n is exists --> ${docSnapshot.exists} \n\n");
      //     final snapshot = docSnapshot.data()! as Map<String, dynamic>;
      //
      //     // Map<String, dynamic> temp = {};
      //
      //     for (int i = 0; i < value.length; i++) {
      //       reviewModel.add(ReviewModel(
      //           userName: "${snapshot['first_name']} ${snapshot['last_name']}",
      //           review: value[i].split("--")[0],
      //           rate: value[i].split("--")[1],
      //           date: DateTime(
      //               int.parse(value[i].split("--")[2].split(".")[2]),
      //               int.parse(value[i].split("--")[2].split(".")[1]),
      //               int.parse(value[i].split("--")[2].split(".")[0]))));
      //
      //       debugPrint("\n\n\n date of ${reviewModel[i].userName} is ==> ${reviewModel[i].date} \n\n");
      //
      //       // reviewsNames.add(
      //       //     "${snapshot['first_name']} ${snapshot['last_name']}");
      //       // // reviewsNames.add(key);
      //       // reviewValue.add(value[i]);
      //     }
      //     // temp[snapshot['name']] = value;
      //     //
      //     // reviews!.add(temp);
      //   });
      // });

      reviewModel.sort((e1, e2) => e2.date.compareTo(e1.date));


      gotAll = true;
      // reviewModel.toList().sort((a, b) => -(DateFormat('yyyy-MMM').parse(a.date.toString()).compareTo(DateFormat('yyyy-MMM').parse(b.date.toString()))));

      // if(reviews!.isNotEmpty)
    }, onError: (e) {
      debugPrint("\n\n\nError getting document: $e\n\n\n");
      gotAll = false;
      emit(GetEmployerDataError());
    });

    // if(reviewModel.isNotEmpty){
    debugPrint("\n\n\n reviews length --> ${reviewModel.length} \n\n");
    // getPositiveReviews();
    // }


    emit(GetEmployerDataSuccess());

  }

  bool gotReviews = false;
  Future<void> getReviews({required EmployerModel empModel})async {


    // for(int j = 0; j < employerModel!.reviews.length; j++){
    //   userRef.doc(reviewKeys[j]).get().then((DocumentSnapshot docSnapshot){
    //     // debugPrint("\n\n\n is exists --> ${docSnapshot.exists} \n\n");
    //     final snapshot = docSnapshot.data()! as Map<String, dynamic>;
    //
    //     for (int i = 0; i < employerModel!.reviews[reviewKeys[j]].length; i++) {
    //       reviewModel.add(ReviewModel(
    //           userName: "${snapshot['first_name']} ${snapshot['last_name']}",
    //           review: employerModel!.reviews[reviewKeys[j]][i].split("--")[0],
    //           rate: employerModel!.reviews[reviewKeys[j]][i].split("--")[1],
    //           date: DateTime(
    //               int.parse(employerModel!.reviews[reviewKeys[j]][i].split("--")[2].split(".")[2]),
    //               int.parse(employerModel!.reviews[reviewKeys[j]][i].split("--")[2].split(".")[1]),
    //               int.parse(employerModel!.reviews[reviewKeys[j]][i].split("--")[2].split(".")[0]))));
    //
    //       debugPrint("\n\n\n date of ${reviewModel[i].userName} is ==> ${reviewModel[i].date} \n\n");
    //     }
    //   });
    // }


    try{
      // debugPrint("\n\n\n reviews -> ${empModel.reviews} \n\n");
      for (var key in empModel.reviews.keys) {
        // debugPrint("\n\n\n key -> $key \n\n");
        userRef.doc(key.trim()).get().then((DocumentSnapshot docSnapshot){

          if(docSnapshot.exists){
            final snapshot = docSnapshot.data() as Map<String, dynamic>;

            for(int i = 0; i < empModel.reviews[key].length; i++){
              reviewModel.add(ReviewModel(userName: "${snapshot['first_name']} ${snapshot['last_name']}",
                  review: empModel.reviews[key][i].split("--")[0],
                  rate: empModel.reviews[key][i].split("--")[1],
                  date: DateTime(
                    int.parse(empModel.reviews[key][i].split("--")[2].split(".")[2]),
                    int.parse(empModel.reviews[key][i].split("--")[2].split(".")[1]),
                    int.parse(empModel.reviews[key][i].split("--")[2].split(".")[0]),
                  )
              ));

              emit(GetReviewsSuccess());
            }
          }
        });
      }

      getPositiveReviews(empModel: empModel);
      gotReviews = true;
      emit(GetReviewsSuccess());
    }catch(e){
      debugPrint("Error in getting reviews $e");
      gotReviews = false;
      emit(GetReviewsError());
    }

    // for(int j = 0; j < empModel.reviews.length; j++){
    //   userRef.doc(empModel.reviews.keys.toList()[j]).get().then((DocumentSnapshot docSnapshot){
    //     // debugPrint("\n\n\n is exists --> ${docSnapshot.exists} \n\n");
    //     final snapshot = docSnapshot.data()! as Map<String, dynamic>;
    //
    //     for (int i = 0; i < empModel.reviews[reviewKeys[j]].length; i++) {
    //       reviewModel.add(ReviewModel(
    //           userName: "${snapshot['first_name']} ${snapshot['last_name']}",
    //           review: employerModel!.reviews[reviewKeys[j]][i].split("--")[0],
    //           rate: employerModel!.reviews[reviewKeys[j]][i].split("--")[1],
    //           date: DateTime(
    //               int.parse(employerModel!.reviews[reviewKeys[j]][i].split("--")[2].split(".")[2]),
    //               int.parse(employerModel!.reviews[reviewKeys[j]][i].split("--")[2].split(".")[1]),
    //               int.parse(employerModel!.reviews[reviewKeys[j]][i].split("--")[2].split(".")[0]))));
    //
    //       debugPrint("\n\n\n date of ${reviewModel[i].userName} is ==> ${reviewModel[i].date} \n\n");
    //     }
    //   });
    // }


  }


  double positiveReviewsPercent = 10.0;
  void getPositiveReviews({required EmployerModel empModel}){
    int count = 0;

    // if(employerModel != null){
    //   for(int i = 0; i < employerModel!.reviews.length; i++){
    //     for(int j = 0; j < employerModel!.reviews[i].length; j++){
    //       debugPrint("\n\n rate is ==> ${employerModel!.reviews[i].split("--")[1]}");
    //
    //       if(double.parse(employerModel!.reviews[i].split("--")[1]) > 3.0){
    //         count++;
    //       }
    //     }
    //   }


    for( var key in empModel.reviews.keys){
      for(int i = 0; i < empModel.reviews[key].length; i++){

        debugPrint("\n\n\n empModel.reviews[i] -> ${empModel.reviews[key]} \n\n");
        debugPrint("\n\n\n hehe -> ${empModel.reviews[key][i]} \n\n");
        if(double.parse(empModel.reviews[key][i].split("--")[1]) > 3){
          count++;
        }
      }
    }
      // for(int i = 0; i < empModel.reviews.length; i++){
      //   for(int j = 0; j < empModel.reviews[empModel.reviews[i]].length; j++){
      //     if(double.parse(empModel.reviews[empModel.reviews[i]].split("--")[1]) > 3){
      //       count++;
      //     }
      //   }
      // }


      // for(int i = 0; i < reviewModel.length; i++){
      //
      //   debugPrint("\n\n rate is ==> ${reviewModel[i].rate}");
      //
      //   if(double.parse(reviewModel[i].rate) > 3.0){
      //     count++;
      //   }
      // }

      positiveReviewsPercent = ((count/empModel.reviews.length) * 100).floorToDouble();

      gotPositiveReviews = true;
      emit(GetReviewsPositivePercentage());
    }

  }

