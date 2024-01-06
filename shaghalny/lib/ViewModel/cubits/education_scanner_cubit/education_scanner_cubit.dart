import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Model/user_model/user_model.dart';
import '../../database/cache_helper/cache_helper.dart';

part 'education_scanner_state.dart';

class EducationScannerCubit extends Cubit<EducationScannerState> {
  EducationScannerCubit() : super(EducationScannerInitial());

  static EducationScannerCubit get(context) => BlocProvider.of<EducationScannerCubit>(context);

  // Create a reference to the Firebase Storage bucket
  final storageRef = FirebaseStorage.instance.ref();

  String imagePath = 'imagePath';
  bool idScanned = false;

  Future<bool> scanID() async{
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted = await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      // return;

      debugPrint("cannot grant camera access");

      idScanned = false;
      emit(EducationScannerError());

      return false;
    }

    // Generate filepath for saving
    imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
    } catch (e) {
      debugPrint(e.toString());

      idScanned = false;
      return false;
    }

    idScanned = true;
    emit(EducationScannerSuccess());

    return true;

  }

  void uploadImage(BuildContext context)async {

    final file = File(imagePath);

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Upload file and metadata to the path 'images/mountains.jpg'
    try {
      // final uploadTask =
      UploadTask uniRef = storageRef
          .child('university_id/${CacheHelper.getData(key: 'uid')}.jpg')
          .putFile(file, metadata);

      String uniUrl = await (await uniRef).ref.getDownloadURL();

      // UPLOAD DATA TO FIRESTORE
      FirebaseFirestore.instance.collection("User").doc(CacheHelper.getData(key: 'uid')).set({
        "university_id": uniUrl,
      }, SetOptions(merge: true)).then((value) {

        print("front and back id added");
      }).catchError((e) {
        print(e.toString());
      });


      emit(UploadEducationIDSuccess());
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('University ID uploaded')));
    }catch(e){
      emit(UploadEducationIDError());
    }
  }

}
