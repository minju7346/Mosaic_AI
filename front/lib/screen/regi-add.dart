import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ai_mosaic_project/screen/token.dart';
import 'dart:convert';

class regi_add_screen extends StatefulWidget {
  const regi_add_screen({Key? key}) : super(key: key);

  @override
  State<regi_add_screen> createState() => _regi_add_screenState();
}

class _regi_add_screenState extends State<regi_add_screen> {
  final picker = ImagePicker();
  File? selectedImage;
  String? registrantName;

  void initState() {
    super.initState();
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final name = await getRegistrantName();

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      
      // 이미지 파일명 변경
      String fileName = '$name.jpg';
      final renamedImage = await image.rename(image.parent.path + '/' + fileName);

      setState(() {
        selectedImage = renamedImage;
        registrantName = name;
      });

      print('이미지: $selectedImage');
      print('이름: $registrantName');
    }

    //sendImageAndName(selectedImage!, registrantName!);
    sendImage(selectedImage!);
    sendName(registrantName!);

  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final name = await getRegistrantName();

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      
      // 이미지 파일명 변경
      String fileName = '$name.jpg';
      final renamedImage = await image.rename(image.parent.path + '/' + fileName);

      setState(() {
        selectedImage = renamedImage;
        registrantName = name;
      });

      print('이미지: $selectedImage');
      print('이름: $registrantName');
    }

    //sendImageAndName(selectedImage!, registrantName!);
    sendImage(selectedImage!);
    sendName(registrantName!);

  }

  Future<String?> getRegistrantName() async {
    TextEditingController _textEditingController = TextEditingController();
    String? name;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('이름을 입력하세요'),
          content: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(hintText: '이름'),
          ),
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
                name = _textEditingController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return name;
  }

  Future<void> sendImage(File image) async {

    final authToken = await MyTokenManager.getToken();
    var imageURI = Uri.parse('http://15.164.136.78:8080/S3/upload-image');

    try {
      var imageRequest = http.MultipartRequest('POST', imageURI);
      imageRequest.headers['Authorization'] = authToken!;
      imageRequest.files.add(await http.MultipartFile.fromPath('file', image.path));
    

      var imageResponse = await imageRequest.send();
      print('Sending registrant image ...');

      if (imageResponse.statusCode == 200) {
        print('SENDING IMAGE SUCCESS');
      } else {
        print('SENDING IMAGE FAILED: ${imageResponse.statusCode}');
      }
    } catch (error) {
      print('Failed to send image: $error');
    }

  }

  Future<void> sendName(String name) async { //등록인 이름 - 서버 전송
    final authToken = await MyTokenManager.getToken();

    final nameUrl = Uri.parse('http://15.164.136.78:8080/registrant/save');
    final namePayload = {'name': name, 'file_name' : '$name.jpg'};
    final nameJson = json.encode(namePayload);

    try {
      final nameResponse = await http.post(
        nameUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authToken!,
        },
        body: nameJson,
      );
      print('Sending registrant name ...');
      if (nameResponse.statusCode == 200) {
        print('SENDING NAME SUCCESS');
      } else {
        print('SENDING NAME FAILED: ${nameResponse.statusCode}');
      }
    } catch (error) {
      print('Failed to send name: $error');
    }
  }


// Future<void> sendImageAndName(File image, String name) async {
//   // 등록인의 이름은 registrant/save
//   // 등록인의 이미지 파일은 s3/upload-image
//   final authToken = await MyTokenManager.getToken();

//   final s3UploadUri = Uri.parse('http://15.164.136.78:8080/s3/upload-image'); //이미지 파일
//   final s3Request = http.MultipartRequest('POST', s3UploadUri);

//   String fileName = '$name.jpg';
//   s3Request.files.add(await http.MultipartFile.fromPath('image', image.path, filename: fileName));
//   s3Request.headers['authToken'] = authToken!;

//   try {
//     final s3Response = await s3Request.send();
//     print('sending registrant image ...');
//     if (s3Response.statusCode == 200) {
//       print('UPLOADING IMAGE SUCCESS');
//     } else {
//       print('UPLOADING IMAGE FAILED');
//     }
//   } catch (error) {
//     print('Failed to upload image: $error');
//   }

//   final nameUri = Uri.parse('http://15.164.136.78:8080/registrant/save'); //이름
//   final nameRequest = http.MultipartRequest('POST', nameUri);
//   nameRequest.fields['name'] = name;
//   nameRequest.headers['authToken'] = authToken;

//   print('서버 연결 중...');
  
//   try {
//     final nameResponse = await nameRequest.send();
//     print('sending registrant name ...');
//     if (nameResponse.statusCode == 200) {
//       print('SENDING NAME SUCCESS');
//     } else {
//       print('SENDING NAME FAILED');
//     }
//   } catch (error) {
//     print('Failed to send name: $error');
//   }


// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 150),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('사진 등록'),
                      content: Text('업로드 방법을 선택해주세요'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            getImageFromCamera();
                          },
                          child: Text('카메라'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            getImageFromGallery();
                          },
                          child: Text('갤러리'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: selectedImage != null 
                ? SizedBox(child: Image.file(selectedImage!), width: 200, height: 200)
                : Container(
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(70.0),
                  //width: 200,
                  //height: 200,
                  color: Color.fromRGBO(205, 236, 250, 1),
                  child: Icon(
                          Icons.add_a_photo,
                          size: 80,
                          color: Color.fromARGB(255, 150, 150, 150),
                        ),
                ),
            ),
            registrantName != null
                ? Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                        '등록이 완료되었습니다: $registrantName',
                        style: TextStyle(
                          color: Color.fromARGB(255, 59, 59, 59),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff0165E1),
                        ),
                      ),
                      child: const Text('돌아가기'),
                    )
                  ],
                )
                : Text(
                    '새로운 사용자를 등록해주세요',
                    //'VItVbbNgm+Vdv7qVIotfRfPH+SkrBq+tfdSIh6CD',
                    style: TextStyle(
                      color: Color.fromARGB(255, 59, 59, 59),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
      
          ],
        ),
      ),
    );
  }
}





