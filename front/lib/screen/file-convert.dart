import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';

class file_convert_screen extends StatefulWidget {
  const file_convert_screen({super.key});

  @override
  State<file_convert_screen> createState() => _file_convert_screen_State();
}

class _file_convert_screen_State extends State<file_convert_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/loading_3.gif"),
            Text(
              '진행 중 ...',
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