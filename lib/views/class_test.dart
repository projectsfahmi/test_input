class Blog{
  final int userid;
  final int id;
  final String title;

  Blog({
    required this.userid,
    required this.id,
    required this.title
  });

  factory Blog.fromJson(Map<String, dynamic> json){
    return Blog(userid: json['userId'], id: json['id'], title: json['title']);
  }
}


class Employee{
  final String? EmployeeCode;
  final String? EmployeeName;
  final String? EmployeeAddress;

  Employee({
    required this.EmployeeCode,
    required this.EmployeeName,
    required this.EmployeeAddress
  });

  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(EmployeeCode: json['employeeCode'], EmployeeName: json['employeeName'], EmployeeAddress: json['employeeAddress']);
  }

  Map<String, dynamic> toJson() => {
    "employeeCode": EmployeeCode,
    "employeeName": EmployeeName,
    "employeeAddress": EmployeeAddress
  };
}

