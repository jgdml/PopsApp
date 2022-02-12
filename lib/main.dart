import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pops_app/core/model/call.dart';
import 'package:pops_app/core/model/gender-enum.dart';
import 'package:pops_app/core/model/role-enum.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/core/model/user.dart';
import 'package:pops_app/persistence/firestore/call-repo.dart';
import 'package:pops_app/persistence/firestore/user-repo.dart';

Future<void> main() async{
    
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    testes(){
        User u = User(
            active: true,
            name: 'teste',
            username: 'teste',
            gender: GenderEnum.M,
            password: 'uga',
            urlPhoto: 'asoduhaso',
            email: 'asdada',
            phoneNumber: '1231231',
            role: RoleEnum.ROLE_USER
        );

        UserRepo userRepo = UserRepo();
        userRepo.saveOrUpdate(u);

        Call c = Call(
            active: true,
            caller: u,
            receiver: u,
            startTime: DateTime.now(),
            endTime:  DateTime.now(),
            status: StatusEnum.A
            
            
        );

        CallRepo callRepo = CallRepo();
        callRepo.saveOrUpdate(c);

    }

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {


        testes();



        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
            ),
            home: Scaffold(
            ),
        );
    }
}
