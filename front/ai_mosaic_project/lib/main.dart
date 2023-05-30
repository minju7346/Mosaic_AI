import 'package:flutter/material.dart';
import 'screen/login_screen.dart';
//import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_naver_login/flutter_naver_login.dart';

void main () {
  //KakaoContext.clientId = "9339b50a9606cf0e22f8d3b981254d96";
  KakaoSdk.init(nativeAppKey: '9339b50a9606cf0e22f8d3b981254d96');
  //initSdk()
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: { //Write Page with route 
        // '/' :(context) => main(),
        '/1' :(context) => const login_screen(),
        // '/c' :(context) => Screen3()
      },
      debugShowCheckedModeBanner: false,
      title: 'aisaic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
                fontSize: 50.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
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
