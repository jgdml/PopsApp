import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pops_app/ui/app-widget.dart';

Future<void> main() async{
    
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCw19SUol3NLPEsRr5EAspmXX-LjSy7HOc", 
        appId: "1:1018922799653:web:4b3aa4ca9ffc856a9f65cc", 
        messagingSenderId: "1018922799653", 
        projectId: "1:1018922799653:web:4b3aa4ca9ffc856a9f65cc"
      )
    );

    runApp(const AppWidget());
}