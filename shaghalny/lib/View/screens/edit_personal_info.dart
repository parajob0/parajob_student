import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/Model/user_model/user_model.dart';
import '/View/components/core/custom_text.dart';
import '/View/components/core/sign_in_appBar.dart';
import '/View/screens/edit_education.dart';
import '/View/screens/edit_main_info.dart';
import '/View/screens/edit_payment.dart';
import '/ViewModel/cubits/edit_info_cubit/edit_info_cubit.dart';

import '../../color_const.dart';
import '../components/core/buttons.dart';

class EditInfoScreen extends StatelessWidget {
  const EditInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditInfoCubit, EditInfoState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w,0, 24.w,0),
          child: Column(
            children: [
              SignInAppBar(text: "Edit personal info", size: 24.sp, progress: 0,showProgressBar: false,),
              DefaultTabController(length: 3, child: Column(
                children: [
                  Container(
                    child: TabBar(
              indicatorColor: secondary,
                physics: BouncingScrollPhysics(),
              //  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                indicatorPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                indicatorWeight: 3,
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      // Use the default focused overlay color
                      return states.contains(MaterialState.focused)
                          ? null
                          : Colors.transparent;
                    }),

                indicator:const UnderlineTabIndicator(
                  // borderRadius: BorderRadius.circular(15.sp),
                  borderSide: BorderSide(color: secondary,width: 2),
                ),
                tabs: [
                  Tab(
                    child: Text(
                      "Main info",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Education",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Payment ",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                  )
                  ),
                  SizedBox(height: 20.h,),
                  Container(
                    height: 400.h,
                    child: TabBarView(
                      children: [
                        EditMainInfoScreen(),
                        EditEducationScreen(),
                        EditPaymentScreen()
                      ],
                    ),
                  )
                ],

              ))

            ],

          )
        ),
      ),
     /* floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(24.w , 0, 24.w, 0),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(text: 'Save Changes', onTap: () {
                // cubit.editData(graduation_year: UserModel.getGraduationYear(), faculty: UserModel.getFaculty(), email: UserModel.getEmail(), account_name: UserModel.getAccountName(), account_number: UserModel.getAccountNumber().toString(), bank_name: UserModel.getBankName(), area: UserModel.getArea(), city: UserModel.getCity());
              }),
            ],
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/

    );
  },
);
  }
}