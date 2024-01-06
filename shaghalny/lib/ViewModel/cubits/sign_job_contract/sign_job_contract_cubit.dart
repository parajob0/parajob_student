import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/utils/snackbar.dart';

part 'sign_job_contract_state.dart';

class SignJobContractCubit extends Cubit<SignJobContractState> {
  SignJobContractCubit() : super(SignJobContractInitial());
  static SignJobContractCubit get(context) => BlocProvider.of<SignJobContractCubit>(context);
  static String jobId="";
  bool contractLoadingIndicator = false;
  bool checked = false;
  static void setJobId(String id){
    jobId = id;
  }

  void changeCheckedValue(){
    checked = !checked;
    emit(ChangeCheckedValue());
  }
  void changeContractLoadingIndicator(bool x){
    contractLoadingIndicator = x;
    emit(ChangeContractLoadingIndicator());
  }


  Future<void> addContract({required String userId, required String jobID, required String contract ,required context})async{

    try{
      DocumentReference<Map<String, dynamic>> doc =  FirebaseFirestore.instance.collection('User').doc(userId);
      DocumentSnapshot<Map<String, dynamic>> value = await doc.get();
      List<dynamic>list = value.data()?['jobs'][jobID];
      list[0]="3"; // state upcoming 3
      if(list.length==3){
        // signature
        list.add(contract);
      }
      else{
        // signature
        list[3]=contract;
      }
      await doc.update({
        'jobs.$jobID': list,
      });

      emit(AddContractSuccess());
    }catch(e){
      print("error Here add contract");
      snackbarMessage("please try again later", context);
      print(e.toString());
      emit(AddContractFail());
    }

  }



}