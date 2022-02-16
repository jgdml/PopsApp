// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pops_app/core/model/loginDTO.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/core/model/user.dart';
import 'package:pops_app/persistence/firestore/user-repo.dart';
import 'package:pops_app/ui/shared/login-modal-widget.dart';

import '../../core/model/gender-enum.dart';
import '../../core/model/role-enum.dart';

class HomeController {
  User? _user;
  final UserRepo _userRepo = UserRepo();

  constructor() {
    checkUser();
  }

  checkUser() async {
    var authUser = fb.FirebaseAuth.instance.currentUser;

    if (authUser != null) {
      _user = await _userRepo.findByEmail(authUser.email.toString());
    }
  }

  RoleEnum? getUserRole() {
    return _user?.role;
  }

  void showLoginModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FractionallySizedBox(
          heightFactor: 0.85,
          child: LoginModal(
            onLogged: (login) {
              tryLogin(context, login);
            },
          )),
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
    );
  }

  Future<LatLng> getClientLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    var location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return LatLng(location.latitude, location.longitude);
  }

  docsToUserList(dynamic docs) {
    var users = <User>[];
    docs.forEach((doc) => {
          if (RoleEnumEnumExtension.fromRaw(doc[User.ROLE]) == RoleEnum.ROLE_ICEMAN &&
              StatusEnumExtension.fromRaw(doc[User.STATUS]) != StatusEnum.I)
            {
              users.add(User(
                id: doc.reference.id.toString(),
                active: doc[User.ACTIVE],
                status: StatusEnumExtension.fromRaw(doc[User.STATUS]),
                name: doc[User.NAME],
                username: doc[User.USERNAME],
                gender: GenderEnumExtension.fromRaw(doc[User.GENDER]),
                password: doc[User.PASSWORD],
                urlPhoto: doc[User.URL_PHOTO],
                email: doc[User.EMAIL],
                phoneNumber: doc[User.PHONE_NUMBER],
                role: RoleEnumEnumExtension.fromRaw(doc[User.ROLE]),
                position: LatLng.fromJson(doc[User.POSITION]),
              ))
            }
        });
    return users;
  }

  tryLogin(BuildContext context, LoginDTO login) async {
    try {
      await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login.email!,
        password: login.password!,
      );
      checkUser();
      Navigator.of(context).pop();
    } on fb.FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text(err.toString()),
        ),
      );
    }
  }
}
