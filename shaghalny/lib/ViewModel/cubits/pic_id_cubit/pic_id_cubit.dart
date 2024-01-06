import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Model/user_model/user_model.dart';
import '../../database/cache_helper/cache_helper.dart';

part 'pic_id_state.dart';

class PicCubit extends Cubit<PicState> {
  PicCubit() : super(PicInitial());

  static PicCubit get(context) => BlocProvider.of<PicCubit>(context);
  // Create a reference to the Firebase Storage bucket
  final storageRef = FirebaseStorage.instance.ref();

  final ImagePicker picker = ImagePicker();

  String imagePath = '';
  bool isTaken = false, isUploaded = false, isEditShown = false, isLoading = false;

  Future<bool> takeImage() async{
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted = await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      // return;

      debugPrint("cannot grant camera access");

      isTaken = false;
      emit(TakePicError());

      return false;
    }

    XFile? pickedCameraImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedCameraImage == null) {

      isTaken = false;
      emit(TakePicError());
      return false;
    }

    debugPrint("\n\n\n taken photo path ---> ${pickedCameraImage.path} \n\n\n");

    isTaken = true;
    imagePath = pickedCameraImage.path.toString();

    emit(TakePicSuccess());
    return true;
  }

  Future<void> uploadImage()async {

    final file = File(imagePath);

    isLoading = true;
    emit(UploadPicIDLoading());
    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Upload file and metadata to the path 'images/mountains.jpg'
    try {
      // final uploadTask =
      UploadTask picRef = storageRef
          .child('picture_with_id/${CacheHelper.getData(key: 'uid')}.jpg')
          .putFile(file, metadata);

      String picUrl = await (await picRef).ref.getDownloadURL();
      // UPLOAD DATA TO FIRESTORE
      FirebaseFirestore.instance.collection("User").doc(CacheHelper.getData(key: 'uid')).set({
        "pic_id": picUrl,
      }, SetOptions(merge: true)).then((value) {

        print("pick id added");
      }).catchError((e) {
        print(e.toString());
      });



      isUploaded = true;
      isLoading = false;
      emit(UploadPicIDSuccess());
    }catch(e){

      isUploaded = false;
      isLoading = false;
      emit(UploadPicIDError());
    }
  }


  void showEditButton(){
    isEditShown = !isEditShown;

    emit(ShowEditButton());
  }
}
