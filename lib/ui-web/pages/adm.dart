import 'package:flutter/material.dart';
import 'package:pops_app/ui/theme/colors.dart';

import '../../core/model/status-enum.dart';
import '../../core/model/user.dart';
import '../../persistence/firestore/user-repo.dart';

class AdmPage extends StatefulWidget {
  const AdmPage({Key? key}) : super(key: key);

  @override
  State<AdmPage> createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> {
  UserRepo userRepo = UserRepo();
  User user = User();

  approveOrReject(User user, StatusEnum newStatus) {
    if (user.status == StatusEnum.P) {
      user.status = newStatus;
      userRepo.saveOrUpdate(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 212, 16, 75),
      drawer: Drawer(
        child: ListTile(
          title: Text("POP's ADM BAR "),
          // subtitle: Text("meus favoritos..."),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            //width: double.infinity,
            width: 1020,
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 50, right: 30),
                      child: Card(
                        child: Container(
                          width: 250,
                          height: 120,
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: const <Widget>[
                              Text("TOTAL APROVADOS", style: TextStyle(fontSize: 20.0)),
                              Text("12",
                                  style: TextStyle(
                                      fontSize: 25.0, color: Color.fromARGB(255, 41, 209, 47))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50, right: 30),
                      child: Card(
                        child: Container(
                          width: 250,
                          height: 120,
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: const <Widget>[
                              Text("TOTAL REPROVADOS", style: TextStyle(fontSize: 20.0)),
                              Text("8",
                                  style: TextStyle(
                                      fontSize: 25.0, color: Color.fromARGB(255, 255, 17, 0))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50, right: 30),
                      child: Card(
                        child: Container(
                          width: 250,
                          height: 120,
                          padding: EdgeInsets.only(top: 40),
                          child: Column(
                            children: const <Widget>[
                              Text("TOTAL EM ANALISE", style: TextStyle(fontSize: 20.0)),
                              Text("6",
                                  style: TextStyle(
                                      fontSize: 25.0, color: Color.fromARGB(255, 0, 26, 255))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: SizedBox(
                    child: FutureBuilder(
                      future: userRepo.findIcemen(),
                      builder: (context, future) {
                        if (future.data == null) {
                          //print('project snapshot data is: ${projectSnap.data}');
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else {
                          List<User> users = future.data as List<User>;
                          users.removeWhere((element) => element.status != StatusEnum.P);
                          return ListView.builder(
                            // shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              User user = users[index];
                              debugPrint(user.toJson().toString());
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(user.id!),
                                  Text(user.name!),
                                  Text(user.email!),
                                  TextButton(
                                      child: Text(
                                        'Aprovar',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          approveOrReject(user, StatusEnum.A);
                                        });
                                      }),
                                  TextButton(
                                      child: Text('Rejeitar', style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        setState(() {
                                          approveOrReject(user, StatusEnum.I);
                                        });
                                      }),
                                ],
                              );
                            },
                          );
                        }
                        // if (User.STATUS == "P") {}
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
