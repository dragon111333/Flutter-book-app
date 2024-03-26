import 'package:flutter/material.dart';
import 'package:flutter_api_db/screen/AddMemberScreen.dart';
import 'package:flutter_api_db/screen/MembersScreen.dart';
import 'package:flutter_api_db/screen/ProductListScreen.dart';
import 'package:flutter_api_db/screen/aboutUs.dart';
import 'package:flutter_api_db/screen/productAddScreen.dart';

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
                  MaterialPageRoute(builder: (_) => const ProductListScreen()));
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ProductAddScreen()));
            case 4:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const AboutUs()));
            default:
          }
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'หน้าแรก',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.add_comment)),
          label: 'เพิ่มสมาชิก',
        ),
        NavigationDestination(
          icon: Icon(Icons.book),
          label: 'หนังสือ',
        ),
        NavigationDestination(
          icon: Icon(Icons.add),
          label: 'เพิ่มหนังสือ',
        ),
        NavigationDestination(
          icon: Icon(Icons.group),
          label: 'สมาชิกกลุ่ม',
        ),
      ],
    );
  }
}
