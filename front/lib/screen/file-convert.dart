import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';

class file_convert_screen extends StatefulWidget {
  const file_convert_screen({Key? key});

  @override
  State<file_convert_screen> createState() => _file_convert_screen_State();
}

class _file_convert_screen_State extends State<file_convert_screen> {
  bool isFileConverted = false; // Track if the file conversion is completed
  Timer? timer;

  @override
  void initState() {
    super.initState();
    simulateFileConversion();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> simulateFileConversion() async {
    // Simulate the file conversion process
    await Future.delayed(Duration(seconds: 4));
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

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      requestFileFromServer();
    });
  }

  void requestFileFromServer() {
    // TODO: Implement your code to request the file from the server
    // This method will be called every 1 second until the file is received
    // You can handle the received file and update the UI accordingly
    // Once the file is received, you can cancel the timer using timer.cancel()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/loading.gif"),
            SizedBox(height: 20),
            Text(
              '진행 중 ...',
              style: TextStyle(
                color: Color.fromARGB(255, 65, 64, 64),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/7');
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(
            //       const Color(0xff0165E1),
            //     ),
            //   ),
            //   child: const Text('임시 버튼 .. download'),
            // )
          ],
        ),
      ),
    );
  }
}
