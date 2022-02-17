import 'package:flutter/material.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/ui-web/pages/login.dart';

import '../../core/model/gender-enum.dart';
import '../../core/model/role-enum.dart';
import '../../core/model/user.dart';
import '../../persistence/firestore/user-repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  User user = User();
  String password = '';
  String passwordConf = '';

  tryRegister() async {

    if (user.email == null) {
      showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text("Preencha o email"),
        ),
      );
    }

    if (password != passwordConf){
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
          .createUserWithEmailAndPassword(
              email: user.email!, password: password)
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
    user.role = RoleEnum.ROLE_ICEMAN;
    user.active = true;
    user.status = StatusEnum.P;

    UserRepo userRepo = UserRepo();

    try {
      await userRepo.saveOrUpdate(user);
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
      backgroundColor: Color.fromARGB(255, 212, 16, 75),
      body: Center(
        child: FractionallySizedBox(

          // widthFactor: 0.5,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:100),
                child: Container(
                  width: 490,
                  height: 490,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 243, 241),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),

                  ),

                  padding: EdgeInsets.only(top: 40, left: 40, right: 40),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.asset("assets/popsicle.png"),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        // autofocus: true,
                        onChanged: (val) => setState(() {
                          user.name = val;
                        }),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Primeiro Nome",
                          labelText: "Nome",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),

                      TextFormField(
                        // autofocus: true,
                        onChanged: (val) => setState(() {
                          user.username = val;
                        }),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Apelido",
                          labelText: "Nome de Usuário",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
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

                      TextFormField(
                        // autofocus: true,
                        onChanged: (val) => setState(() {
                          user.email = val;
                        }),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Exemplo: nome@hotmail.com",
                          labelText: "E-mail",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),

                      TextFormField(
                        // autofocus: true,
                        onChanged: (val) => setState(() {
                          user.phoneNumber = val;
                        }),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "(xx)xxxxxxxxx",
                          labelText: "Telefone",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),

                      TextFormField(
                        // autofocus: true,
                        onChanged: (val) => setState(() {
                          password = val;
                        }),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),


                      TextFormField(
                        // autofocus: true,
                        onChanged: (val) => setState(() {
                          passwordConf = val;
                        }),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirmar Senha",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),

                      SizedBox(
                        height: 40,
                      ),



                      SizedBox(
                        height: 10,
                      ),



                      SizedBox(
                        height: 10,
                      ),   
                    ],
                  ),
                ),
              ),
              //++++++++++++++++++++++++++++  Botao LOGIN +++++++++++++++++++++++++
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 170),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                    height: 60,
                    width: 135,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 1],
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 255, 255, 255),
                        ],
                      ),

                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),

                      child: SizedBox.expand(
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(221, 0, 0, 0),
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),

                              Container(
                                child: SizedBox(
                                  child: Image.asset("assets/popsicle.png"),
                                  height: 25,
                                  width: 25,
                                ),
                              )
                            ],
                          ),

                          onPressed: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                          },
                        ),
                      ),
                    ),

                    //++++++++++++++++++++++++++++  Botao Cadastrar +++++++++++++++++++++++++
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Container(
                        height: 60,
                        width: 135,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 255, 0, 157),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.3, 1],

                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 255, 255, 255),
                            ],
                          ),
                        ),

                        child: SizedBox.expand(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(221, 0, 0, 0),
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  child: SizedBox(
                                    child: Image.asset("assets/popsicle.png"),
                                    height: 25,
                                    width: 25,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () => tryRegister(),
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 