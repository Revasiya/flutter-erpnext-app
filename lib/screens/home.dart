import 'package:flutter/material.dart';
import 'package:flutter_erpnext/screens/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        appBar: AppBar(
          title: Text(
            'Erpnext Home',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
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
        body: const Column(
          children: [Text('Home')],
        ),
      ),
    );
  }
}
