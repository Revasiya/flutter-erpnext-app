import 'package:flutter/material.dart';

class LeaveReport extends StatefulWidget {
  const LeaveReport({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LeaveReportState();
  }
}

class _LeaveReportState extends State<LeaveReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 200,
        width: 300,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('leave report')],
        ),
      ),
    );
  }
}
