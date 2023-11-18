import 'package:flutter/material.dart';
import 'package:flutter_erpnext/models/Doc_list.dart';
import 'package:flutter_erpnext/widgets/leave_form.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplyForLeave extends StatefulWidget {
  final String employeeName;

  const ApplyForLeave({Key? key, required this.employeeName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ApplyForLeaveState();
  }
}

class _ApplyForLeaveState extends State<ApplyForLeave> {
  late Future<List<ERPNextDocument>> futureDocuments;

  @override
  void initState() {
    super.initState();
    futureDocuments = fetchDocuments();
  }

  Future<List<ERPNextDocument>> fetchDocuments() async {
    final response = await http.get(
        Uri.parse(
            'https://st-erp.frappe.cloud/api/resource/Leave Application?fields=["status", "employee_name","name", "from_date", "to_date"]'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Cookie':
              'sid=c1a6576e5100ad4766f337f7f7a175f56fb0a6a716a226c901df13b8'

          // Add your authorization headers or other necessary headers
        });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((doc) => ERPNextDocument.fromJson(doc)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  Widget _buildDocumentTable(List<ERPNextDocument> documents) {
    return DataTable(
      columnSpacing: 20.0, // Define column spacing
      columns: const <DataColumn>[
        DataColumn(label: Text('Document Name')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('From Date')),
        DataColumn(label: Text('To Date')),
      ],
      rows: documents.map((doc) {
        final formattedFromDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(doc.fromDate));
        final formattedToDate =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(doc.toDate));

        return DataRow(
          cells: <DataCell>[
            DataCell(Text(doc.name)),
            DataCell(Text(doc.status)),
            DataCell(Text(formattedFromDate)),
            DataCell(Text(formattedToDate)),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ERPNextDocument>>(
        future: futureDocuments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.employeeName,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16.0)),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildDocumentTable(snapshot.data!),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No documents found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Assuming showApplyLeaveForm is defined elsewhere
          showApplyLeaveForm(context);
        },
        tooltip: 'Apply for Leave',
        backgroundColor: const Color.fromRGBO(43, 137, 255, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
