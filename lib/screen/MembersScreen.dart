import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_db/helper/ApiBaseHelper.dart';
import 'package:flutter_api_db/models/member.dart';
import 'package:flutter_api_db/screen/CustomDrawer.dart';
import 'package:flutter_api_db/screen/EditMemberScreen.dart';
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
      loadMembers();
    });
  }

  FutureBuilder<Map<String, dynamic>> DeleteStatus() {
    return FutureBuilder<Map<String, dynamic>>(
        future: deleteResult,
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("");
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
            return const Text("");
          } catch (error) {
            print("DELETE ERROR --> $error");
            return const Text("");
          }
        });
  }

  Card buildCard(Member? member) {
    var heading = "${member!.name!} ${member.last_name!}";
    var subheading = member.student_id!;
    var cardImage = NetworkImage(ApiBaseHelper.memberImage + member.m_img!);
    var supportingText = member.email!;

    return Card(
        elevation: .0,
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(heading),
              subtitle: Text(subheading),
              trailing: const Icon(Icons.person),
            ),
            SizedBox(
              height: 100.0,
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(supportingText),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EditMemberScreen(memberID: member.id!)));
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    removeMember(member.id!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 255, 117, 75), // Background color
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ));
  }

  FutureBuilder<Map<String, dynamic>> MembersSnap() {
    return FutureBuilder<Map<String, dynamic>>(
        future: members,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          ListView emptyTable = ListView(
            children: const [],
          );
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return emptyTable;
            } else {
              if (snapshot.hasData) {
                print("members-->");
                print(snapshot.data!["data"]);

                List<dynamic> rawMemberRow = snapshot.data!["data"];
                int index = 0;
                List<Card> memberRow = rawMemberRow.map((dynamic e) {
                  index++;
                  Member member = Member(
                      id: e["id"],
                      name: e["name"],
                      last_name: e["last_name"],
                      email: e["email"],
                      m_img: e["m_img"],
                      student_id: e["student_id"]);

                  return buildCard(member);
                }).toList();

                ListView memberList = ListView(
                  children: memberRow,
                );
                return memberList;
              } else if (snapshot.hasError) {
                print("get members error");
                return emptyTable;
              }
            }
          } catch (error) {
            print('เกิดข้อผิดพลาด: ${error.toString()}');
            return emptyTable;
          }
          return emptyTable;
        });
  }

  @override
  Widget build(BuildContext context) {
    loadMembers();

    return Scaffold(
      backgroundColor: Colors.black,
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
        title: const Text('ผู้ใช้งาน', style: TextStyle(color: Colors.white)),
        // bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(4.0),
        //     child: Container(
        //       color: Color.fromARGB(104, 255, 255, 255),
        //       height: 1.0,
        //     )),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Center(
          child: Column(
            children: [
              // const Text(
              //   "สมาชิก",
              //   style: TextStyle(
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => const AddMemberScreen(),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color.fromARGB(255, 147, 224, 45),
              //   ),
              //   child: const Text(
              //     "+ เพิ่มสมาชิก",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
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
