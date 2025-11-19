//main.dart
import 'package:bmi_pickerview_app/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'package:프로젝트명/home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Main',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      debugShowCheckedModeBanner: false, // 우측 상단 디버그 배너 제거
      initialRoute: '/',
      // 기존 라우트
			// routes: {
			//   '/' : (context) => TableList(),
			//   '/Inseet' : (context) {
			//     return InsertList();
			//   },
			// },
      getPages: [
        GetPage(name: '/', page: () => Home()),
    
      ],
    );
  }
}