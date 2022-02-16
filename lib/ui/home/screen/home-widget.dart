// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pops_app/core/model/role-enum.dart';
import 'package:pops_app/persistence/firestore/call-repo.dart';
import 'package:pops_app/persistence/firestore/user-repo.dart';
import 'package:pops_app/ui/home/home-controller.dart';
import 'package:pops_app/ui/shared/floating-switch-widget.dart';
import 'package:pops_app/ui/theme/colors.dart';

import '../../../core/model/user.dart';
import '../../utils/constants.dart';
import '../../utils/util.dart';
import 'home-page.dart';

class HomeWidget extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  final MapController mapController = MapController();
  final Util util = Util();

  var calls = [];
  var icemen = <User>[];
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getUser();
  }

  _getUser() async {
    await _controller.checkUser();
    if (_controller.getUserRole() != null && _controller.getUserRole() == RoleEnum.ROLE_ICEMAN) {
      FirebaseFirestore.instance.collection(CallRepo.REPO_NAME).snapshots().listen((event) {
        calls = event.docs;
      });
    }
  }

  Widget _getFloatingButton(BuildContext context) {
    if (_controller.isLoggedIn()) {
      RoleEnum? role = _controller.getUserRole();

      if (role == RoleEnum.ROLE_ICEMAN) {
        return _floatingSwitchButton(context);
      } else if (role == RoleEnum.ROLE_USER) {
        return _floatingCallButton();
      }
    }
    return _floatingLoginButton(context);
  }

  Widget _floatingCallButton() {
    return FloatingActionButton(
      onPressed: () => _controller.createCall(context, icemen, userLocation!),
      child: util.gradientIcon(45, Icons.campaign),
      backgroundColor: Colors.white,
    );
  }

  Widget _floatingSwitchButton(BuildContext context) {
    return FloatingSwitch(
      onEnable: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("GPS ativado"),
          ),
        );
      },
      onDisable: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("GPS desativado"),
          ),
        );
      },
      icon: Icons.gps_fixed,
      enabledColor: Colors.lightGreen,
    );
  }

  Widget _floatingLoginButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await _controller.showLoginModal(context).then((_) {
          setState(() {
            debugPrint("update");
          });
        });
      },
      child: util.gradientIcon(45, Icons.campaign),
      backgroundColor: Colors.white,
    );
  }

  _getUserLocation() async {
    await _controller.getClientLocation().then((value) {
      setState(() {
        userLocation = value;
      });
      mapController.onReady.then((value) => mapController.move(userLocation!, 17));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(UserRepo.REPO_NAME).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        } else {
          debugPrint("Buscou iceman");
          icemen = _controller.docsToUserList(snapshot.data!.docs);
          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: userLocation ?? BRAZIL_LAT_LONG,
                  zoom: 4,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                    attributionBuilder: (_) {
                      return Text(
                        "© OpenStreetMap contributors",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12, decoration: TextDecoration.none),
                      );
                    },
                  ),
                  MarkerLayerOptions(
                    markers: _getMarkers(icemen),
                  ),
                ],
              ),
              Scaffold(
                drawer: Drawer(
                  child: Center(
                      child: ElevatedButton(
                    child: Text("Logout"),
                    onPressed: () async {
                      _controller.logout().then((_) => setState(() {}));
                    },
                  )),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                floatingActionButton: _getFloatingButton(context),
              ),
            ],
          );
        }
      },
    );
  }

  List<Marker> _getMarkers(List<User> icemen) {
    var positions = <LatLng>[];
    var markers = <Marker>[];

    //Provisório
    if (userLocation != null) {
      markers.add(Marker(
          width: 80.0,
          height: 80.0,
          point: userLocation!,
          builder: (ctx) => Icon(
                Icons.place,
                color: Colors.red,
                size: 50,
              )));

      for (var iceman in icemen) {
        if (iceman.position != null) positions.add(iceman.position!);
      }

      for (var position in positions) {
        if ((userLocation!.latitude - position.latitude).abs() < ICEMEN_LOOK_RANGE &&
            (userLocation!.longitude - position.longitude).abs() < ICEMEN_LOOK_RANGE) {
          markers.add(Marker(
              width: 80.0,
              height: 80.0,
              point: position,
              builder: (ctx) => AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    child: Image(
                      image: AssetImage("assets/popsicle.png"),
                    ),
                  )));
        }
      }
    }
    return markers;
  }
}
