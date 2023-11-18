// ignore: file_names

class ERPNextDocument {
  final String status;
  final String employeeName;
  final String name;
  final String fromDate;
  final String toDate;

  ERPNextDocument(
      {required this.status,
      required this.employeeName,
      required this.name,
      required this.toDate,
      required this.fromDate});

  factory ERPNextDocument.fromJson(Map<String, dynamic> json) {
    return ERPNextDocument(
        status: json['status'],
        employeeName: json['employee_name'],
        name: json['name'],
        toDate: json['to_Date'],
        fromDate: json['from_date']);
  }
}
