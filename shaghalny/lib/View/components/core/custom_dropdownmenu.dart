import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../color_const.dart';


class CustomDropDownMenuButton extends StatelessWidget {
  List<String> list;
  String? value;
  void Function(String?)? onchange;
  Widget? hintText;
  String? Function(String?)? validate;
  GlobalKey<FormState> formKey;

  CustomDropDownMenuButton({ required this.formKey,required this.list, this.hintText,required this.value,required this.onchange,  this.validate,Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: DropdownButtonFormField2(
        decoration: InputDecoration(


          fillColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1,color: secondary),
              borderRadius: BorderRadius.circular(10.sp)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1,color: Colors.white),
              borderRadius: BorderRadius.circular(10.sp)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          iconColor: Colors.white,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
        ),


        isExpanded: false,
        hint: hintText,
        value: value,
        items: list.map((String value) =>
            DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ))
            .toList(),
        onChanged: onchange,
validator: validate,

        buttonStyleData:  ButtonStyleData(
          height: 48.h,
          padding: EdgeInsets.only( right: 10.w),
        ),

        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up,color: secondary,),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          iconSize: 30,
        ),

        dropdownStyleData: DropdownStyleData(
          maxHeight: 200.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: primary,
              boxShadow: [
                BoxShadow(
                  color: secondary,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                )

              ]

          ),
        ),
      ),
    );
  }


}




