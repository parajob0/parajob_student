import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../color_const.dart';
class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
      ),
      child: const Center(
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(color: secondary,),
        ),
      ),
    );
  }
}
