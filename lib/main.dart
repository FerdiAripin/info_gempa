import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'page/page_home.dart';

void main() {
  Intl.defaultLocale = 'in';
  initializeDateFormatting('in', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Info Gempa',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue), // Ganti warna
        useMaterial3: true, // Aktifkan Material 3 untuk tampilan lebih modern
        fontFamily: 'Poppins', // Pastikan font Poppins digunakan
      ),
      home: const HomePage(),
    );
  }
}
