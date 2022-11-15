class CustomerModel {
  String? name;
  String? acno;
  String? city;

  CustomerModel({this.name, this.acno, this.city});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    acno = json['acno'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['acno'] = this.acno;
    data['city'] = this.city;
    return data;
  }
}