// import 'package:flutter/material.dart';
// import 'package:flutter_erpnext/models/Doc_list.dart';
// import 'package:flutter_erpnext/widgets/leave_apply.dart';

// class ERPNextDocumentList extends StatelessWidget {
//   final List<ERPNextDocument> documents;

//   const ERPNextDocumentList({Key? key, required this.documents})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: documents.length,
//       itemBuilder: (context, index) {
//         ERPNextDocument doc = documents[index];
//         return ListTile(
//           title: Text(doc.name),
//           subtitle:
//               Text('Employee: ${doc.employeeName} - Status: ${doc.status}'),
//           // Add other UI elements or styling as needed
//         );
//       },
//     );
//   }
// }
