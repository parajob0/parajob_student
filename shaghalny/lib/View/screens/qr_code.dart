import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shaghalny/View/screens/check_in_out.dart';

import '../../Model/jobs_model/job_model.dart';
import '../../color_const.dart';
import '../../utils/page_route.dart';
import '../../utils/snackbar.dart';

class QrCodeIn extends StatefulWidget {
  int jobDurationInSeconds;
  int jobDurationInHours;
  JobModel? model;
  String lastJobId;

   QrCodeIn({
     this.jobDurationInSeconds=0,
     this.jobDurationInHours=0,
     this.model,
     required this.lastJobId,

   });
  @override
  State<QrCodeIn> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<QrCodeIn> {
  int? jobTime;
  int? jobTimeInHours;

  final GlobalKey _gLobalkey = GlobalKey();
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        if(result!.code==widget.model!.jobId) {
          AppNavigator.customNavigator(
              context: context,
              screen: CheckInOut(checkInQrCoded: true, checkOutQrCoded: false,
                jobDurationInSeconds: jobTime! ,jobDurationInHours: jobTimeInHours!,model: widget.model,lastJobId: widget.lastJobId,),
              finish: true);
        }
        else{
          AppNavigator.customNavigator(
              context: context,
              screen: CheckInOut(checkInQrCoded: false, checkOutQrCoded: false,
                jobDurationInSeconds: jobTime! ,jobDurationInHours: jobTimeInHours!,model: widget.model,lastJobId: widget.lastJobId,),
              finish: true);
          snackbarMessage("QR code is invalid", context);
        }
      });
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