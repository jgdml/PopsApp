import 'package:flutter/material.dart';
import 'package:pops_app/ui/splash-screen/splash-screen.dart';
import 'package:pops_app/ui/theme/texts.dart';

import 'theme/colors.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  _AppWidget createState() => _AppWidget();
}

class _AppWidget extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Open Sans',
          textTheme: customTextTheme,
          primaryColor: primaryColor,
          dividerColor: dividerColor,
          accentColor: accentColor),
      home: SplashScreenApp(),
    );
  }
}
