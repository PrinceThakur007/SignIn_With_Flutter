import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_user/MainPage.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  bool emailValid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final email_data = TextEditingController();
  final password_data = TextEditingController();
  final fullname_data = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Register"),
        // ),
        body: Stack(
      children: [
        Image.network(
          "https://images.pexels.com/photos/931018/pexels-photo-931018.jpeg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Form(
              key: _formkey,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                // color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(hintText: "Full Name"),
                            controller: fullname_data,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please Fill Full name";
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Email"),
                            obscureText: false,
                            controller: email_data,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please fill Your email";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email_data.text)) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Password"),
                            obscureText: true,
                            controller: password_data,
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please fill the password";
                              } else if (val.length < 5) {
                                return "Please set password more than 5 character";
                              } else if (val.length > 10) {
                                return "Please set password less that 10 character";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {
                          _registerAccount();
                        }
                      },
                      child: Text("Register"),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  void _registerAccount() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
            email: email_data.text, password: password_data.text))
        .user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      await user.updateProfile(displayName: fullname_data.text);
      final user1 = _auth.currentUser;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainPage(
                user: user1,
              )));
    }
  }
}