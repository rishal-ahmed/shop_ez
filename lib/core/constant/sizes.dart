import 'package:flutter/material.dart';

//========== Constant Sizes ==========
const kWidth5 = SizedBox(width: 5);
const kWidth10 = SizedBox(width: 10);
const kWidth20 = SizedBox(width: 20);
const kWidth50 = SizedBox(width: 50);

const kHeight5 = SizedBox(height: 5);
const kHeight10 = SizedBox(height: 10);
const kHeight15 = SizedBox(height: 15);
const kHeight20 = SizedBox(height: 20);
const kHeight25 = SizedBox(height: 25);
const kHeight30 = SizedBox(height: 30);
const kHeight50 = SizedBox(height: 50);

//========== Dynamic Sizes ==========
kHeightDynamic({required double kheight}) => SizedBox(height: kheight);
