import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/faculty.dart';
import 'package:flutter_api_db/models/products.dart';
import 'package:image_picker/image_picker.dart';

class FacultyUpdateScreen extends StatefulWidget {
  //ตัวแปร data ส าหรับจัดเก็บข้อมูลสินค้าที่จะถูกส่งเข้ามาแก้ไขในหน้านี้
  Faculty data;
  //ฟังก์ชัน loadProduct ส าหรับเชื่อมโยงฟังก์ชันการโหลดข้อมูลสินค้าที่จะถูกส่งเข้ามาในหน้านี้
  Function loadProduct;
  FacultyUpdateScreen({Key? key, required this.data, required this.loadProduct})
      : super(key: key);
  @override
  State<FacultyUpdateScreen> createState() => _FacultyUpdateScreenState();
}

class _FacultyUpdateScreenState extends State<FacultyUpdateScreen> {
  //ตัวแปร result ส าหรับจดัเก็บผลลพัธ์ที่ไดจ้ากการเพิ่มขอ้มูลใหม่
  Future<Map<String, dynamic>>? result;
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องชื่อสินค้า
  late TextEditingController f_name;
  //ตัวแปรจัดเก็บค่าที่กรอกในช่องราคาสินค้า
  late TextEditingController details;
  //ตัวแปรจัดเก็บข้อมูลไฟล์ที่ผู้ใช้เลือก
  File? uploadImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ให้น าข้อมูลสินค้ามาแสดงในแต่ละช่อง TextFormField
    f_name = TextEditingController(text: widget.data.f_name!);
    details = TextEditingController(text: widget.data.details!);
  }

  @override
  void dispose() {
    //เมื่อปิ ดหน้ากรอกข้อมูลให้ล้างตัวแปรออก
    f_name.dispose();
    details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Color.fromARGB(24, 0, 0, 0),
                height: 1.0,
              )),
          backgroundColor: Colors.white,
          title: const Text('แก้ไขข้อมูลคณะ')),
      body: result == null ? showForm() : buildFutureBuilder(),
    );
  }

  //======================================================
  //ฟังก์ชันฟอร์มส าหรับกรอกข้อมูล
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
                decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextFormField(
                controller: details,
                decoration: const InputDecoration(labelText: 'ราคา'),
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
                    //ถ้าผู้ใช้เลือกรูปภาพแล้วให้แสดงภาพที่เลือก
                    child: uploadImage != null
                        ? Image.file(uploadImage!)
                        : widget.data !=
                                null //ถ้าข้อมูลเดิมมีรูปภาพให้แสดงรูปภาพ
                            ? Image.network(Uri.decodeFull(
                                ApiBaseHelper.memberImage + widget.data.f_img!))
                            : const Icon(
                                Icons.image,
                                size: 100,
                              ),
                  ),
                  //รายการเมนูส าหรับเลือกรูปภาพ
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
              //ป่มุ เพิ่มขอ้มูลสินคา้
              ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle),
                  label: const Text('แก้ไขข้อมูล'),
                  onPressed: () {
                    //ตัวแปร productData เก็บข้อมูลสินค้าที่ผู้ใช้ป้อนบนฟอร์ม
                    Map<String, String> productData = {
                      "f_name": f_name.text,
                      "details": details.text,
                    };
                    Map<String, String>? fileUploadData;
                    //ตรวจสอบตัวแปร uploadImage ว่ามีข้อมูลหรือไม่
                    if (uploadImage != null) {
                      //ตัวแปร fileUploadData เก็บข้อมูลไฟล์รูปภาพที่ผู้เลือก
                      fileUploadData = {
                        "fieldName": "f_img", //ฟิ วด์ใน api
                        "filePath":
                            uploadImage!.path, //ที่อยู่ (path) ของไฟล์รูปภาพ
                      };
                    }
                    setState(() {
                      //ก าหนด url ส าหรับเรียกใช้งาน api endpoint ส าหรับแก้ไขข้อมูลคณะตามรหัส p_id
                      String urlApi =
                          '${ApiBaseHelper.updateFaculty}${widget.data.f_id!}';
                      //เรียกใช้งานฟังก์ชัน put เพื่อส่งข้อมูลไปยัง api
                      result = ApiBaseHelper().put(
                          url: urlApi, //url ของ api endpoint
                          dataPut: productData, //ข้อมูลสินค้า
                          fileUpload: fileUploadData, //ข้อมูลไฟล์
                          statusCode:
                              202 //รหัสการตอบกลับของ api เมื่อบันทึกข้อมูลส าเร็จ
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
  //ฟังก์ชันส าหรับเลือกรูปภาพ
  Future<void> chooseImage(ImageSource source) async {
    //เรียกใช้งาน ImagePicker
    var choosedimage = await ImagePicker().pickImage(source: source);
    setState(() {
      //น าข้อมูลไฟล์รูปภาพที่เลือก มาเก็บไว้ในตัวแปร uploadImage
      uploadImage = File(choosedimage!.path);
    });
  }

  //======================================================
  //ฟังก์ชันส าหรับตรวจสอบการตอบกลับจากการแก้ไขข้อมูลคณะ
  FutureBuilder<Map<String, dynamic>> buildFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: result,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        //ถ้าอยู่ระหว่างโหลดข้อมูล ให้แสดงสถานะการโหลดด้วย CircularProgressIndicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          //ถ้าข้อมูลในส่วน status มีค่าเท่ากับ ok
          if (snapshot.data!['status'] == 'ok') {
            Future(() {
              //ให้เรียกใช้งานฟังก์ชัน loadProduct ที่ถูกส่งเข้ามาในหน้านี้
              widget.loadProduct();
              // แสดงกล้องข้อความโต้ตอบ
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: const Text('แก้ไขข้อมูลส าเร็จ'),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                //เมื่อกดปุ่ มตกลง ให้กล่องข้อความโต้ตอบหายไป
                                Navigator.of(context).pop();
                                //ถอยกลับไปยังหน้าก่อนหน้านี้ คือหน้าแสดงรายชื่อคณะ
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
