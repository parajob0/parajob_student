import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shaghalny/View/screens/check_in_out.dart';

import '../../Model/jobs_model/job_model.dart';
import '../../color_const.dart';
import '../../utils/page_route.dart';
import '../../utils/snackbar.dart';
import 'bottom_navigation_screen.dart';

class QrCodeOut extends StatefulWidget {
  bool value;
  int jobDurationInSeconds;
  int jobDurationInHours;
  String lastJobId;

  JobModel? model;
   QrCodeOut({required this.value,
     required this.lastJobId,

     this.jobDurationInSeconds=0,
     this.jobDurationInHours=0,
     this.model,Key? key}) : super(key: key);

  @override
  State<QrCodeOut> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<QrCodeOut> {
  int? jobTime;
  int? jobTimeInHours;
  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
     if(mounted) {
       setState(() {
         result = event;
         /* AppNavigator.customNavigator(
            context: context,
            screen:  CheckInOut(checkInQrCoded: false,checkOutQrCoded: true,),
            finish: true);*/
         if (result != null) {
           if (result!.code == widget.model!.jobId) {
             Navigator.of(context).pop(true);
             // AppNavigator.customNavigator(context: context, screen: BottomNavigation(index: 0,), finish: true);

           }
           else {
             Navigator.of(context).pop(false);
             snackbarMessage("QR code is invalid", context);
           }
         }
       });
     }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    jobTime= int.parse(widget.model!.endDate.toDate().difference(widget.model!.startDate.toDate()).inSeconds.toString());
    jobTimeInHours= int.parse(widget.model!.endDate.toDate().difference(widget.model!.startDate.toDate()).inHours.toString());
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400.h,
              width: 400.w,
              child: QRView(
                  key: _gLobalkey,
                  onQRViewCreated: qr
              ),
            ),
            SizedBox(height: 10.h,),
            Center(
              child:  Text('Scan Code',style: TextStyle(fontSize: 20.sp,color: secondary),),
            )
          ],
        ),
      ),
    );

  }
}