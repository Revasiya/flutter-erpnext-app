import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erpnext/auth/auth_token.dart';
import 'package:intl/intl.dart';

class LeaveApplicationFormScreen extends StatefulWidget {
  final Function onFormSubmitSuccess;

  const LeaveApplicationFormScreen(
      {Key? key, required this.onFormSubmitSuccess})
      : super(key: key);

  @override
  State<LeaveApplicationFormScreen> createState() {
    return _LeaveApplicationFormScreenState();
  }
}

class _LeaveApplicationFormScreenState
    extends State<LeaveApplicationFormScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? _selectedLeaveType;
  final List<String> _leaveTypes = ['Paid Leaves', 'Festival Leave'];

  void onSubmit(BuildContext context) async {
    final from_date = _startDateController.text;
    final to_date = _endDateController.text;

    if (from_date.isEmpty || to_date.isEmpty || _selectedLeaveType == null) {
      _showDialog(context, 'Invalid Input', 'Please fill in all the fields.');
      return;
    }

    var data = json.encode({
      'leave_type': _selectedLeaveType,
      'from_date': from_date,
      'to_date': to_date,
    });
    final String? token = await AuthStorage.getAuthToken();

    // body: json.encode({'date': from_date, 'to_date': to_date}));

    if (token != null) {
      final response = await http.post(
          Uri.parse(
              'https://st-erp.frappe.cloud/api/resource/Leave Application'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Cookie': 'sid=$token'
          },
          body: data);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showDialog(context, 'Success', 'Leave applied');
      } else {
        _showDialog(context, 'Failed', 'Something went wrong');
      }
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

  void clearFormFields() {
    _startDateController.clear();
    _endDateController.clear();
    // Clear other controllers if you have more
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          title: Text(
        'Apply For Leave',
        style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary, fontSize: 20),
      )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
                hint: const Text(
                  'Leave Type',
                  style: TextStyle(fontSize: 20),
                ),
                value: _selectedLeaveType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLeaveType = newValue;
                  });
                  print(newValue);
                },
                items: _leaveTypes.map((leavetype) {
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
            const SizedBox(
              height: 20,
            ),
            const TextField(
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: null,
              maxLines:
                  null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
              expands:
                  true, // If set to true and wrapped in a parent widget like [Expanded] or [SizedBox], the input will expand to fill the parent.
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onSubmit(context);
                  },
                  child: Text('Submit'),
                ),
                TextButton(
                  onPressed: () {
                    clearFormFields();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
