import 'package:flutter/material.dart';

class AppFont {
  static TextStyle bold(){ //ini buat Tebel Judul Gul
    return const TextStyle(
      fontFamily: 'Poppins',
      fontWeight: .bold
    );
  }

  static TextStyle semibold(){
    return const TextStyle( //ini semibold gul, judul ke 2
      fontWeight: .w600,
      fontFamily: 'Poppins'
    );
  }
  static TextStyle medium(){
    return const TextStyle( //medium, judul ke 3
      fontWeight: .w500,
      fontFamily: 'Poppins'
    );
  }
  static TextStyle regular(){
    return const TextStyle( //normalnya teks tipis
      fontFamily: 'Poppins',
      fontWeight: .w400,
    );
  }
}