import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';

import 'NavBar.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() {
    return _AddMemberScreenState();
  }
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  late bool isFinish;
  Future<Map<String, dynamic>>? result;

  @override
  void initState() {
    super.initState();
    isFinish = false;
  }

  void clearTextEditor() {
    name.text = "";
    last_name.text = "";
    email.text = "";
    password.text = "";
  }

  Future<void> createMember() async {
    print("creating....");
    Map<String, String> userData = {
      "email": email.text,
      "name": name.text,
      "last_name": last_name.text,
      "password": password.text
    };

    if (userData["email"] == "" ||
        userData["name"] == "" ||
        userData["last_name"] == "" ||
        userData["password"] == "") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  backgroundColor: Colors.white,
                  content: const Text('โปรดกรอกข้อมูลให้ครบถ้วน'),
                  actions: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'ตกลง',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ));
      });
      return;
    }

    setState(() {
      result = ApiBaseHelper().manualPost(
          url: ApiBaseHelper.createMember, body: userData, statusCode: 201);
    });
  }

  FutureBuilder<Map<String, dynamic>> CreateStatus() {
    return FutureBuilder<Map<String, dynamic>>(
      future: result,
      builder: ((BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> snapshot) {
        try {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Text("");
          }

          print("status--->" + snapshot.data!["status"]);

          if (snapshot.data!["status"] != "ok") {
            throw ErrorDescription("status not ok!");
          } else {
            Member member =
                Member.fromJson(jsonDecode(snapshot.data!['detail']));
            if (member.id != null) {
              print("add success");
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          icon: const Icon(
                            Icons.check,
                            color: Color.fromARGB(255, 147, 224, 45),
                          ),
                          backgroundColor: Colors.white,
                          content: const Text('เพิ่มสำเร็จ'),
                          actions: <Widget>[
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 147, 224, 45),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'ตกลง',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ));
                clearTextEditor();
              });
            }
          }
        } catch (error) {
          print("CreateStatus ERROR ---> $error");
          return const Text("ERROR");
        }
        return const Text("");
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double inputWidth = 250;

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลผู้ใช้'),
        backgroundColor: Colors.amber,
      ),
      //body: result == null ? showForm() : buildFutureBuilder(),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: [
          const Text("เพิ่มผู้ใช้งาน"),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
                controller: name,
                decoration: const InputDecoration(label: Text('ชื่อ'))),
          ),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
                controller: last_name,
                decoration: const InputDecoration(label: Text('นามสกุล'))),
          ),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
                controller: email,
                decoration: const InputDecoration(label: Text('E-mail'))),
          ),
          SizedBox(
            width: inputWidth,
            child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(label: Text('รหัสผ่าน'))),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              width: inputWidth,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 224, 45),
                  ),
                  onPressed: () => createMember(),
                  child: const Text(
                    "บันทึก",
                    style: TextStyle(color: Colors.white),
                  ))),
          CreateStatus()
        ]),
      ),
      bottomNavigationBar: const NavBar(index: 2),
    );
  }
}
