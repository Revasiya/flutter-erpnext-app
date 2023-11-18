import 'package:flutter/material.dart';
import 'package:flutter_erpnext/models/Doc_list.dart';
import 'package:flutter_erpnext/screens/login.dart';
import 'package:flutter_erpnext/widgets/leave_apply.dart';
import 'package:flutter_erpnext/widgets/leave_report.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<ERPNextDocument> documents;
  int _currentIndex = 0;

  final List<Widget> _children = [const ApplyForLeave(), const LeaveReport()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        title: Text(
          'Erpnext Home',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                ModalRoute.withName('/'),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            label: 'Leaves List',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.summarize),
            label: 'Leave Report',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromRGBO(43, 137, 255, 1),
      ),
    ));
  }
}
