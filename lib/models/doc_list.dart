// ignore: file_names

class ERPNextDocument {
  final String name;
  final String status;
  final String? fromDate; // Can be null
  final String? toDate; // Can be null

  ERPNextDocument(
      {required this.name, required this.status, this.fromDate, this.toDate});

  factory ERPNextDocument.fromJson(Map<String, dynamic> json) {
    return ERPNextDocument(
      name: json['name'] ?? '', // Provide a default value if null
      status: json['status'] ?? '', // Provide a default value if null
      fromDate: json['from_date'], // Can be null
      toDate: json['to_date'], // Can be null
    );
  }
}
