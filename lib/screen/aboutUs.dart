import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/screen/NavBar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  Card buildCard(String name, String fac, String img) {
    var heading = name;
    var subheading = fac;
    var cardImage = NetworkImage(img);
    var supportingText = '';
    return Card(
        elevation: .0,
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(heading),
              subtitle: Text(subheading),
              trailing: const Icon(Icons.book),
            ),
            SizedBox(
              height: 400.0,
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(supportingText),
            ),
            const ButtonBar(
              children: [],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    String host = ApiBaseHelper.memberImage;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          'ผู้จัดทำ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Center(
          child: ListView(
            children: [
              buildCard("กิติเทพ รุ่งเป้า", "65010974001", host + "4.jpeg"),
              buildCard(
                  "สุพรพรรณ ภูวนาทรุ่งเรือง", "65010974012", host + "3.jpeg"),
              buildCard("สุภาภรณ์ ชาธิพา", "65010974013", host + "2.jpeg"),
              buildCard("อุไรวรรณ ทิจันธุง", "65010974021", host + "1.jpeg"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(index: 4),
    );
  }
}
