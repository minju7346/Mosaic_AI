import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ai_mosaic_project/screen/token.dart';

class file_upload_screen extends StatefulWidget {
  const file_upload_screen({super.key});

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

      print('Video: $selectedVideo');

    }
    _showNameDialog();
    sendVideo(selectedVideo!, videoName!);
  
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
              child: Text('확인'),
              onPressed: () {
                videoName = _textEditingController.text;
                //Navigator.of(context).pop();
                Navigator.pushNamed(context, '/6');
              },
            ),
          ],
        );
      },
    );

    // if (videoName != null && videoName!.isNotEmpty) {
    //   setState(() {
    //     // Perform the screen update with the selected video and name
    //   });
    // }
  }

  Future<void> sendVideo(File video, String name) async {
    final url = Uri.parse('http://15.164.136.78:8080/file/upload');
    final authToken = await MyTokenManager.getToken();

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = authToken!;
    request.files.add(await http.MultipartFile.fromPath('video', video.path));
    request.fields['name'] = name;

    final response = await request.send();
    if (response.statusCode == 200) {
      // Video upload successful
      print('SENDING VIDEO SUCCESS');
    } else {
      // Video upload failed
      print('SENDING VIDEO FAILED');
    }

    print('SENDING SESSION IS OVER');
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
              onPressed:() {
                getVideoFromGallery();
                //Navigator.pushNamed(context, '/6');
              }, 
              icon: Icon( 
                Icons.cloud_upload, 
                color: Colors.blue,
                //size: 80,
              ),
              iconSize: 150,
            ),
            SizedBox(height: 20),
            Text(
              '파일을 업로드하세요',
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