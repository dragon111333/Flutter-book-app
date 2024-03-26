import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/CustomDrawer.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController student_id = TextEditingController();

  Future<Map<String, dynamic>>? result;
  late Member? loginMember;

  File? uploadImage;
  late String? currentMemberImage;
  @override
  void initState() {
    super.initState();
    loginMember = Member();
    uploadImage = null;
    currentMemberImage = null;
    getMember(widget.memberID.toString());
  }

  Future<void> updateMember() async {
    print("updating....");
    Map<String, String>? userData = {
      "email": email.text,
      "name": name.text,
      "last_name": last_name.text,
      "student_id": student_id.text
    };

    if (userData["email"] == "" ||
        userData["name"] == "" ||
        userData["last_name"] == "" ||
        userData["student_id"] == "") {
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
      Map<String, String>? fileUploadData;
      if (uploadImage != null) {
        fileUploadData = {
          "fieldName": "m_img", //ฟิ วด์ใน api
          "filePath": uploadImage!.path, //ที่อยู่ (path) ของไฟล์รูปภาพ
        };
      }
      result = ApiBaseHelper().put(
          url: ApiBaseHelper.updateMember + widget.memberID.toString(),
          dataPut: userData,
          fileUpload: fileUploadData,
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
          print("data--->" + snapshot.data!.toString());

          if (snapshot.data!["status"] != "ok") {
            throw ErrorDescription("status not ok!");
          } else {
            Member member = Member.fromJson(jsonDecode(snapshot.data!['data']));
            print("latest member ${member ?? "null"}");
            if (member!.id != null) {
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
          print("Edit ERROR ---> $error");
          return const Text("ERROR");
        }
        return const Text("");
      }),
    );
  }

  void getMember(String memberID) {
    setState(() {
      (() async {
        Future<Map<String, dynamic>>? futureMember =
            ApiBaseHelper().get(url: ApiBaseHelper.getOneMember + memberID);
        Map<String, dynamic> memberMap = (await futureMember)["data"][0];
        //currentMember!.id = int.parse(memberID);
        name.text = memberMap["name"];
        last_name.text = memberMap["last_name"];
        email.text = memberMap["email"];
        student_id.text = memberMap["student_id"];

        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            currentMemberImage = memberMap["m_img"];
          });
        });
        print("current user data is ->");
        print(memberMap.toString());
      })();
    });
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
        child: Column(children: <Widget>[
          Text("แก้ไขผู้ใช้งาน ID :${widget.memberID} ",
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),

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
                    : currentMemberImage != null
                        ? Image.network(
                            ApiBaseHelper.memberImage + currentMemberImage!)
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
