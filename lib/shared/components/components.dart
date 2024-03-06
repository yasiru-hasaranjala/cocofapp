import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget commonButton({
  required Function? function,
  required String text,
  double radius = 5,
  double height = 50,
  double width = double.infinity,
  double fontsize = 25.0,
  double border = 0.0,
  fontWeight,
  Color color = Colors.black,
  Color textcolor = Colors.white,
}) =>
    Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: textcolor,
            width: border,
          )),
      height: height,
      width: width,
      child: MaterialButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: color,
        splashColor: color,
        onPressed: function ?? nullable(),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontsize,
            color: textcolor,
          ),
        ),
      ),
    );

Widget halfButton({
  required Function? function,
  required String text,
  double radius = 7,
  double height = 40,
  double width = double.infinity,
  double fontsize = 20.0,
  double border = 0.0,
  fontWeight,
  Color color = Colors.black,
  Color textcolor = Colors.white,
}) =>
    Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: textcolor,
            width: border,
          )),
      padding: const EdgeInsets.all(0),
      height: height,
      width: width,
      child: MaterialButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        color: color,
        splashColor: color,
        onPressed: function ?? nullable(),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontsize,
            color: textcolor,
          ),
        ),
      ),
    );

Widget iconSocialmedia({
  String url = 'https://cdn0.iconfinder.com/data/icons/shift-free/32/Error-512.png',
  double size = 40,
}) =>
    MaterialButton(
      elevation: 0,
      highlightColor: Colors.white,
      hoverColor: Colors.white,
      shape: const CircleBorder(),
      color: Colors.white,
      onPressed: () {},
      child: Image(
        image: NetworkImage(url),
        color: Colors.white,
        height: size,
        width: size,
      ),
    );

Widget textField({
  required String hinttext,
  required suffixIcon,
  final controller,
  double width = double.infinity,
  bool isPassword = false,
  bool isPasswordVisible = false,
  keyboardType,
  onChange,
}) =>
    SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChange,
        cursorColor: Colors.black,
        validator: (value) {
          if (isPassword & (value!.length < 8)) {
            return 'must be at lest 8 character';
          } else if (value.isEmpty) {
            return 'Cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon: suffixIcon,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          errorStyle: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
          enabledBorder: const OutlineInputBorder(
            // borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(width: 3, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 3.0),
          ),
        ),
        textInputAction: TextInputAction.done,
        obscureText: isPasswordVisible,
      ),
    );


Widget textFieldMini({
  required String hinttext,
  required suffixIcon,
  final controller,
  double width = 150,
  double height = 45,
  bool isPassword = false,
  bool isPasswordVisible = false,
  keyboardType,
  onChange,
  bool isEnabled = true,
  int typeF = 0,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChange,
        cursorHeight: 13,
        cursorColor: Colors.black,
        enabled: isEnabled,
        style: const TextStyle(fontSize: 17.0, color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Cannot be empty';
          }
          else if (typeF != 2 && !RegExp(r'^[0-9]{1,7}$').hasMatch(value)) {
            return 'Should be a Number';
          }
          
          return null;
        },
        decoration: InputDecoration(
          hintText: hinttext,
          focusColor: Colors.black45,
          fillColor: Colors.black12,
          suffixIcon: suffixIcon,
          filled: true,
          hintStyle: const TextStyle(fontSize: 15,color: Colors.black26),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          errorStyle: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.fromLTRB(
              8.0, 5, 5, 6.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 1,color: Colors.white12),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );

nullable() {}

