// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pops_app/core/error/login-error.dart';
import 'package:pops_app/core/model/loginDTO.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/core/model/user.dart';
import 'package:pops_app/persistence/firestore/call-repo.dart';
import 'package:pops_app/persistence/firestore/user-repo.dart';
import 'package:pops_app/ui/shared/login-modal-widget.dart';

import '../../core/model/call.dart';
import '../../core/model/gender-enum.dart';
import '../../core/model/role-enum.dart';
import '../utils/constants.dart';

class HomeController {
  User? _user;
  final UserRepo _userRepo = UserRepo();
  final CallRepo _callRepo = CallRepo();

  User? get user => _user;

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

  bool isLoggedIn() {
    return _user != null ? true : false;
  }

  logout() async {
    await fb.FirebaseAuth.instance.signOut();
    _user = null;
  }

  sendIcemanLocation(LatLng pos) {
    _user!.position = pos;
    _userRepo.saveOrUpdate(_user!);
  }

  clearIcemanPosition() {
    _user!.position = LatLng(0, 0);
    _userRepo.saveOrUpdate(user!);
  }

  Future<void> showLoginModal(BuildContext context) async {
    await showModalBottomSheet(
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
    return;
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
          if (doc[User.ROLE] != null &&
              doc[User.STATUS] != null &&
              RoleEnumEnumExtension.fromRaw(doc[User.ROLE]) == RoleEnum.ROLE_ICEMAN &&
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

  docsToCallsList(dynamic docs) {
    var calls = <Call>[];
    docs.forEach((doc) => {
          calls.add(Call(
            id: doc.reference.id.toString(),
            active: doc[Call.ACTIVE],
            receiver: User.fromJson(doc[Call.RECEIVER]),
            caller: User.fromJson(doc[Call.CALLER]),
            startTime:
                doc[Call.START_TIME] != null ? DateTime.parse(doc[Call.START_TIME]).toLocal() : doc[Call.START_TIME],
            endTime: doc[Call.END_TIME] != null ? DateTime.parse(doc[Call.END_TIME]).toLocal() : doc[Call.END_TIME],
            status: StatusEnumExtension.fromRaw(doc[Call.STATUS]),
          ))
        });
    return calls;
  }

  tryLogin(BuildContext context, LoginDTO login) async {
    try {
      await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login.email!,
        password: login.password!,
      );
      await checkUser();

      if (_user!.status == StatusEnum.I) {
        throw LoginError("Sua conta não foi aprovada pela administração");
      }
      if (_user!.status == StatusEnum.P) {
        throw LoginError("A aprovação da sua conta está pendente");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logado com sucesso"),
        ),
      );
      Navigator.of(context).pop();
    } on fb.FirebaseAuthException catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text(err.toString()),
        ),
      );
      logout();
    } on LoginError catch (err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro de Login"),
          content: Text(err.toString()),
        ),
      );
      logout();
    }
  }

  createCall(BuildContext context, List<User> icemen, LatLng userLocation) {
    var closestIceman = icemen.first;

    for (var iceman in icemen) {
      //Se a long + lat do iceman da vez menos a lat + long do user for menor
      // que o salvo na variável então ele está mais perto
      var isClose =
          (iceman.position!.latitude + iceman.position!.longitude) - (userLocation.latitude + userLocation.longitude) <
              (closestIceman.position!.latitude + closestIceman.position!.longitude) -
                  (userLocation.latitude + userLocation.longitude);
      if (isClose) {
        closestIceman = closestIceman;
      }
    }

    var now = DateTime.now();

    _callRepo.saveOrUpdate(Call(
        active: true,
        caller: _user,
        receiver: closestIceman,
        startTime: now,
        endTime: now.add(Duration(minutes: CALL_TIMER)),
        status: StatusEnum.A));
  }
}
