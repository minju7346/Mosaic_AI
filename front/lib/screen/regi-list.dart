import 'package:ai_mosaic_project/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ai_mosaic_project/screen/token.dart';


List<String> registrant = []; //등록인 리스트 


class regi_tile extends StatelessWidget { //Listtile 
  final String name;

  const regi_tile(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      width: 200,
      height: 60,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 216, 242, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class regi_list_screen extends StatefulWidget {
  const regi_list_screen({Key? key}) : super(key: key);

  @override
  State<regi_list_screen> createState() => _regi_list_screenState();
}

class _regi_list_screenState extends State<regi_list_screen> {

  // List<String> registrant = []; //등록인 리스트 

  @override
  void initState() {
    super.initState();
    getRegistrantList();
  }

  Future<void> getRegistrantList() async { //등록인 리스트 서버에 요청
    
    final authToken = await MyTokenManager.getToken();
    
    try {
      final response = await http.get(
        Uri.parse('http://15.164.136.78:8080/registrant/print'),
        headers: {
          'Content-Type': 'application/json',
          'authToken': authToken!, // authToken 값 추가

        },
      );

      if (response.statusCode == 200) {
        final data = response.body; 

        List<String> registrantList = data.split(','); // 구분자 - 서버에서 보내는 메세지 구조 확인 후 수정 요망
        
        setState(() {
          registrant = registrantList;
        });

        print('GETTING REGISTRANT LIST SUCCESS : $authToken');

      } else {
        print('Failed to get registrant list');
        print(response.statusCode);
      }
    } catch (error) {
      print('Failed to get registrant list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Scrollbar(
          child: registrant.isNotEmpty
              ? ListView.builder( //등록인 리스트 화면에 build
                  itemCount: registrant.length,
                  itemBuilder: (context, index) {
                    return regi_tile(registrant[index]);
                    //return regi_tile(index);
                  },
                )
              : const Center(
                  child: Text(
                    '등록된 사람이 없습니다',
                    style: TextStyle(
                      color: Color.fromARGB(255, 65, 64, 64),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/4');
          },
          icon: Icon(Icons.add_outlined, size: 60),
          color: Colors.blue,
          iconSize: 50,
        ),
        margin: EdgeInsets.only(bottom: 40),
      ),
    );
  }
}
