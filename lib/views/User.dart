class User {
  final String? EmployeeCode;
  final String? EmployeeName;
  final String? EmployeeAddress;

  User({this.EmployeeCode, this.EmployeeName, this.EmployeeAddress});

  factory User.fromJson(Map<String, dynamic> json){
    return User(EmployeeCode: json['employeeCode'], EmployeeName: json['employeeName'], EmployeeAddress: json['employeeAddress']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeCode'] = this.EmployeeCode;
    data['EmployeeName'] = this.EmployeeName;
    data['EmployeeAddress'] = this.EmployeeAddress;
    return data;
  }
}