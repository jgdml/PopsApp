import 'package:flutter/material.dart';
import 'package:pops_app/ui/theme/colors.dart';

class Util {

  gradientIcon(double size, IconData icon) {
    return ShaderMask(
      child: SizedBox(
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            primaryColor,
            secondColor,
          ],
          stops: const [0, 0.55],
        ).createShader(rect);
      },
    );
  }
}
