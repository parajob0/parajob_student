import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import 'package:shaghalny/ViewModel/cubits/preference_cubit/preference_cubit.dart';

import '../../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../../screens/approval_screen.dart';
import '../../screens/bottom_navigation_screen.dart';
import 'custom_text.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PreferenceCubit preferenceCubit = PreferenceCubit.get(context);
    // JobsCubit jobsCubit = JobsCubit.get(context);
    PreferenceCubit preferenceCubit =
    BlocProvider.of<PreferenceCubit>(context, listen: true);
    return InkResponse(
      // onTap: ()async{
      //   String? uid = preferenceCubit.userModel?.id;
      //   await preferenceCubit.getUser(id: uid??"");
      //   await jobsCubit.fillJobs(preferenceCubit, context).then((value){
      //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigation(index: 0,)));
      //   });
      onTap: (){
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> preferenceCubit.userModel!.isApproved ?
        // BottomNavigation(index: 0,)
        // : const ApprovalScreen()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigation(index: 0,)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
              text: 'Skip >>',
              weight: FontWeight.w500,
              size: 16.sp,
              color: Colors.white),
        ],
      ),
    );
  }
}
