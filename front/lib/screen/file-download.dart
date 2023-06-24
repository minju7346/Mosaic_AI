import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';

class file_download_screen extends StatefulWidget {
  const file_download_screen({super.key});

  @override
  State<file_download_screen> createState() => _file_download_screenState();
}

class _file_download_screenState extends State<file_download_screen> {
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
                          onPressed: () { //서버에서 받아온 영상 다운로드 
                            print('VIDEO DOWNLOADING ....');
                            Navigator.of(context).pop();
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
                //width: 200,
                //height: 200,
                color: Color.fromRGBO(205, 236, 250, 1),
                child: Icon( //다운로드 완료 후 file_download_done 아이콘 변경 
                        Icons.file_download,
                        size: 80,
                        color: Color.fromARGB(255, 150, 150, 150),
                      ),
              ),
            ),
            SizedBox(height:20),
            Text(
              '<서버에서 받은 동영상 이름 .....>',
              style: TextStyle(
                  color: Color.fromARGB(255, 65, 64, 64), 
                  fontSize: 18, 
                  fontWeight: FontWeight.w600
              ),
            )
          

          ],
        ),
      ),
    );
  }
}

// class file_convert_screen extends StatefulWidget {
//   const file_convert_screen({super.key});

//   @override
//   State<file_convert_screen> createState() => _file_convert_screen_State();
// }

// class _file_convert_screen_State extends State<file_convert_screen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/image/loading_3.gif"),
//             Text(
//               '진행 중 ...',
//               style: TextStyle(
//                   color: Color.fromARGB(255, 65, 64, 64), 
//                   fontSize: 18, 
//                   fontWeight: FontWeight.w600
//                 ),
//             )
//           ],
//           ),
//       )
//       );
//   }
// }