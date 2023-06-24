import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';

class file_convert_screen extends StatefulWidget {
  const file_convert_screen({Key? key});

  @override
  State<file_convert_screen> createState() => _file_convert_screen_State();
}

class _file_convert_screen_State extends State<file_convert_screen> {
  bool isFileConverted = false; // Track if the file conversion is completed

  Future<void> simulateFileConversion() async {
    // Simulate the file conversion process
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isFileConverted = true;
    });
    showCompletionDialog();
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('동영상 전환이 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/7');
              },
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(
              //     const Color(0xff0165E1),
              //   ),
              // ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    simulateFileConversion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/loading_3.gif"),
            SizedBox(height: 20),
            Text(
              '진행 중 ...',
              style: TextStyle(
                color: Color.fromARGB(255, 65, 64, 64),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/7');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xff0165E1),
                ),
              ),
              child: const Text('임시 버튼 .. download'),
            )
          ],
        ),
      ),
    );
  }
}
