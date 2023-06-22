import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/regi-list.dart';

class regi_add_screen extends StatelessWidget {
  const regi_add_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text('타이머... 카메라... 파일 mp4로 저장... 서버로 전송...'),
      ),
    );
  }
}