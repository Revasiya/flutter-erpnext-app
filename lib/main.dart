import 'package:flutter/material.dart';
import 'package:flutter_erpnext/screens/login.dart';
import 'package:flutter_erpnext/screens/tabs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERPNext Theme Example',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(43, 137, 255, 1),
          // ···
        ), // Replace with ERPNext's primary color
        // accentColor: Color(0xFF123456), // Replace with ERPNext's accent color

        // Define the default font family.
        fontFamily: 'Roboto', // Replace with the font family you prefer

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          titleSmall: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        ),

        // Define the default ButtonTheme. Use this to specify the default
        // button styling.
        buttonTheme: ButtonThemeData(
          buttonColor: const Color.fromRGBO(
              43, 137, 255, 1), // Replace with ERPNext's button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        // Define the default AppBar theme. Use this to specify the default
        // AppBar styling.
        appBarTheme: const AppBarTheme(
          color: Color.fromRGBO(
              43, 137, 255, 1), // Replace with ERPNext's app bar color
          elevation: 4.0,
        ),

        // You can add more theme properties here as needed.
      ),
      home: const LoginPage(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ERPNext Theme Example'),
//       ),
//       body: Center(
//         child: Text(
//           'Hello, World!',
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
