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

  int? _pending, _approved, _rejected;

  approveOrReject(User user, StatusEnum newStatus, List<User> icemen) {
    if (user.status == StatusEnum.P) {
      user.status = newStatus;
      userRepo.saveOrUpdate(user);
      setState(() {
        _countStatus(icemen);
      });
    }
  }

  _countStatus(List<User> icemen) {
    _pending = 0;
    _rejected = 0;
    _approved = 0;
    for (var iceman in icemen) {
      if (iceman.status == StatusEnum.P) {
        _pending = _pending! + 1;
      } else if (iceman.status == StatusEnum.A) {
        _approved = _approved! + 1;
      } else if (iceman.status == StatusEnum.I) {
        _rejected = _rejected! + 1;
      }
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
                            children: <Widget>[
                              Text("TOTAL APROVADOS", style: TextStyle(fontSize: 20.0)),
                              Text(_approved?.toString() ?? "XXXX",
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
                            children: <Widget>[
                              Text("TOTAL REPROVADOS", style: TextStyle(fontSize: 20.0)),
                              Text(_rejected?.toString() ?? "XXXX",
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
                            children: <Widget>[
                              Text("TOTAL EM ANALISE", style: TextStyle(fontSize: 20.0)),
                              Text(_pending?.toString() ?? "XXXX",
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
                          var pendingList = <User>[];
                          for (var iceman in users) {
                            if(iceman.status == StatusEnum.P){
                              pendingList.add(iceman);
                            }
                          }
                          _countStatus(users);
                          return ListView.builder(
                            // shrinkWrap: true,
                            itemCount: pendingList.length,
                            itemBuilder: (context, index) {
                              User user = pendingList[index];
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
                                          approveOrReject(user, StatusEnum.A, users);
                                        });
                                      }),
                                  TextButton(
                                      child: Text('Rejeitar', style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        setState(() {
                                          approveOrReject(user, StatusEnum.I, users);
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
