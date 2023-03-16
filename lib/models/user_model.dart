import 'dart:convert';

import 'package:chat/utls/url.dart';
import 'package:http/http.dart';

class UserModel {
  int id;
  int connectionId;
  String firstName;
  String lastName;
  String phoneNumber;
  String userName;
  DateTime createdAt;
  DateTime updatedAt;
  String firebaseId;
  String token;

  static UserModel userModel;
  UserModel(
      {this.id,
      this.connectionId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.userName,
      this.firebaseId,
      this.createdAt,
      this.updatedAt,
      this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      connectionId: json['connection_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_no'],
      userName: json['username'],
      firebaseId: json['firebase_id'],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      token: json['token']);

  factory UserModel.fromDynamic(Map<dynamic, dynamic> json) => UserModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        userName: json['userName'],
        firebaseId: json['firebaseId'],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "connectionId": connectionId == null ? null : connectionId,
        "firstName": firstName == null ? null : firstName,
        "lastName": lastName == null ? null : lastName,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "userName": userName == null ? null : userName,
        "firebaseId": firebaseId == null ? null : firebaseId,
        "createdAt": createdAt == null ? null : createdAt,
        "updatedAt": updatedAt == null ? null : updatedAt,
      };

  static Future<Response> signInWithFirebaseToken(String token) async {
    Response res = await post(url + 'signin/phone',
        body: jsonEncode({'access_token': token}),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          // 'Authorization': 'Bearer ' + UserModel.userModel.token
        });
    return res;
  }

  // static Future<Response> signInWithPassword(String phone, String password) async {
  //   Response res = await post(url + 'signin/',
  //       body: jsonEncode({'phone_no': phone,
  //       "password":"password"}),
  //       headers: {
  //         "Content-type": "application/json",
  //         "Accept": "application/json",
  //         // 'Authorization': 'Bearer ' + UserModel.userModel.token
  //       });
  //   return res;
  //}

  static Future<Response> signInWithToken(String token) async {
    Response res = await get(url + 'profile', headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + token
    });
    return res;
  }
}
