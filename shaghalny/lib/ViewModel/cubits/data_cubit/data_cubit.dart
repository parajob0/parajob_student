import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial());
  static DataCubit get(context) => BlocProvider.of<DataCubit>(context);
  // not used yet
  Map<String,DocumentSnapshot<Map<String, dynamic>>> jobs={};
  Map<String,DocumentSnapshot<Map<String, dynamic>>> employers={};


  Future<DocumentSnapshot<Map<String, dynamic>>> getJobById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> value =
    await FirebaseFirestore
        .instance
        .collection('jobs')
        .doc(id)
        .get();
    return value;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>  getEmployerById(String employerId) async {
    List<String> list = [];
    DocumentSnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
        .collection('employer')
        .doc(employerId.trim())
        .get();
    return value;
  }

}