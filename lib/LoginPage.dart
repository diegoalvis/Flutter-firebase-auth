import 'package:auth_flutter_app/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _phoneController = TextEditingController(text: "+575551112222");
  final _smsCodeController = TextEditingController();

  String verificationId;

  //Place A
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(32),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.grey[200])),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.grey[300])),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Phone Number"),
              controller: _phoneController,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("Get code"),
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                onPressed: () {
                  registerUser(_phoneController.text, context);
                },
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.grey[200])),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: Colors.grey[300])),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "SMS Code"),
              controller: _smsCodeController,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: FlatButton(
                child: Text("Validate code"),
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                onPressed: () {
                  authenticateUser(_smsCodeController.text, context);
                },
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void authenticateUser(String smsCode, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);

    final result = await _auth.signInWithCredential(credential);

    if (result.user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  Future registerUser(String mobile, BuildContext context) async {
    print("Starting...");

    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 10),
      verificationCompleted: (AuthCredential authCredential) {
        _auth.signInWithCredential(authCredential).then((AuthResult result) {
          print("Auto verificado");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      },
      verificationFailed: (AuthException authException) {
        print(authException.message);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: null,
    );
  }
}
