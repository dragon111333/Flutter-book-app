import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/CustomDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController student_id = TextEditingController();
  TextEditingController password = TextEditingController();

  late bool isFinish;
  Future<Map<String, dynamic>>? result;
  late Member? loginMember;
  File? uploadImage;

  @override
  void initState() {
    super.initState();
    isFinish = false;
    loginMember = Member();
  }

  void clearTextEditor() {
    name.text = "";
    last_name.text = "";
    email.text = "";
    password.text = "";
    student_id.clear();
    uploadImage = null;
  }

  Future<void> createMember() async {
    print("creating....");
    Map<String, String> userData = {
      "email": email.text,
      "name": name.text,
      "last_name": last_name.text,
      "password": password.text,
      "student_id": student_id.text,
    };

    if (userData["email"] == "" ||
        userData["name"] == "" ||
        userData["last_name"] == "" ||
        userData["password"] == "" ||
        userData["student_id"] == "" ||
        uploadImage == null) {
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
      result = ApiBaseHelper().post(
          url: ApiBaseHelper.createMember,
          dataPost: userData,
          fileUpload: {
            "fieldName": "m_img", //ฟิวด์ใน api
            "filePath": uploadImage!.path, //ที่อยู่ (path) ของไฟล์รูปภาพ
          },
          statusCode: 201);
      uploadImage = null;
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
            Member member = Member.fromJson(jsonDecode(snapshot.data!['data']));
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

  Future<void> chooseImage(ImageSource source) async {
    //เรียกใช้งาน ImagePicker
    var choosedimage = await ImagePicker().pickImage(source: source);
    setState(() {
      if (choosedimage == null) return;
      uploadImage = File(choosedimage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    double inputWidth = 250;

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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Color.fromARGB(24, 0, 0, 0),
              height: 1.0,
            )),
        backgroundColor: Colors.white,
      ),
      //body: result == null ? showForm() : buildFutureBuilder(),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: [
          const Text("เพิ่มผู้ใช้งาน",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
                controller: student_id,
                decoration: const InputDecoration(label: Text('รหัสนิสิต'))),
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
            child: PopupMenuButton<ImageSource>(
              child: SizedBox(
                width: 150,
                height: 120,
                //ถ้าผู้ใช้เลือกรูปภาพแล้วให้แสดงภาพที่เลือก ถ้าไม่ใช่ให้แสดงไอคอน image
                child: uploadImage != null
                    ? Image.file(uploadImage!)
                    : const Icon(
                        Icons.image,
                        size: 100,
                      ),
              ),
              //รายการเมนูสำหรับเลือกรูปภาพ
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ImageSource>>[
                //เลือกรูปภาพจาก Image Gallery
                const PopupMenuItem<ImageSource>(
                  value: ImageSource.gallery,
                  child: Icon(Icons.image_search_rounded),
                ),
                //เลือกรูปภาพจากกล้องถ่ายรูป
                const PopupMenuItem<ImageSource>(
                  value: ImageSource.camera,
                  child: Icon(Icons.camera_alt_rounded),
                ),
              ],
              //เมื่อเลือกเมนูแล้วจะไปเรียกใช้ฟังก์ชัน chooseImage
              onSelected: (ImageSource imageSource) {
                chooseImage(imageSource);
              },
            ),
          ),
          SizedBox(
              width: inputWidth,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => createMember(),
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "บันทึก",
                    style: TextStyle(color: Colors.white),
                  ))),
          CreateStatus()
        ]),
      ),
      bottomNavigationBar: const NavBar(index: 1),
    );
  }
}
