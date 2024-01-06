import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaghalny/ViewModel/cubits/jobs_cubit/jobs_cubit.dart';
import '/View/screens/edit_personal_info.dart';
import '/View/screens/submit_review.dart';
import '/color_const.dart';

import '../../ViewModel/cubits/bank_information_cubit/bank_information_cubit.dart';
import '../../ViewModel/cubits/preference_cubit/preference_cubit.dart';
import '../components/core/buttons.dart';
import '../components/core/custom_text.dart';
import '../components/core/sign_in_appBar.dart';
import '../components/core/skip_button.dart';
import '../components/core/text_field.dart';
import 'approval_screen.dart';
import 'bottom_navigation_screen.dart';

class BankInformation extends StatelessWidget {
  BankInformation({Key? key}) : super(key: key);

  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();

  static  GlobalKey<FormState> accountNameKey = GlobalKey<FormState>();
  static GlobalKey<FormState> accountNumberKey = GlobalKey<FormState>();
  static GlobalKey<FormState> bankNameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    BankInformationCubit bankInfoCubit = BlocProvider.of<BankInformationCubit>(context, listen: true);
    PreferenceCubit preferenceCubit = BlocProvider.of<PreferenceCubit>(context, listen: true);
    JobsCubit jobsCubit = JobsCubit.get(context);
    print(preferenceCubit.userModel!.id);

    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignInAppBar(text: 'Bank Information', size: 24.sp, progress: 80, subText: 'Time to verify your payment details'),
              BlocConsumer<BankInformationCubit, BankInformationState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return DefaultTextField(hintText: "Enter your account's owner name",
                      onchange: (String val) {
                        debugPrint("\n\naccount name -->  $val\n\n");
                      }, controller: accountName, formKey: accountNameKey,
                      validate: (value){
                        if(value == null||value.isEmpty){
                          return 'account owner name is required';}
                        else{return null;}});
                },
              ),

              SizedBox(height: 16.h),

              DefaultTextField(hintText: "Enter your account's number",
                onchange: (String val) {
                  debugPrint("\n\naccount number -->  $val\n\n");
                },
                controller: accountNumber,
                formKey: accountNumberKey,
                validate: (val){
                  if(val!.length <= 0){
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Number must be 16 digits')));

                    return 'Please enter a valid account number';
                  }else{
                    return null;
                  }
                },
                errorBorder: bankInfoCubit.bankNumberErrorBorder,
              ),

              SizedBox(height: 16.h),

              DefaultTextField(hintText: "Enter your banks's name",
                  onchange: (String val) {
                    debugPrint("\n\nbank name -->  $val\n\n");
                  }, controller: bankName, formKey: bankNameKey,
                  validate: (value){
                    if(value == null||value.isEmpty){
                      return 'your bank name is required';}
                    else{return null;}}),

              SizedBox(height: 16.h),

              SizedBox(height: 170.h),
              PrimaryButton(text: 'Finish', onTap: ()async{

                  bool bankNumber = accountNumberKey.currentState!.validate();

                  if (bankNumber) {
                    bankInfoCubit.accountNumberErrorMessage(false);
                  }
                  else {
                    bankInfoCubit.accountNumberErrorMessage(true);
                  }

                  if (bankNumber&&accountNameKey.currentState!.validate()&&bankNameKey.currentState!.validate()) {
                     bankInfoCubit.uploadBankInfo(
                        preferenceCubit,
                        accountName: accountName.text,
                        accountNumber: int.parse(accountNumber.text),
                        bankName: bankName.text);

                    bankInfoCubit.addBankData(
                        preferenceCubit, accountName: accountName.text,
                        accountNumber: accountNumber.text,
                        bankName: bankName.text);
                    print(preferenceCubit.userModel!.accountName);
                    print(preferenceCubit.userModel!.accountNumber);
                    print(preferenceCubit.userModel!.bankName);

                    debugPrint("\n\n\n bank number --> $bankNumber \n\n\n");
                    String? uid = preferenceCubit.userModel?.id;
                    await preferenceCubit.getUser(id: uid??"");
                    await jobsCubit.fillJobs(preferenceCubit, context).then((value) {

                      (preferenceCubit.userModel!.isApproved) ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation(index: 0,))):
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ApprovalScreen()));
                    });
                  }

              }),

              SizedBox(height: 16.h),
              const SkipButton(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}