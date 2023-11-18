// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

final TextEditingController _startDateController = TextEditingController();
final TextEditingController _endDateController = TextEditingController();
String? _selected_leavetype;

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(initialDate.year - 1);
  DateTime lastDate = DateTime(initialDate.year + 1);

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (picked != null && picked != initialDate) {
    controller.text = DateFormat('yyyy-MM-dd').format(picked);
  }
}

void onSubmit(BuildContext context) async {
  final from_date = _startDateController.text;
  final to_date = _endDateController.text;

  if (from_date.isEmpty || to_date.isEmpty || _selected_leavetype == null) {
    _showDialog(context, 'Invalid Input', 'Please fill in all the fields.');
    return;
  }

  var data = json.encode({
    'leave_type': _selected_leavetype,
    'from_date': from_date,
    'to_date': to_date,
  });

  final response = await http.post(
      Uri.parse('https://st-erp.frappe.cloud/api/resource/Leave Application'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie': 'sid=7b33fa072f19cace545de2c7fdc5202f3d625cf0bae6b73cb9642800'
      },
      body: data);
  // body: json.encode({'date': from_date, 'to_date': to_date}));

  print(response.body);
  print(from_date);
  print(to_date);

  if (response.statusCode == 200) {
    // ignore: use_build_context_synchronously
    _showDialog(context, 'Success', 'Leave applied');
  } else {
    _showDialog(context, 'Failed', 'Something went wrong');
  }
}

void _showDialog(BuildContext context, String messageType, String message) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(messageType),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          )
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(messageType),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.onError,
      ),
    );
  }
}

void showApplyLeaveForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          List<String> _leave_types = ['Paid Leaves', 'Festival Leaves'];

          return SafeArea(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DropdownButton<String>(
                        hint: const Text(
                          'Leave Type',
                          style: TextStyle(fontSize: 20),
                        ),
                        value: _selected_leavetype,
                        onChanged: (newValue) {
                          setState(() {
                            _selected_leavetype = newValue;
                          });
                          print(newValue);
                        },
                        items: _leave_types.map((leavetype) {
                          return DropdownMenuItem(
                            value: leavetype,
                            alignment: Alignment.center,
                            child: Text(
                              leavetype,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }).toList()),
                    GestureDetector(
                      onTap: () => _selectDate(context, _startDateController),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _startDateController,
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context, _endDateController),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _endDateController,
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => onSubmit(context),
                          child: Text('Submit'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
