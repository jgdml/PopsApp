// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pops_app/ui/utils/util.dart';

class FloatingSwitch extends StatefulWidget {
  FloatingSwitch({Key? key, this.icon, required this.onEnable, required this.onDisable}) : super(key: key);

  IconData? icon;
  void Function() onEnable;
  void Function() onDisable;

  @override
  _FloatingSwitchState createState() => _FloatingSwitchState();
}

class _FloatingSwitchState extends State<FloatingSwitch> {
  _FloatingSwitchState();
  final Util util = Util();

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
      child: enabled ? util.gradientIcon(28, widget.icon!) : Icon(widget.icon, size: 28, color: Colors.grey,),
    );
  }
}
