// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:pops_app/ui/shared/register-modal-widget.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({Key? key}) : super(key: key);

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  String email = '';
  String password = '';

  tryLogin() async {
    fb.FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .catchError(
          (err) => {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Erro"),
                content: Text(err.toString()),
              ),
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Entre em sua conta",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          TextField(
            onChanged: (val) => setState(() {
              email = val;
            }),
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            onChanged: (val) => setState(() {
              password = val;
            }),
            obscureText: true,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              labelText: "Senha",
              border: OutlineInputBorder(),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: ElevatedButton(
              onPressed: () => tryLogin(),
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: OutlinedButton(
              onPressed: null,
              // () => showModalBottomSheet(context: context, builder: (context) => RegisterModal()),
              child: Text(
                "Não tenho conta",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
