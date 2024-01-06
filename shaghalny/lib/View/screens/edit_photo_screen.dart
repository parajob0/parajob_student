import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '/View/components/core/custom_text.dart';
import '/ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '/color_const.dart';
import '/utils/page_route.dart';
import 'package:zoom_widget/zoom_widget.dart';

class EditPhotoScreen extends StatefulWidget {
  XFile? image;

  EditPhotoScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  final GlobalKey key = GlobalKey();

  double _xPosition = 1.sw / 2 - 100.w;
  double _yPosition = 1.sh / 2 - 100.h;
  double _scale = 1.8;
  final GlobalKey _backgroundImgKey = GlobalKey();
  final GlobalKey _circleViewKey = GlobalKey();
  late Uint8List imgBytes;
  Future<Uint8List?> _capturePng() async {
    try {
      final RenderBox circleBoundary =
      _circleViewKey.currentContext!.findRenderObject() as RenderBox;
      final Size circleBoundarySize = circleBoundary.size;
      final Offset globalTopLeft = circleBoundary.localToGlobal(Offset.zero);

      final RenderObject? backgroundBoundary = _backgroundImgKey.currentContext!.findRenderObject() ;

      // Background to image
      const double scale = 2.0;
      final double outputW = circleBoundarySize.width * scale;
      final double outputH = circleBoundarySize.height * scale;
      final double srcLeft = globalTopLeft.dx * scale;
      final double srcTop = globalTopLeft.dy * scale;
      ui.Image? image;
      if (backgroundBoundary != null && backgroundBoundary is RenderRepaintBoundary){
           image = await backgroundBoundary?.toImage(pixelRatio: scale);
      }

      // Edit background image
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Rect rect = Rect.fromLTWH(0, 0, outputW, outputH);
      final Canvas canvas = Canvas(recorder, rect);

      // Clip circle
      final Path path = Path()..addOval(Rect.fromLTWH(0, 0, outputW, outputH));
      canvas.clipPath(path);

      final Paint paint = Paint();
      canvas.drawImageRect(
          image!,
          Rect.fromLTWH(srcLeft, srcTop, outputW, outputH),
          Rect.fromLTWH(0, 0, outputW, outputH),
          paint);

      // Finish edit, convert to image render
      final ui.Picture picture = recorder.endRecording();
      final ui.Image img = await picture.toImage(rect.width.toInt(), rect.height.toInt());
      final ByteData? byteData2 = await img.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List? pngBytes2 = byteData2?.buffer.asUint8List();
      final String bs642 = base64Encode(pngBytes2!);
      print(pngBytes2);
      print(bs642);
      setState(() {
        imgBytes = pngBytes2;
      });
      return pngBytes2;
    } catch (e) {
      print(e);
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Content
          BlocConsumer<PreferenceCubit, PreferenceState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var cubit = PreferenceCubit.get(context);
              return Image.network(
                cubit.userModel?.profilePic ?? "",
              );
            },
          ),

          // Content
          InteractiveViewer(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.srcOut),
              // This one will create the magic
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // grey container
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      backgroundBlendMode: BlendMode.dstIn,
                    ), // This one will handle background + difference out
                  ),

                  // white circle
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 380.sp,
                      width: 380.sp,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(390.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // APP BAR
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 0),
            child: Container(
              height: 30.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/backWhite.svg',
                        width: 12.w,
                        height: 16.h,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {},
                      child: CustomText(
                        text: 'Edit',
                        weight: FontWeight.w500,
                        size: 16.sp,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

