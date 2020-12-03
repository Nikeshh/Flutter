import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter_login_ui/listview_note.dart';

void main() => runApp(MyApp());

class ProfileArguments {
  final String userEmail;
  final String userPassword;

  ProfileArguments(this.userEmail, this.userPassword);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SimpleLogin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Simple Login'),
      onGenerateRoute: (settings) {
        if (settings.name == ProfileActivity.routeName) {
          final ProfileArguments args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return ListViewNote(
                userEmail: args.userEmail,
                userPassword: args.userPassword,
              );
            },
          );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginActivity createState() => LoginActivity();
}

class LoginActivity extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();

  Future userLogin() async{

  // Getting value from Controller
  String email = emailController.text;
  String password = passwordController.text;

  try {

    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    String userId = (user.uid);

    if(userId.length > 0 && userId != null){
          Navigator.pushNamed(
            context,
            ProfileActivity.routeName,
            arguments: ProfileArguments(
              emailController.text,
              passwordController.text,
            ),
          );
    } else {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("UserEmail/UserPassword does not exists"),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      );
    }
  } catch (e){
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(e),
        actions: <Widget>[
          FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
    );
  }
}

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      controller: emailController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: userLogin,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class ProfileActivity extends StatelessWidget {
  static const routeName = '/passArguments';

  final String userEmail;
  final String userPassword;

  ProfileActivity({
    Key key,
    @required this.userEmail,
    @required this.userPassword,
  }) : super(key: key);

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome" + userEmail),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}


