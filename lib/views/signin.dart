import 'dart:convert';

import 'package:Socraticos/backend/session.dart';
import 'package:Socraticos/views/chat2.dart';
import 'package:Socraticos/views/chatPage.dart';
import 'package:Socraticos/views/signup.dart';
import 'package:Socraticos/widgets/chat.dart';
import 'package:Socraticos/widgets/navbar.dart';
import 'package:Socraticos/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:requests/requests.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: background,
      appBar: appBarMain(context),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if(input.isEmpty){
                    return 'Provide an email';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
                onSaved: (input) => _email = input,
              ),
              TextFormField(
                validator: (input) {
                  if(input.length < 6){
                    return 'Longer password please';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
                onSaved: (input) => _password = input,
                obscureText: true,
              ),
              RaisedButton(
                onPressed: Authenticate,
                child: Text('Sign in'),
              ),
              RaisedButton(
                onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()))},
                child: Text('Sign up'),
              )
            ],
          )
      ),
    );
  }

  Future<String> Authenticate() async {
    String _token = "";
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        print("signed in user");
        user.getIdToken().then((value) =>
        {
          signIn(value.token.toString())

        });
      }
      catch (e) {
        print(e);
      }

    }
  }
  void signIn(String _token) async {

    String url = 'https://socraticos.herokuapp.com/auth/login';

      
      print(_token);
        print(jsonEncode(<String, String>{
          'token': _token,
        }));
        final http.Response response = await http.post(
          'https://socraticos.herokuapp.com/auth/login',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          body: jsonEncode(<String, String>{
            'token': _token,
          }),
        );
//        var r = await Requests.post(url,
//            headers: <String, String>{
//              'Content-Type': 'application/json; charset=UTF-8',
//            },
//            body: <String, String>{
//              'token': _token,
//            },
//            bodyEncoding: RequestBodyEncoding.JSON
//        );

//        print((r.headers));
//        if (r.statusCode == 200) {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationBar()));
//        } else {
//          print("Death occured");
//          print(r.content());
//        }




        if (response.statusCode == 200){
          print("Adding cookies");
          print(response.headers);
          Session.updateCookie(response);
          Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationBar()));
        } else {
          throw Exception("Failed to authenticate user");
        }


    }

}