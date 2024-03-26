import 'package:flutter/material.dart';
import 'package:flutter_api_db/screen/AddMemberScreen.dart';
import 'package:flutter_api_db/screen/MembersScreen.dart';
import 'package:flutter_api_db/screen/FacultyListScreen.dart';
import 'package:flutter_api_db/screen/aboutUs.dart';
import 'package:flutter_api_db/screen/FacultyAddScreen.dart';

class NavBar extends StatefulWidget {
  final int index;
  const NavBar({super.key, required this.index});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    setState(() {
      currentPageIndex = widget.index;
    });

    return NavigationBar(
      elevation: .0,
      onDestinationSelected: (int index) {
        setState(() {
          print("select index : $index");
          //currentPageIndex = index;
          switch (index) {
            case 0:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MemberScreen()));
              break;
            case 1:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const AddMemberScreen()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const FacultyListScreen()));
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const FacultyAddScreen()));
            case 4:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const AboutUs()));
            default:
          }
        });
      },
      indicatorColor: Colors.black,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          icon: Icon(Icons.home_outlined),
          label: 'หน้าแรก',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.add_comment,
            color: Colors.white,
          ),
          icon: Badge(child: Icon(Icons.add_comment)),
          label: 'เพิ่มสมาชิก',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.book_online,
            color: Colors.white,
          ),
          icon: Icon(Icons.book),
          label: 'คณะ',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          icon: Icon(Icons.add),
          label: 'เพิ่มคณะ',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.group,
            color: Colors.white,
          ),
          icon: Icon(Icons.group),
          label: 'สมาชิกกลุ่ม',
        ),
      ],
    );
  }
}
