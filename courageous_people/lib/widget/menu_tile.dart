import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({Key? key}) : super(key: key);

  //ToDo:이미지랑 메뉴 정보 인자로 받아오기

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.15,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.white60;
              return Colors.white; // Use the component's default.
            },
          ),
        ),
        onPressed: (){},
        child: Row(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.13,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset('assets/images/menu.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5,5, 0,0),
              child: Column(
                children: [
                  Text(
                    '메뉴 이름',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '메뉴 설명',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],

        ),
      ),
    );
  }
}
