import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/color_const.dart';
import 'dart:ui';

class DefaultTextField extends StatefulWidget {
  String hintText = "";
  GlobalKey<FormState> formKey;
  TextEditingController controller;
  final Function(String val) onchange;
  String? Function(String?)? validate;
  final Function()? onTap;
  bool isSecure;
  bool keyboardTypeIsNumber = false;
  bool? errorBorder = false;

  DefaultTextField({
    this.keyboardTypeIsNumber = false,
    this.onTap,
    this.isSecure = false,
    required this.onchange,
    required this.controller,
    required this.formKey,
    required this.hintText,
    this.validate,
    this.errorBorder,
  });

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: focusNode.hasFocus
          ? BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
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
      duration: const Duration(milliseconds: 5),
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          keyboardType: (widget.keyboardTypeIsNumber)
              ? TextInputType.number
              : TextInputType.text,
          obscureText: widget.isSecure,
          focusNode: focusNode,
          controller: widget.controller,
          onChanged: widget.onchange,
          onTap: widget.onTap,
          style: const TextStyle(color: Colors.white, height: 1.5),
          decoration: InputDecoration(
            hintText: widget.hintText,

            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(
                width: 1,
                color: (widget.errorBorder==true)?Colors.red:Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: (widget.errorBorder==true)?Colors.red:secondary),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red),
              borderRadius: BorderRadius.circular(5.sp),
            ),
          ),
          cursorColor: secondary,
          validator: widget.validate,
        ),
      ),
    );
  }
}