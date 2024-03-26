import 'package:flutter/material.dart';
import 'package:flutter_api_db/screen/NavBar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  Card buildCard(String name, String fac, String img) {
    var heading = name;
    var subheading = fac;
    var cardImage = NetworkImage(img);
    var supportingText = '';
    return Card(
        elevation: 4.0,
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
              children: [
                // TextButton(
                //   child: const Text('CONTACT AGENT'),
                //   onPressed: () {/* ... */},
                // ),
                // TextButton(
                //   child: const Text('LEARN MORE'),
                //   onPressed: () {/* ... */},
                // )
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('ผู้จัดทำ'),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Center(
          child: ListView(
            children: [
              buildCard("นายอันดี เอเว่นส์", "คณะการบัญชีและการจัดการ",
                  "http://54.169.37.117/user4/img/1.jpeg"),
              buildCard("นางสาวณันทิชา วงษ์หงษ์", "คณะการบัญชีและการจัดการ",
                  "http://54.169.37.117/user4/img/2.jpeg"),
              buildCard("นางสาวอริสรา สัตย์ซื่อ", "คณะการบัญชีและการจัดการ",
                  "http://54.169.37.117/user4/img/3.jpeg"),
              buildCard("นางสาวอริสรา ผดุงเจริญ", "คณะการบัญชีและการจัดการ",
                  "http://54.169.37.117/user4/img/4.jpeg"),
              buildCard("นายศุภกรณ์ ศรีสง่า", "คณะการบัญชีและการจัดการ",
                  "http://54.169.37.117/user4/img/5.jpeg"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(index: 4),
    );
  }
}
