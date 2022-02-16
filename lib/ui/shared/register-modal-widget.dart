// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:pops_app/core/model/gender-enum.dart';
import 'package:pops_app/core/model/role-enum.dart';
import 'package:pops_app/core/model/user.dart';
import 'package:pops_app/persistence/firestore/user-repo.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({Key? key}) : super(key: key);

  @override
  _RegisterModalState createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  User user = User();
  String password = '';
  String passwordConf = '';

  tryRegister() async {
    if (user.email == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text("Preencha o email"),
        ),
      );
    }

    if (password != passwordConf) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text("As senhas são diferentes"),
        ),
      );
    }

    try {
      await fb.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email!, password: password)
          .then((_) => trySaveToDB());
    } on fb.FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text(err.toString()),
        ),
      );
    }
  }

  trySaveToDB() async {
    user.role = RoleEnum.ROLE_USER;

    UserRepo userRepo = UserRepo();

    try {
      await userRepo.saveOrUpdate(user);
      Navigator.pop(context);
    } on fb.FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text(err.toString()),
        ),
      );
    }
  }

  String getEnumName(GenderEnum genderEnum) {
    if (genderEnum.value == "M") {
      return "Masculino";
    } else if (genderEnum.value == "F") {
      return "Feminino";
    } else {
      return "Outro";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  "Cadastre-se",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(
                itemExtent: 90,
                children: [
                  TextField(
                    onChanged: (val) => setState(() {
                      user.name = val;
                    }),
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    onChanged: (val) => setState(() {
                      user.username = val;
                    }),
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Nome de usuário",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  DropdownButton(
                    items: GenderEnum.values.map((GenderEnum val) {
                      return DropdownMenuItem<GenderEnum>(
                        value: val,
                        child: Text(
                          getEnumName(val),
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    value: user.gender,
                    onChanged: (val) => setState(() {
                      user.gender = val as GenderEnum;
                    }),
                    hint: Text('Selecione o gênero'),
                    style: TextStyle(fontSize: 18),
                  ),
                  TextField(
                    onChanged: (val) => setState(() {
                      user.phoneNumber = val;
                    }),
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Celular",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  TextField(
                    onChanged: (val) => setState(() {
                      user.email = val;
                    }),
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
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
                  TextField(
                    onChanged: (val) => setState(() {
                      passwordConf = val;
                    }),
                    obscureText: true,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Confirme a senha",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () => tryRegister(),
                child: Text(
                  "Cadastrar-se",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
