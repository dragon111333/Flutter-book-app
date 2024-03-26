import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_db/screen/MembersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/ApiBaseHelper.dart';
import '../models/member.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  Future<Map<String, dynamic>>? result;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: result == null ? showForm() : buildFutureBuilder(),
    );
  }

  Widget showForm() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/book.jpg"),
        fit: BoxFit.cover,
      )),
      child: IntrinsicHeight(
        child: Card(
            elevation: 4.0,
            color: const Color.fromRGBO(255, 255, 255, 0.808),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "ร้านขายหนังสือ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(label: Text('E-mail')),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 500,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: password,
                    decoration: const InputDecoration(label: Text('รหัสผ่าน')),
                    obscureText: true,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton.icon(
                      onPressed: onLogin,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber),
                      icon: const Icon(
                        Icons.key,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                const SizedBox(height: 20),
              ],
            )),
      ),
    );
  }

  //================================
  void onLogin() {
    //ตัวแปร productData เก็บข้อมูลสินค้าที่ผู้ใช้ป้อนบนฟอร์ม
    Map<String, String> userData = {
      "email": email.text,
      "password": password.text,
    };

    print("------>$userData");

    setState(() {
      //เรียกใช้งานฟังก์ชัน post เพื่อส่งข้อมูลไปยัง api
      result = ApiBaseHelper().manualPost(
          url: ApiBaseHelper.memberLogin, //url ของ api endpoint
          body: userData, //ข้อมูลสินค้า
          statusCode: 200 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลส าเร็จ
          );
    });
    print("login result -->");
    result!.then((e) => print(e.toString()));
  }

  //================================
  FutureBuilder<Map<String, dynamic>> buildFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: result,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        print("Login data -->${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          //ถ้าข้อมูลในส่วน status มีค่าเท่ากับ ok
          if (snapshot.data!['status'] == 'ok') {
            // print("data = " + jsonDecode(snapshot.data!['data']));
            Member member =
                Member.fromJson(jsonDecode(snapshot.data!['detail']));
            if (member.email != null) {
              print('member : >${member.toJson()}');
              Future(() async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('user_info', snapshot.data!['detail']);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(),
                        //builder: (_) => ProductListScreen()));
                        builder: (_) => const MemberScreen()));
              });
            } else {
              // password ไม่ถูกต้อง
              Future(() {
                // แสดงกล่องข้อความโต้ตอบ
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: const Text('email หรือ password ไม่ถูกต้อง'),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  //เมื่อกดปุ่ มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                  Navigator.of(context).pop();
                                },
                                child: const Text('ตกลง')),
                          ],
                        ));
              });
            }
          } else {
//ถ้าผิดพลาด
            Future(() {
              // แสดงกล่องข้อความโต้ตอบ
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: const Text('ผิดพลาด'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                //เมื่อกดปุ่ มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                Navigator.of(context).pop();
                              },
                              child: const Text('ตกลง')),
                        ],
                      ));
            });
          }
          return showForm();
        }
      },
    );
  }
  //======================================================
}
