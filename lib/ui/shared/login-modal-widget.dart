// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pops_app/ui/shared/register-modal-widget.dart';

import '../../core/model/loginDTO.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({Key? key, this.onLogged}) : super(key: key);
  final Function(LoginDTO)? onLogged;

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  String email = '';
  String password = '';

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
              onPressed: () => widget.onLogged!(LoginDTO(password: password, email: email)),
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
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) =>
                    FractionallySizedBox(heightFactor: 0.85, child: RegisterModal()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                isScrollControlled: true,
              ),
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
