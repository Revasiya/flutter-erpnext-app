
class LoginResponse {
  String? message;
  String? homePage;
  String? fullName;

  LoginResponse({this.message, this.homePage, this.fullName});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["home_page"] is String) {
      homePage = json["home_page"];
    }
    if(json["full_name"] is String) {
      fullName = json["full_name"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["home_page"] = homePage;
    _data["full_name"] = fullName;
    return _data;
  }
}