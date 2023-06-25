import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ai_mosaic_project/screen/token.dart';

File? selectedVideo;
String? videoName;
String fileName = "";

class file_upload_screen extends StatefulWidget {
  const file_upload_screen({super.key});

  @override
  State<file_upload_screen> createState() => _file_upload_screenState();
}

class _file_upload_screenState extends State<file_upload_screen> {
  final picker = ImagePicker();
  // File? selectedVideo;
  // String? videoName;

  Future<void> getVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    await _showNameDialog();

    if (pickedFile != null) {
      final video = File(pickedFile.path);

      // 이미지 파일명 변경
      fileName = '$videoName.mp4';
      final renamedVideo = await video.rename(video.parent.path + '/' + fileName);


      setState(() {
        selectedVideo = renamedVideo;
      });

      print('Video: $selectedVideo');

    }

    // await _showNameDialog();
    // if (videoName != null && selectedVideo != null) {
    //   sendVideo(selectedVideo!, videoName!);
    // }
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
                setState(() {
                  videoName = _textEditingController.text;
                });

                //videoName = _textEditingController.text;
                Navigator.of(context).pop();
                //Navigator.pushNamed(context, '/6');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendVideo(File video, String name) async {
    try {
      final authToken = await MyTokenManager.getToken();
      final url = Uri.parse('http://15.164.136.78:8080/S3/upload-video');
      

      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = authToken!;
      request.files.add(await http.MultipartFile.fromPath('file', video.path));
      //request.fields['name'] = name;s

      print('영상 전송 중 ...');

      final response = await request.send();
      if (response.statusCode == 200) {
        print('SENDING VIDEO SUCCESS');
      } else {
        print('SENDING VIDEO FAILED: ${response.statusCode}');
      }

      print('SENDING SESSION IS OVER');
    } catch (error) {
      print('비디오 전송 실패: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: (videoName != null && selectedVideo != null)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Video Thumbnail
                Icon(Icons.check, size: 80),
                SizedBox(height: 20),
                Text(
                  '$videoName.mp4',
                  style: TextStyle(
                      color: Color.fromARGB(255, 65, 64, 64), 
                      fontSize: 18, 
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getVideoFromGallery();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff0165E1),
                        ),
                      ),
                      child: const Text('재설정'),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        sendVideo(selectedVideo!, videoName!);
                        Navigator.pushNamed(context, '/6');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff0165E1),
                        ),
                      ),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ],
            )
          : Column(
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