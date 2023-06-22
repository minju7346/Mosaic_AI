import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';

class file_upload_screen extends StatefulWidget {
  const file_upload_screen({super.key});

  @override
  State<file_upload_screen> createState() => _file_upload_screenState();
}

class _file_upload_screenState extends State<file_upload_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed:() {Navigator.pushNamed(context, '/6');}, 
              icon: Icon( 
                Icons.cloud_upload, 
                color: Colors.blue,
                //size: 80,
              ),
              iconSize: 150,
            ),
            SizedBox(height: 20),
            Text(
              '파일을 업로드하세요... 제발 좀',
              style: TextStyle(
                  color: Color.fromARGB(255, 65, 64, 64), 
                  fontSize: 18, 
                  fontWeight: FontWeight.w600
                ),
            )
          ],
          ),
      )
      );
  }
}