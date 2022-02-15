import 'package:flutter/material.dart';

import 'cadastro.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.only(top:230),
                child: Container(
                  width: 370,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 243, 241),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),

                  ),
                  
                  padding: EdgeInsets.only(top:20, left: 40, right: 40),
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Nome@hotmail.com",
                          labelText: "Email",
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
                                  height: 28,
                                  width: 28,
                                ),
                              )
                            ],
                          ),

                          onPressed: () {

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
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  child: SizedBox(
                                    child: Image.asset("assets/popsicle.png"),
                                    height: 28,
                                    width: 28,
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CadastroPage()),
                              );
                            }
                          )
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