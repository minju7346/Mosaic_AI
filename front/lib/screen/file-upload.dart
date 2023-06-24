import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class file_upload_screen extends StatefulWidget {
  const file_upload_screen({Key? key}) : super(key: key);

  @override
  State<file_upload_screen> createState() => _file_upload_screenState();
}

class _file_upload_screenState extends State<file_upload_screen> {
  final picker = ImagePicker();
  File? selectedVideo;
  String? videoName;

  Future<void> getVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final video = File(pickedFile.path);
      setState(() {
        selectedVideo = video;
      });

      _showNameDialog();
    }
  }

  Future<void> _showNameDialog() async {
    TextEditingController _textEditingController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('동영상 이름 지정'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: '동영상 이름'),
          ),
          actions: [
            TextButton(
              child: Text('재설정'),
              onPressed: () {
                Navigator.of(context).pop();
                getVideoFromGallery();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                videoName = _textEditingController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (videoName != null && videoName!.isNotEmpty) {
      setState(() {
        // Perform the screen update with the selected video and name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                getVideoFromGallery();
              },
              icon: Icon(
                Icons.cloud_upload,
                color: Colors.blue,
              ),
              iconSize: 150,
            ),
            SizedBox(height: 20),
            if (selectedVideo != null)
              Column(
                children: [
                  // Image.asset(
                  //   "assets/image/sample.gif",
                  //   width: 200,
                  //   height: 200,
                  // ),
                  SizedBox(height: 10),
                  Text(
                    videoName != null
                        ? '$videoName.mp4'
                        : '동영상 이름을 지정해주세요',
                    style: TextStyle(
                      color: Color.fromARGB(255, 65, 64, 64),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedVideo = null;
                            videoName = null;
                          });
                        },
                        child: Text('재설정'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/7');
                        },
                        child: Text('확인'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
