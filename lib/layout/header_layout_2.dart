import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gomodo_mobile/untilities/theme.dart';

Widget header_layout_2(String Title) {
  return Row(
    children: [
      Icon(
        Icons.arrow_back_rounded,
        color: whiteColor,
        size: 30,
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        Title,
        style: TextStyleMontserratW600White_24,
      ),
    ],
  );
}
