import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ai_mosaic_project/screen/token.dart';

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
      setState(() {
        selectedImage = image;
        registrantName = name;
      });

      print('이미지: $selectedImage');
      print('이름: $registrantName');
    }

    sendImageAndName(selectedImage!, registrantName!);

  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final name = await getRegistrantName();

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() {
        selectedImage = image;
        registrantName = name;
      });

      print('이미지: $selectedImage');
      print('이름: $registrantName');
    }

    sendImageAndName(selectedImage!, registrantName!);

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

  Future<void> sendImageAndName(File image, String name) async {
    var uri = Uri.parse('http://15.164.136.78:8080/registrant/save');
    var request = http.MultipartRequest('POST', uri);

    final authToken = await MyTokenManager.getToken();

    request.files.add(await http.MultipartFile.fromPath('image', image.path)); // InFo 묶는 순서 맞는지 서버랑 확인 
    request.fields['name'] = name;
    request.headers['authToken'] = authToken!;

    var response = await request.send();
    if (response.statusCode == 200) {
      print('SENDING REGISTRANT INFO SUCCESS');
    } else {
      print('SENDING REGISTRANT INFO FAILED');
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
