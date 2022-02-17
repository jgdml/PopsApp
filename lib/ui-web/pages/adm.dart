import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/model/user.dart';
import '../../persistence/firestore/user-repo.dart';

class AdmPage extends StatelessWidget {

  UserRepo userRepo = UserRepo();

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
              ),
              
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
                  //width: double.infinity,
                  width: 1020,
                  height: 700,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 243, 241),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),

                  ),
                  child: Column(
                    children: [
                      Container(
                        
                        // padding: EdgeInsets.only(top:0,bottom: 510, left: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top:50, right: 30),
                              child: Card(
                                child: Container(
                                  width:250,
                                  height: 120,
                                  padding: EdgeInsets.only(top:40),
                                  child: Column(
                                    children: <Widget>[
                                        Text("TOTAL APROVADOS", style: TextStyle(fontSize: 20.0)),
                                        Text("0", style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 41, 209, 47))),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.only(top:50, right: 30),
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.only(
                              //     topRight: Radius.circular(30.0),
                              //     topLeft: Radius.circular(30.0),
                              //     bottomLeft: Radius.circular(30.0),
                              //     bottomRight: Radius.circular(30.0),
                              //   ),
                              // ),
                              child: Card(
                                child: Container(
                                  width:250,
                                  height: 120,
                                  padding: EdgeInsets.only(top:40),
                                  child: Column(
                                    children: <Widget>[
                                        Text("TOTAL REPROVADOS", style: TextStyle(fontSize: 20.0)),
                                        Text("0", style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 255, 17, 0))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            Container(
                              padding: EdgeInsets.only(top:50, right: 30),
                              child: Card(
                                child: Container(
                                  
                                  width:250,
                                  height: 120,
                                  padding: EdgeInsets.only(top:40),
                                  child: Column(
                                    children: <Widget>[
                                        Text("TOTAL EM ANALISE", style: TextStyle(fontSize: 20.0)),
                                        Text("0", style: TextStyle(fontSize: 25.0, color: Color.fromARGB(255, 0, 26, 255))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Container(
                                
                              ),
                            ),

                          ],
                        )
                      ),
                      Column(
                        children: [
                          SizedBox(
                            
                            child: Expanded(
                              child: FutureBuilder(
                                builder: (context, future) {
                                  if (future.connectionState == ConnectionState.none &&
                                      future.hasData == null) {
                                    //print('project snapshot data is: ${projectSnap.data}');
                                    return Container();
                                  }
                                  List<User> users = future.data as List<User>; 
                                  
                                  if(User.STATUS == "P"){
                          
                                  }
                                  return ListView.builder(
                                    itemExtent: 100,
                                    shrinkWrap: true,
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      User user = users[index];
                                      print(user.toJson());
                                      return Container(
                                        // padding: EdgeInsets.only( ottom:10, top: 50),
                                        child: Container(
                                        
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(user.id!),
                                              Text(user.name!),
                                              Text(user.email!),
                                            ],
                                          ),
                                        ),
                                        
                                      );
                                      
                                    },
                                  );
                          
                                  
                                },
                                future: userRepo.findIcemen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                  ),
                  

                  
                                   
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}