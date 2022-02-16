// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FloatingSwitch extends StatefulWidget {
  FloatingSwitch({Key? key, this.icon, this.enabledColor, required this.onEnable, required this.onDisable}) : super(key: key);

  Color? enabledColor;
  IconData? icon;
  void Function() onEnable;
  void Function() onDisable;

  @override
  _FloatingSwitchState createState() => _FloatingSwitchState();
}

class _FloatingSwitchState extends State<FloatingSwitch> {
  _FloatingSwitchState();

  bool enabled = false;

  

  void buttonPress(){
    if (enabled == true){
      widget.onDisable();
      setState(() {
        enabled = false;
      });
    }
    else{
      widget.onEnable();
      setState(() {
        enabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () => buttonPress(),
      child: Icon(widget.icon, color: enabled? widget.enabledColor : Colors.grey,),
    );
  }
}
