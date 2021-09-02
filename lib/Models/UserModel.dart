import 'CompanyModel.dart';

class UserModel {
  String token;
  String id;
  String firstName;
  String lastName;
  String? phoneNumber;
  String? email;
  String userName;
  int userType;
  CompanyModel company;

  UserModel({
    required this.token,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.userName,
    required this.userType,
    required this.company
  });

  factory UserModel.fromJson(dynamic json) => UserModel(
    token:       json["token"],
    id:          json["id"],
    firstName:   json["firstName"],
    lastName:    json["lastName"],
    phoneNumber: json["phoneNumber"],
    email:       json["email"],
    userName:    json["userName"],
    userType:    json["userType"],
    company: CompanyModel.fromJson(json["company"]),
  );
}