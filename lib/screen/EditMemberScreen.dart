import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/CustomDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NavBar.dart';

class EditMemberScreen extends StatefulWidget {
  final int memberID;

  const EditMemberScreen({super.key, required this.memberID});

  @override
  State<EditMemberScreen> createState() {
    return _EditMemberScreenState();
  }
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  late bool isFinish;
  Future<Map<String, dynamic>>? result;
  late Member? loginMember;

  @override
  void initState() {
    super.initState();
    isFinish = false;
    loginMember = Member();
  }

  Future<void> updateMember() async {
    print("creating....");
    Map<String, String> userData = {
      "email": email.text,
      "name": name.text,
      "last_name": last_name.text,
    };

    if (userData["email"] == "" ||
        userData["name"] == "" ||
        userData["last_name"] == "") {
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
      result = ApiBaseHelper().manualPut(
          url: ApiBaseHelper.updateMember + widget.memberID.toString(),
          dataPut: userData,
          statusCode: 202);
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
                          content: const Text('แก้ไขสำเร็จ'),
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

  Future<void> getMember(String memberID) async {
    setState(() {
      (() async {
        Future<Map<String, dynamic>>? futureMember =
            ApiBaseHelper().get(url: ApiBaseHelper.getOneMember + memberID);
        Map<String, dynamic> memberMap = (await futureMember)["data"][0];
        //currentMember!.id = int.parse(memberID);
        name.text = memberMap["name"];
        last_name.text = memberMap["last_name"];
        email.text = memberMap["email"];

        print("current user data is ->");
        print(memberMap);
      })();
    });
  }

  @override
  Widget build(BuildContext context) {
    double inputWidth = 250;
    String memberID = widget.memberID.toString();
    getMember(memberID);

    return Scaffold(
      drawer: CustomDrawer(
        member: loginMember!,
      ),
      onDrawerChanged: (isOpen) {
        setState(() {
          (() async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            String? userString = prefs.getString('user_info');
            loginMember = Member.fromJson(jsonDecode(userString!));
          })();
        });
      },
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลผู้ใช้'),
        backgroundColor: Colors.amber,
      ),
      //body: result == null ? showForm() : buildFutureBuilder(),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: <Widget>[
          Text("แก้ไขผู้ใช้งาน ID :$memberID ",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),

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
          // SizedBox(
          //   width: inputWidth,
          //   child: TextFormField(
          //       controller: password,
          //       obscureText: true,
          //       decoration: const InputDecoration(label: Text('รหัสผ่าน'))),
          // ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              width: inputWidth,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 147, 224, 45),
                  ),
                  onPressed: () => updateMember(),
                  child: const Text(
                    "บันทึก",
                    style: TextStyle(color: Colors.white),
                  ))),
          CreateStatus()
        ]),
      ),
      bottomNavigationBar: const NavBar(index: 0),
    );
  }
}
