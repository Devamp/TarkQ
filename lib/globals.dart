import 'dart:math';
import 'package:flutter/cupertino.dart';

bool isTablet(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final diagonal = sqrt(size.width * size.width + size.height * size.height);
  return diagonal > 1100;
}
