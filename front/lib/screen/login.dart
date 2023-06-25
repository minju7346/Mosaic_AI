import 'dart:convert';
import 'dart:io';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:ai_mosaic_project/screen/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ai_mosaic_project/screen/login_platform.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
//import 'package:fluttertoast/fluttertoast.dart';

//로그인 정보 - id(0), email(1), name(2)
List<String> userAccount = ['id', 'email', 'name']; 

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  @override
  void initState() {
    super.initState();
  }

    void signInWithKakao() async { 
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

        String id = profileInfo['id'].toString();
        String email = profileInfo['kakao_account']['email'].toString();
        //String name = profileInfo['kakao_account']['profile']['nickname'].toString();
        
        String nickname = ''; //nickname을 가져오지 못할 경우 공백으로 둠
        if (profileInfo['kakao_account'] != null &&
            profileInfo['kakao_account']['profile'] != null &&
            profileInfo['kakao_account']['profile']['nickname'] != null) {
          nickname = profileInfo['kakao_account']['profile']['nickname'].toString();
        }

        userAccount[0] = id;
        userAccount[1] = email;
        userAccount[2] = nickname;

        setState(() {
          _loginPlatform = LoginPlatform.kakao;
        });

        final payload = {
          'id': id,
          'email': email,
          'name': nickname,
        };

        final response1 = await http.post(
          Uri.parse('http://15.164.136.78:8080/login/naver'),
          body: json.encode(payload),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response1.statusCode == 200) {
          final authToken = response1.body;

          MyTokenManager.saveToken(token.accessToken);
          print('sending success');
          print('Kakao authToken: $authToken');

        } else {
          print('sending failed');
          print(response1.statusCode);
        }
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

      userAccount[0] = googleUser.id;
      userAccount[1] = googleUser.email;
      userAccount[2] = googleUser.displayName.toString();

      final payload = {
        'id': googleUser.id,
        'email': googleUser.email,
        'name': googleUser.displayName,
      };

      final response = await http.post(
        Uri.parse('http://15.164.136.78:8080/login/google'),
        body: json.encode(payload),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Login successful
        final authToken = response.body;
        print('Google authToken: $authToken');

        MyTokenManager.saveToken(authToken);
        print('sending success');
        print(authToken);
      } else {
        // Login failed
        print('sending failed');
        print(response.statusCode);
      }
    }
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

      userAccount[0] = result.account.id;
      userAccount[1] = result.account.email;
      userAccount[2] = result.account.name;

      final payload = {
        'id': result.account.id,
        'email': result.account.email,
        'name': result.account.name,
      };

      final response = await http.post(
        Uri.parse('http://15.164.136.78:8080/login/naver'),
        body: json.encode(payload),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Handle the server response
      if (response.statusCode == 200) {
        // Login successful
        final authToken = response.body;

        MyTokenManager.saveToken(authToken);
        print('sending success');
        print('Naver authToken: $authToken');

        //print(authToken);
        // Handle the authentication token or success message
      } else {
        // Login failed
        // Handle the error case (e.g., display an error message)
        print('sending failed');
        print(response.statusCode);
      }


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

    print('Successfully LOGOUT');

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
              ? home_screen() //추후 수정
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon( //Our Application logo
                  //   Icons.person, 
                  //   color: Colors.blue,
                  //   size: 120,
                  // ),
                  // Text(
                  //   'LOGIN',
                  //   style: TextStyle(
                  //     color: Color.fromARGB(255, 65, 64, 64),
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  Image.asset('assets/image/logo.png', width: 150, height: 150),
                  SizedBox(height: 120),
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
                  ),
                  SizedBox(height: 20),
                  _logoutButton()
                ],
              )),
    );
  }

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