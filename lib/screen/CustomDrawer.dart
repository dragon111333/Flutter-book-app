import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/LoginScreen.dart';

class CustomDrawer extends StatefulWidget {
  Member member;
  CustomDrawer({super.key, required this.member});
  @override
  State<StatefulWidget> createState() {
    return _CustomDrawerState();
  }
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(var context) {
    Member member = Member();

    member.name = widget.member.name ?? "";
    member.last_name = widget.member.last_name ?? "";
    member.email = widget.member.email ?? "";
    member.id = widget.member.id ?? 0;

    print("mmeber------------>${widget.member}");

    return Drawer(
        backgroundColor: Colors.white,
        child: Container(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("${member.name!} ${member.last_name!}"),
                accountEmail: Text(member.email!),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: (member.m_img != null)
                      ? NetworkImage(ApiBaseHelper.memberImage + member!.m_img!)
                      : NetworkImage(
                          "https://www.seekpng.com/png/full/245-2454602_tanni-chand-default-member-image-png.png"),
                ),
              ),
              //รายการเมนู

              ListTile(
                title: const Text('ออกจากระบบ'),
                onTap: () {
                  Navigator.pop(context);
                  //ออกจากหน้าทั้งหมด แล้วไปเปิดหน้า login ใหม่
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen()),
                      ModalRoute.withName('/'));
                  // );
                },
              ),
            ],
          ),
        ));
  }
}
