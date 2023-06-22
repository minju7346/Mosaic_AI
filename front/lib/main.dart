import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/login.dart';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:ai_mosaic_project/screen/regi-list.dart';
import 'package:ai_mosaic_project/screen/regi-add.dart';
import 'package:ai_mosaic_project/screen/file-upload.dart';
import 'package:ai_mosaic_project/screen/file-convert.dart';



//import 'package:kakao_flutter_sdk/all.dart';
//import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_naver_login/flutter_naver_login.dart';

void main () {
  //KakaoContext.clientId = "9339b50a9606cf0e22f8d3b981254d96";
  KakaoSdk.init(nativeAppKey: '9339b50a9606cf0e22f8d3b981254d96');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: { //Write Page with route 
        //'/' :(context) => WelcomePage(),
        '/1' :(context) => const login_screen(),
        '/2' :(context) => const home_screen(),
        '/3' :(context) => const regi_list_screen(),
        '/4' :(context) => const regi_add_screen(),
        '/5' :(context) => const file_upload_screen(),
        '/6' :(context) => const file_convert_screen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'aisaic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NanumSquareNeo',
      ),
      home: const WelcomePage(), //First page to start
    );
}
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon( //Our Application logo
                Icons.person, 
                color: Colors.blue,
                size: 120,
              ),
              const Text('aisaic',
              style: TextStyle(
                fontSize: 45.0,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),),
              const SizedBox(
                height: 80.0,
              ),
              ElevatedButton( //Change to Timer later 
                onPressed: () {
                  Navigator.pushNamed(context, '/1');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('시작하기', style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                )
        
            ],
          ),
        )
      ),
    );
  }
}
