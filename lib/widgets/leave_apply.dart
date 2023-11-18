import 'package:flutter/material.dart';
import 'package:flutter_erpnext/auth/auth_token.dart';
import 'package:flutter_erpnext/models/Doc_list.dart';
import 'package:flutter_erpnext/widgets/leave_form.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplyForLeave extends StatefulWidget {
  const ApplyForLeave({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ApplyForLeaveState();
  }
}

class _ApplyForLeaveState extends State<ApplyForLeave> {
  late Future<List<ERPNextDocument>> futureDocuments;

  void _onClickFloatingButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveApplicationFormScreen(
          onFormSubmitSuccess:
              refreshData, // Assuming refreshData is defined in the calling widget
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    try {
      List<ERPNextDocument> updatedDocuments = await fetchDocuments();
      setState(() {
        futureDocuments = Future.value(updatedDocuments);
      });
    } catch (error) {
      // Handle or log error
    }
  }

  @override
  void initState() {
    super.initState();
    futureDocuments = fetchDocuments();
  }

  Future<List<ERPNextDocument>> fetchDocuments() async {
    final String? token = await AuthStorage.getAuthToken();

    // Proceed only if token is not null
    if (token != null) {
      final response = await http.get(
          Uri.parse(
              'https://st-erp.frappe.cloud/api/resource/Leave Application?fields=["status", "employee_name","name", "from_date", "to_date"]'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': 'sid=$token' // Use the token in the Cookie header
          });

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body)['data'];
        return jsonResponse
            .map((doc) => ERPNextDocument.fromJson(doc))
            .toList();
      } else {
        throw Exception('Failed to load documents');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  Widget _buildDocumentTable(List<ERPNextDocument> documents) {
    return Scrollbar(
      thickness: 5,
      thumbVisibility: EditableText.debugDeterministicCursor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 10.0, // Define column spacing
          columns: const <DataColumn>[
            DataColumn(label: Text('Document Name')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('From Date')),
            DataColumn(label: Text('To Date')),
          ],
          rows: documents.map((doc) {
            final formattedFromDate =
                DateFormat('yyyy-MM-dd').format(DateTime.parse(doc.fromDate!));
            final formattedToDate =
                DateFormat('yyyy-MM-dd').format(DateTime.parse(doc.toDate!));

            return DataRow(
              cells: <DataCell>[
                DataCell(Text(doc.name)),
                DataCell(Text(
                  doc.status,
                  style: TextStyle(
                    color: (doc.status == 'Approved')
                        ? Colors.green
                        : (doc.status == 'Rejected')
                            ? Colors.red
                            : (doc.status == 'Pending')
                                ? Colors.orange
                                : Color.fromARGB(255, 183, 106, 11),
                  ),
                )),
                DataCell(Text(doc.fromDate != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(doc.fromDate!))
                        : 'N/A' // Default text if fromDate is null
                    )),
                DataCell(Text(doc.toDate != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(doc.toDate!))
                        : 'N/A' // Default text if toDate is null
                    )),
              ],
            );
          }).toList(),
        ),
      ),
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
            return Scrollbar(
                thumbVisibility: true,
                thickness:
                    10, // Set to true if you always want to show the scrollbar
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildDocumentTable(snapshot.data!),
                    ),
                  ],
                ));
          } else {
            return const Center(child: Text('No documents found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onClickFloatingButton,
        tooltip: ' for Leave',
        backgroundColor: const Color.fromRGBO(43, 137, 255, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
