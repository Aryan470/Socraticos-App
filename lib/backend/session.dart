import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Session {
  static Map<String, String> header = <String, String>{
  'Content-Type': 'application/json',
  };

  Future<Map> get(String url) async {
    http.Response response = await http.get(url, headers: header);
    updateCookie(response);
    return json.decode(response.body);
  }

  static Future<http.Response> post(String url, dynamic data) async {
    print("generating post request");

    try{
      final http.Response response = await http.post(url,headers: header,
       body: jsonEncode(data));
      print("header: " + header.toString());
      print("data: " + jsonEncode(data));

      if (response.statusCode == 200) {
        print("success");


      } else {
        print("death");
      }
    } catch (Exception){
      print("response died");
      print(Exception);
    }



  }

  static void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      header['Cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
      print("updated cookie $rawCookie");

    }
    print(header);
  }
}