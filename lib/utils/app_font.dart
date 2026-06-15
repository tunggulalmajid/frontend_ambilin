import 'package:flutter/material.dart';

class AppFont {
  static TextStyle bold() {
    return const TextStyle(fontFamily: 'Poppins', fontWeight: .bold);
  }

  static TextStyle semibold() {
    return const TextStyle(fontWeight: .w600, fontFamily: 'Poppins');
  }

  static TextStyle medium() {
    return const TextStyle(fontWeight: .w500, fontFamily: 'Poppins');
  }

  static TextStyle regular() {
    return const TextStyle(fontFamily: 'Poppins', fontWeight: .w400);
  }
}
