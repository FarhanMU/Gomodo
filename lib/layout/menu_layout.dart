import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gomodo_mobile/page/dashboard_1.dart';
import 'package:gomodo_mobile/page/productList_1.dart';
import 'package:gomodo_mobile/page/profile_1.dart';
import 'package:gomodo_mobile/page/transactionList_1.dart';
import 'package:gomodo_mobile/untilities/theme.dart';

Widget menu_layout(BuildContext context, String navActive) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(24, 0, 0, 0),
            spreadRadius: 0.1,
            blurRadius: 3,
            offset: Offset(0, 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => transactionList_1()),
                  (Route<dynamic> route) => false);
            },
            child: Column(
              children: [
                Image.asset(
                  navActive == 'Transaction'
                      ? 'assets/images/Menu/1_1.png'
                      : 'assets/images/Menu/1.png',
                  width: 20,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Transaction",
                  style: navActive == 'Transaction'
                      ? TextStyleMontserratW500Blue2_13
                      : TextStyleMontserratW500Blue2_13,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => productList_1()),
                  (Route<dynamic> route) => false);
            },
            child: Column(
              children: [
                Image.asset(
                  navActive == 'Product'
                      ? 'assets/images/Menu/2_1.png'
                      : 'assets/images/Menu/2.png',
                  width: 20,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Product",
                  style: navActive == 'Product'
                      ? TextStyleMontserratW500Blue2_13
                      : TextStyleMontserratW500Blue2_13,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => dashboard_1()),
                  (Route<dynamic> route) => false);
            },
            child: Column(
              children: [
                Image.asset(
                  navActive == 'Home'
                      ? 'assets/images/Menu/3_1.png'
                      : 'assets/images/Menu/3.png',
                  width: 20,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Home",
                  style: navActive == 'Home'
                      ? TextStyleMontserratW500Blue2_13
                      : TextStyleMontserratW500Blue2_13,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => profile_1(null)));
            },
            child: Column(
              children: [
                Image.asset(
                  navActive == 'Profile'
                      ? 'assets/images/Menu/4_1.png'
                      : 'assets/images/Menu/4.png',
                  width: 20,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Profile",
                  style: navActive == 'Profile'
                      ? TextStyleMontserratW500Blue2_13
                      : TextStyleMontserratW500Blue2_13,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
