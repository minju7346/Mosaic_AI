import 'package:ai_mosaic_project/main.dart';
import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/login.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget { //공통 앱 바 
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppBar(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0))),
          backgroundColor: Colors.blue,
          elevation: 0.3,
          title: Text("${userAccount[2]} 님,", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          leading: IconButton( //메뉴 
              onPressed: () {}, 
              icon: const Icon(Icons.menu)
            ),
          actions: [
            IconButton( //로그인 정보
            onPressed: () {
              Navigator.pushNamed(context, '/2');
            }, 
            icon: const Icon(Icons.home)
          ),
          ],
        ),
      ]
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(60);
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // children: [
          //   UserAccountsDrawerHeader(
          //     currentAccountPicture: CircleAvatar(
          //       backgroundImage: AssetImage('assets/image/kakao_login.jpg'),
          //     ),
          //     otherAccountsPictures: [
          //       CircleAvatar(
          //         backgroundImage: AssetImage('assets/image/kakao_login.jpg'),
          //       ),
          //     ],
          //     accountName: Text('화니네'),
          //     accountEmail: Text('abc12356@naver.com'),
          //     onDetailsPressed: () {},
          //     decoration: BoxDecoration(
          //       color: Colors.purple[200],
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(10.0),
          //         bottomRight: Radius.circular(10.0),
          //       ),
          //     ),
          //   ),
          //   ListTile(
          //     leading: Icon(Icons.home),
          //     iconColor: Colors.purple,
          //     focusColor: Colors.purple,
          //     title: Text('홈'),
          //     onTap: () {},
          //     trailing: Icon(Icons.navigate_next),
          //   ),
          // ],
        ),
      );
  }
}

class home_screen extends StatelessWidget {
  const home_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(), //구현 중 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 150,
              child: TextButton( //저장한 사람 리스트 - regi-list로 이동
                onPressed: () {
                    Navigator.pushNamed(context, '/3');
                  },
                child: Text(
                  'FACE LIST',
                   style: TextStyle(
                    color: Color.fromARGB(255, 59, 59, 59), 
                    fontSize: 25, 
                    fontWeight: FontWeight.w600
                  )
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(205, 236, 250, 1),
                  
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 250,
              height: 150,
              child: TextButton( //모자이크 적용할 파일 업로드 
                onPressed: () {
                    Navigator.pushNamed(context, '/5');
                  },
                child: Text(
                  'FACE UPLOAD',
                   style: TextStyle(
                    color: Color.fromARGB(255, 59, 59, 59), 
                    fontSize: 25, 
                    fontWeight: FontWeight.w600
                  )
                ),                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(205, 236, 250, 1),
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}