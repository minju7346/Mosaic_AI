import 'package:flutter/material.dart';
import 'package:ai_mosaic_project/screen/home.dart';
import 'package:ai_mosaic_project/screen/regi-add.dart';

late List<String> registrant = []; //등록인 정보 받아오는 리스트 

class regi_tile extends StatelessWidget { //등록인 리스트 타일 
  
  final int index;

  const regi_tile(
    this.index,
  );

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
          "${registrant[index]}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)
        )
      ),
    );
  }
}


class regi_list_screen extends StatefulWidget {
  const regi_list_screen({super.key});

  @override
  State<regi_list_screen> createState() => _regi_list_screenState();
}

class _regi_list_screenState extends State<regi_list_screen> {
  
  // late List<String> registrant = []; //등록인 정보 받아오는 리스트 

  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //registrant = ["a", "b", "c", "a", "b", "c", "a", "b", "c"];
    registrant = [];

    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Scrollbar(
          child: registrant.isNotEmpty
            ? ListView.builder(
                itemCount: registrant.length,
                itemBuilder: (context, index) {
                  return regi_tile(index);
                  // return Container( //등록인 Tile 만들어야 함 
                  //   height: 100,
                  //   child: Text(registrant[index]),
                  // );
                },
              )
            : const Center(
              child: Text(
                '등록된 사람이 없습니다',
                style: TextStyle(
                color: Color.fromARGB(255, 65, 64, 64), 
                fontSize: 18, 
                fontWeight: FontWeight.w500
              ),
              )
            ),
        )
      ),
      bottomNavigationBar: Container( //하단에 등록인 추가 버튼 고정
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