import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:ai_mosaic_project/screen/file-upload.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:gallery_saver/gallery_saver.dart';

class file_download_screen extends StatefulWidget {
  const file_download_screen({Key? key}) : super(key: key);

  @override
  file_download_screenState createState() => file_download_screenState();
}

class file_download_screenState extends State<file_download_screen> {

  Future<void> downloadVideo() async {
    var response = await http.get(Uri.parse('http://15.164.136.78:8080/S3/download?fileName=/video/convert/${fileName}')); 

    if (response.statusCode == 200) {
      var appDir = await getExternalStorageDirectory();
      var downloadDir = '${appDir!.path}/Download'; 
      //var downloadDir = '/storage/emulated/0/Downloads/'; 

      // Download 폴더가 없으면 생성
      if (!Directory(downloadDir).existsSync()) {
        Directory(downloadDir).createSync(recursive: true);
      }

      var videoPath = '$downloadDir/${fileName}'; 

      var file = File(videoPath);
      await file.writeAsBytes(response.bodyBytes);

      print('file');
      print('동영상 저장 완료: $videoPath');

    } else {
      print('동영상 다운로드 실패: ${response.reasonPhrase}');
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text('영상을 저장하시겠습니까?'),
                      actions: [
                        TextButton(
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('확인'),
                          onPressed: () {
                            print('VIDEO DOWNLOADING ....');
                            Navigator.of(context).pop();
                            downloadVideo(); // S3에서 동영상 다운로드 호출
                            print('ALL PROCESS COMPLETED');
                            Navigator.pushNamed(context, '/2');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.all(30.0),
                padding: const EdgeInsets.all(70.0),
                color: Color.fromRGBO(205, 236, 250, 1),
                child: Icon(
                  Icons.file_download,
                  size: 80,
                  color: Color.fromARGB(255, 150, 150, 150),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${fileName}',
              style: TextStyle(
                color: Color.fromARGB(255, 65, 64, 64),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
