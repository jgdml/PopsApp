import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pops_app/ui/app-widget.dart';

Future<void> main() async{
    
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    runApp(const AppWidget());
}