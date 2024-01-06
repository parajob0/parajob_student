import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/color_const.dart';
import 'dart:ui';

class MultiLineTextField extends StatefulWidget {
  String hintText = "";
  GlobalKey<FormState> formKey;
  TextEditingController controller;
  final Function(String val) onchange;
  String? Function(String?)? validate;
  final Function()? onTap;
  bool? errorBorder = false;

  MultiLineTextField({
    this.onTap,
    required this.onchange,
    required this.controller,
    required this.formKey,
    required this.hintText,
    this.validate,
    this.errorBorder,
  });

  @override
  State<MultiLineTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<MultiLineTextField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // print("********************");
    // print(widget.errorBorder);
    // print("********************");
    return AnimatedContainer(
      decoration: focusNode.hasFocus
          ? BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: primary,
        boxShadow: (widget.errorBorder == false)
            ? [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(0, 0),
          )
        ]
            : [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 0,
            offset: Offset(0, 0),
          )
        ],
      )
          : null,
      duration: Duration(milliseconds: 5),
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 10,
          focusNode: focusNode,
          controller: widget.controller,
          onChanged: widget.onchange,
          onTap: widget.onTap,
          style: TextStyle(color: Colors.white,fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: secondary),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
              borderRadius: BorderRadius.circular(10.sp),
            ),
          ),
          cursorColor: secondary,
          validator: widget.validate,
        ),
      ),
    );
  }
}


