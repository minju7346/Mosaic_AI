import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:aws_s3_api/s3-2006-03-01.dart';

class FileDownloadScreen extends StatefulWidget {
  const FileDownloadScreen({Key? key}) : super(key: key);

  @override
  _FileDownloadScreenState createState() => _FileDownloadScreenState();
}

class _FileDownloadScreenState extends State<FileDownloadScreen> {
  final String bucketName = 'YOUR_S3_BUCKET_NAME';
  final String objectKey = 'YOUR_OBJECT_KEY'; // 다운로드할 동영상의 객체 키

  Future<void> downloadVideoFromS3() async {
    try {
      // S3 클라이언트 초기화
      // final s3 = AwsS3Api(
      //   region: 'YOUR_AWS_REGION',
      //   accessKey: 'YOUR_ACCESS_KEY',
      //   secretKey: 'YOUR_SECRET_KEY',
      // );

      // 동영상 다운로드
      // final downloadResponse = await s3.getObject(
      //   bucket: bucketName,
      //   key: objectKey,
      // );

      // 다운로드한 동영상 데이터를 처리하는 코드 작성
      // downloadResponse.bodyBytes에 다운로드한 데이터가 포함됩니다.

      print('VIDEO DOWNLOAD COMPLETED');
    } catch (e) {
      print('VIDEO DOWNLOAD FAILED: $e');
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
                            downloadVideoFromS3(); // S3에서 동영상 다운로드 호출
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
              '<서버에서 받은 동영상 이름 .....>',
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
