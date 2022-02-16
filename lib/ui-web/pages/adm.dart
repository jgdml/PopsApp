import 'package:flutter/material.dart';

class AdmPage extends StatelessWidget {
  const AdmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 212, 16, 75),

        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("POP's ADM BAR "),
                // subtitle: Text("meus favoritos..."),
              )
            ],

          ),
        ),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
      ),

      body: Center(
        child: FractionallySizedBox(

          // widthFactor: 0.5,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: Container(
                  width: double.infinity,
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


                    ],
                  ),
                ),
              ),
              //++++++++++++++++++++++++++++  Botao LOGIN +++++++++++++++++++++++++
            ],
          ),
        ),
      ),
    );
  }
}