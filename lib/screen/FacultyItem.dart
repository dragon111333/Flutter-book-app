import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/faculty.dart';
import 'package:flutter_api_db/models/products.dart';
import 'package:flutter_api_db/screen/FacultyUpdateScreen.dart';

class FacultyItem extends StatefulWidget {
  //object ข้อมูลสินค้าแต่ละรายการ
  Faculty data;
  //รับค่าข้อมูลสินค้าแต่ละรายการเข้ามาในคลาสนี้
  Function DeleteFunction;
  Function loadProduct;
  FacultyItem(this.data, this.DeleteFunction, this.loadProduct, {super.key});
  @override
  State<StatefulWidget> createState() => _FacultyItemState();
}

class _FacultyItemState extends State<FacultyItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {},
      //กล่องแบบ Card
      child: Card(
        elevation: .0,
        margin: const EdgeInsets.all(10),
        child: Padding(
          //ก าหนดช่องว่างจากขอบกล่อง
          padding: const EdgeInsets.all(8.0),
          child: Row(
            //จัดวางในแนวนอนเป็นแถว
            children: [
              //แสดงรูปภาพ
              Expanded(
                  child: Image.network(
                Uri.decodeFull(ApiBaseHelper.memberImage + widget.data.f_img!),
              )),
              //กล่องว่างๆ
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //แสดงชื่อสินค้า
                    Text(
                      widget.data.f_name!,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    //แสดงราคา
                    Text(
                      'รายละเอียด : ${widget.data.f_name!}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //ปุ่ มไอคอนส าหรับลบสินค้า
                        IconButton(
                            onPressed: () {
                              //เมื่อถูกกดให้เรียกใช้ฟังก์ชัน deleteFuction และส่งค่ารหัสสินค้าไปด้วย
                              widget.DeleteFunction(widget.data.f_id);
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              //เมื่อถูกกดให้เปิ ดหน้า ProductAddScreen และส่งข้อมูลสินค้าไปด้วย
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FacultyUpdateScreen(
                                            data: widget.data,
                                            loadProduct: widget.loadProduct,
                                          )));
                            },
                            icon: const Icon(Icons.edit_note_outlined))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
