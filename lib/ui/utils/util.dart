import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/ui/theme/colors.dart';

import '../../core/model/gender-enum.dart';
import '../../core/model/role-enum.dart';
import '../../core/model/user.dart';
import '../../persistence/firestore/user-repo.dart';

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

  generateIcemen(int numberOfIceman) {
    for (int i = 0; i < numberOfIceman; i++) {
      UserRepo().saveOrUpdate(User(
          active: true,
          status: StatusEnum.A,
          email: "iceman_$i@email.com",
          gender: GenderEnum.O,
          name: "Iceman $i",
          password: "sdasdasd",
          phoneNumber: "asdfasdasd",
          role: RoleEnum.ROLE_ICEMAN,
          urlPhoto: "asdasd",
          username: "iceman$i",
          position: LatLng(-23.07993 + i / 1000, -52.46181 + i / 1000)));
    }
  }
}
