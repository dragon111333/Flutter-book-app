import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/CustomDrawer.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddMemberScreen.dart';
import 'NavBar.dart';

var logger = Logger();

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});
  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late Future<Map<String, dynamic>> members;
  late Future<Map<String, dynamic>>? deleteResult;
  late Member? loginMember;
  @override
  void initState() {
    super.initState();
    loadMembers();
    deleteResult = null;
    loginMember = Member();
  }

  void loadMembers() {
    setState(() {
      members = ApiBaseHelper().get(url: ApiBaseHelper.getMembers);
    });
  }

  Future<void> removeMember(int memberID) async {
    setState(() {
      deleteResult = ApiBaseHelper().delete(
          url: ApiBaseHelper.deleteMember + memberID.toString(),
          statusCode: 202);
    });
  }

  FutureBuilder<Map<String, dynamic>> DeleteStatus() {
    return FutureBuilder<Map<String, dynamic>>(
        future: deleteResult,
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("");
            } else if (snapshot.hasData) {
              print("delete status ->" + snapshot.data!["status"]);
              WidgetsBinding.instance.addPostFrameCallback((timestamp) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          icon: const Icon(
                            Icons.check,
                            color: Color.fromARGB(255, 147, 224, 45),
                          ),
                          backgroundColor: Colors.white,
                          content: const Text('ลบสำเร็จ'),
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
            return Text("");
          } catch (error) {
            print("DELETE ERROR --> ${error}");
            return Text("");
          }
        });
  }

  FutureBuilder<Map<String, dynamic>> MembersSnap() {
    return FutureBuilder<Map<String, dynamic>>(
        future: members,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          DataTable emptyTable = DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
            rows: const <DataRow>[
              DataRow(cells: <DataCell>[DataCell(Text(""))])
            ],
          );
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return emptyTable;
            } else {
              if (snapshot.hasData) {
                print("members-->");
                print(snapshot.data!["data"]);

                List<dynamic> rawMemberRow = snapshot.data!["data"];
                int _index = 0;
                List<DataRow> memberRow = rawMemberRow.map((dynamic e) {
                  _index++;
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(_index.toString())),
                      DataCell(Text(e["name"])),
                      DataCell(Text(e["last_name"])),
                      DataCell(Text(e["email"])),
                      DataCell(ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 238, 0)),
                        label: const Text(
                          "แก้ไข",
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                        ),
                      )),
                      DataCell(ElevatedButton.icon(
                          onPressed: () {
                            removeMember(int.parse(e["id"].toString()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 255, 117, 75), // Background color
                          ),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "ลบ",
                            style: TextStyle(color: Colors.white),
                          ))),
                    ],
                  );
                }).toList();

                Widget memberList = DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'No.',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'ชื่อ',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'นามสกุล',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'E-mail',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          '',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          '',
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: memberRow,
                );
                return memberList;
              } else if (snapshot.hasError) {
                print("get members error");
                return emptyTable;
              }
            }
          } catch (error) {
            print('เกิดข้อผิดพลาด: $error');
            return emptyTable;
          }
          return emptyTable;
        });
  }

  @override
  Widget build(BuildContext context) {
    loadMembers();

    return Scaffold(
      drawer: CustomDrawer(
        member: loginMember!,
      ),
      onDrawerChanged: (isOpen) {
        setState(() {
          (() async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            String? userString = await prefs.getString('user_info');
            loginMember = Member.fromJson(jsonDecode(userString!));
          })();
        });
      },
      appBar: AppBar(
        title: const Text('ผู้ใช้งาน'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "รายชื่อสมาชิก",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddMemberScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 147, 224, 45),
                ),
                child: const Text(
                  "+ เพิ่มสมาชิก",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: MembersSnap(),
              ),
              DeleteStatus()
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(index: 0),
    );
  }
}
