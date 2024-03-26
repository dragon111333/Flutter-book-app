import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/CustomDrawer.dart';
import 'package:flutter_api_db/screen/NavBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacultyAddScreen extends StatefulWidget {
  const FacultyAddScreen({Key? key}) : super(key: key);

  @override
  State<FacultyAddScreen> createState() => _FacultyAddScreenState();
}

class _FacultyAddScreenState extends State<FacultyAddScreen> {
  //ตัวแปร result สำหรับจัดเก็บผลลัพธ์ที่ได้จากการเพิ่มข้อมูลใหม่
  Future<Map<String, dynamic>>? result;
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องชื่อสินค้า
  final f_name = TextEditingController();
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องราคาสินค้า
  final details = TextEditingController();
  //ตัวแปรจัดเก็บข้อมูลไฟล์ที่ผู้ใช้เลือก
  File? uploadImage;
  Member? loginMember;
  @override
  void dispose() {
    //เมื่อปิดหน้ากรอกข้อมูลให้ล้างตัวแปรออก
    f_name.dispose();
    details.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginMember = Member();
  }

  @override
  Widget build(BuildContext context) {
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
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Color.fromARGB(24, 0, 0, 0),
                height: 1.0,
              )),
          backgroundColor: Colors.white,
          title: const Text('เพิ่มข้อมูลคณะ')),
      body: result == null ? showForm() : buildFutureBuilder(),
      bottomNavigationBar: const NavBar(index: 3),
    );
  }

  //======================================================
  //ฟังก์ชันฟอร์มสำหรับกรอกข้อมูล
  Widget showForm() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: f_name,
                decoration: const InputDecoration(labelText: 'ชื่อคณะ'),
              ),
              TextFormField(
                controller: details,
                decoration: const InputDecoration(labelText: 'รายละเอียด'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                //เมนูเลือกรูปภาพ
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
              const SizedBox(
                height: 10,
              ),
              //ปุ่มเพิ่มข้อมูลคณะ
              ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  label: const Text(
                    'เพิ่มข้อมูล',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //ตัวแปร facultyData เก็บข้อมูลสินค้าที่ผู้ใช้ป้อนบนฟอร์ม
                    Map<String, String> facultyData = {
                      "f_name": f_name.text,
                      "details": details.text,
                    };
                    Map<String, String>? fileUploadData;
                    //ตรวจสอบตัวแปร uploadImage ว่ามีข้อมูลหรือไม่
                    if (uploadImage != null) {
                      //ตัวแปร fileUploadData เก็บข้อมูลไฟล์รูปภาพที่ผู้เลือก
                      fileUploadData = {
                        "fieldName": "f_img", //ฟิวด์ใน api
                        "filePath":
                            uploadImage!.path, //ที่อยู่ (path) ของไฟล์รูปภาพ
                      };
                    }

                    setState(() {
                      //เรียกใช้งานฟังก์ชัน postFile เพื่อส่งข้อมูลไปยัง api
                      result = ApiBaseHelper().post(
                          url: ApiBaseHelper
                              .addNewFaculty, //url ของ api endpoint
                          dataPost: facultyData, //ข้อมูลสินค้า
                          fileUpload: fileUploadData, //ข้อมูลไฟล์
                          statusCode:
                              201 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลสำเร็จ
                          );
                    });
                    //ล้างค่าตัวแปรออก
                    f_name.clear();
                    details.clear();
                    uploadImage = null;
                  })
            ],
          ),
        )),
      ),
    );
  }

  //======================================================
  //ฟังก์ชันสำหรับเลือกรูปภาพ
  Future<void> chooseImage(ImageSource source) async {
    //เรียกใช้งาน ImagePicker
    var choosedimage = await ImagePicker().pickImage(source: source);
    setState(() {
      //นำข้อมูลไฟล์รูปภาพที่เลือก มาเก็บไว้ในตัวแปร uploadImage
      uploadImage = File(choosedimage!.path);
    });
  }

  //======================================================
  //ฟังก์ชันสำหรับตรวจสอบการตอบกลับจากการเพิ่มข้อมูลใหม่
  FutureBuilder<Map<String, dynamic>> buildFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: result,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        //ถ้าอยู่ระหว่างโหลดข้อมูล ให้แสดงสถานะการโหลดด้วย CircularProgressIndicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data!['status'] == 'ok') {
            print('add status ${snapshot.data!['status']}');
            Future(() {
              // แสดงกล้องข้อความโต้ตอบ
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: const Text('เพิ่มข้อมูลสำเร็จ'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                //เมื่อกดปุ่มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                Navigator.of(context).pop();
                              },
                              child: const Text('ตกลง')),
                        ],
                      ));
            });
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
                                //เมื่อกดปุ่มตกลง ให้กล่องข้อความโต้ตอบหายไป
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
