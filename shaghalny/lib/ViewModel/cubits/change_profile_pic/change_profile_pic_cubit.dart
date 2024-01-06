import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';

part 'change_profile_pic_state.dart';

class ChangeProfilePicCubit extends Cubit<ChangeProfilePicState> {
  ChangeProfilePicCubit() : super(ChangeProfilePicInitial());

  static ChangeProfilePicCubit get(context) => BlocProvider.of<ChangeProfilePicCubit>(context);

  File? selectedImage;
  // upload to firestore

  void setSelectedImage(File file){
    selectedImage = file;
    emit(SetSelectedImageSuccess());
  }



  Future<String> uploadNewProfilePic(String uid, File image, PreferenceCubit cubit) async {
    try {
      emit(UploadNewProfilePicLoading());
      final path = "profile_pic/${uid}";
      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print("Download Link : $urlDownload");

      updatePicInUserModel(urlDownload, cubit);
      await updatePicInDatabase(uid,urlDownload);

      emit(UploadNewProfilePicSuccess());
      return urlDownload;
    } catch (e) {
      print(e.toString());
      emit(UploadNewProfilePicFail());
      return "";
    }
  }

  // update user data in firebase and user model
  void updatePicInUserModel(String str, PreferenceCubit cubit) {
    cubit.changeProfilePic(str);
    emit(UpdatePicInUserModelSuccess());
  }

  Future<void> updatePicInDatabase(String uid, String imageUrl) async {
    FirebaseFirestore.instance.collection('User')
        .doc(uid)
        .update({'profile_pic': imageUrl})
        .then((value) {})
        .catchError((error) {});
  }
}
