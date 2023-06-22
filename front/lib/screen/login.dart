import 'dart:convert';
import 'dart:io';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:ai_mosaic_project/screen/login_platform.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';


List<String> userAccount = ['id', 'email', 'name']; //로그인 정보 - id(0), email(1), name(2)

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;


  void signInWithKakao() async { //안됨 썅
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });

      // userAccount[0] = googleUser.id;
      // userAccount[1] = googleUser.email;
      // userAccount[2] = googleUser.displayName.toString();
      
      // print("${userAccount[0]}");
      // print("${userAccount[1]}");
      //print("${userAccount[2]}");
    }

    //Navigator.pushNamed(context, '/2');
  }

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      setState(() {

        _loginPlatform = LoginPlatform.naver;
      });

      // userAccount[0] = result.account.id;
      // userAccount[1] = result.account.email;
      // userAccount[2] = result.account.name;

      // print("${userAccount[0]}");
      // print("${userAccount[1]}");
      // print("${userAccount[2]}");

    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _loginPlatform != LoginPlatform.none
              //? _logoutButton()
              // ? Scaffold(
              //   appBar: MyAppBar(),
                
              // )
              ? const home_screen()
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon( //Our Application logo
                    Icons.person, 
                    color: Colors.blue,
                    size: 120,
                  ),
                  SizedBox(height: 200),
                  _loginButton(
                    'google_login',
                    signInWithGoogle,
                  ),
                  SizedBox(height: 10),
                  _loginButton(
                    'kakao_login',
                    signInWithKakao,
                  ),
                  SizedBox(height: 10),
                  _loginButton(
                    'naver_login',
                    signInWithNaver,
                  )
                ],
              )),
    );
  }

  // Widget _loginButton(String path, VoidCallback onTap) {
  //   return Card(
  //     elevation: 5.0,
  //     shape: const CircleBorder(),
  //     clipBehavior: Clip.antiAlias,
  //     child: Ink.image(
  //       image: AssetImage('assets/image/$path.png'),
  //       width: 280,
  //       height: 70,
  //       fit: BoxFit.fill,
  //       child: InkWell(
  //         borderRadius: const BorderRadius.all(
  //           Radius.circular(35.0),
  //         ),
  //         onTap: onTap,
  //       ),
  //     ),
  //   );
  // }

  Widget _loginButton(String path, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset('assets/image/$path.png', width: 200, height: 50,),

    );   
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }

}