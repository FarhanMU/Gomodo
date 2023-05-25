import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gomodo_mobile/untilities/theme.dart';

Widget header_layout(String Title) {
  return Row(
    children: [
      Icon(
        Icons.arrow_back_rounded,
        color: defaultBlue2Color,
        size: 30,
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        Title,
        style: TextStyleMontserratW600Blue2_24,
      ),
    ],
  );
}
