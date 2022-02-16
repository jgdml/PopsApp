// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pops_app/core/model/role-enum.dart';
import 'package:pops_app/core/model/status-enum.dart';
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

  var callsDocs = [];
  var icemen = <User>[];
  LatLng? userLocation;
  bool icemanGps = false;
  User? icemanCalled;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _getUser();
  }

  _getUser() async {
    await _controller.checkUser();
    if (_controller.getUserRole() != null && _controller.getUserRole() == RoleEnum.ROLE_ICEMAN) {
      _startFirestoreListener();
      _startLocationListener();
    }
  }

  _startFirestoreListener() {
    FirebaseFirestore.instance.collection(CallRepo.REPO_NAME).snapshots().listen((event) {
      setState(() {
        callsDocs = event.docs;
      });
    });
  }

  _startLocationListener() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 25,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if (position != null) {
        setState(() {
          userLocation = LatLng(position.latitude, position.longitude);
        });
        mapController.move(userLocation!, 17);
        if (icemanGps) {
          _controller.sendIcemanLocation(userLocation!);
        }
      }
    });
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
      onPressed: () async {
        var icemanCalled = await _controller.createCall(context, icemen, userLocation!);
        setState(() {
          this.icemanCalled = icemanCalled;
        });
        // var index = icemen.indexWhere((element) => element.email == icemanCalled.email);
        // if(index != -1){
        //   i
        // }
      },
      child: util.gradientIcon(45, Icons.campaign),
      backgroundColor: Colors.white,
    );
  }

  Widget _floatingSwitchButton(BuildContext context) {
    return FloatingSwitch(
      onEnable: () {
        icemanGps = true;
        _showQuickSnack("GPS ativado", context);
      },
      onDisable: () {
        _controller.clearIcemanPosition();
        icemanGps = false;
        _showQuickSnack("GPS desativado", context);
      },
      icon: Icons.gps_fixed,
    );
  }

  Widget _floatingLoginButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await _controller.showLoginModal(context).then((_) {
          _getUserLocation();
          _getUser();
          setState(() {});
        });
      },
      child: util.gradientIcon(45, Icons.campaign),
      backgroundColor: Colors.white,
    );
  }

  _showQuickSnack(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: 800),
      ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: const [
                            primaryColor,
                            secondColor,
                          ],
                          stops: const [0, 0.55],
                        )),
                        child: !_controller.isLoggedIn()
                            ? null
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration:
                                          BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 50,
                                      )),
                                  Text(
                                    _controller.user!.name!,
                                    style: TextStyle(fontSize: 28, color: Colors.white),
                                  ),
                                  Text(_controller.user!.email!,
                                      style: TextStyle(fontSize: 18, color: Colors.white)),
                                ],
                              ),
                      ),
                      !_controller.isLoggedIn()
                          ? Container()
                          : SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: TextButton.icon(
                                  onPressed: () async {
                                    _controller.logout().then((_) {
                                      _getUserLocation();
                                      _getUser();
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  icon: Icon(Icons.logout),
                                  label: Text(
                                    "Sair",
                                    style: TextStyle(fontSize: 18),
                                  )),
                            )
                    ],
                  ),
                ),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                floatingActionButton: _getFloatingButton(context),
              ),
              _receiveCall(context),
            ],
          );
        }
      },
    );
  }

  Widget _receiveCall(BuildContext context) {
    var calls = _controller.docsToCallsList(callsDocs);
    Widget widget = Container();
    for (var call in calls) {
      if (_controller.user != null && call.receiver!.email == _controller.user!.email) {
        if (call.endTime!.isAfter(DateTime.now()) && call.status != StatusEnum.I) {
          debugPrint("Encontrou receiver " + call.receiver.email);
          widget = Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: primaryColor),
                  borderRadius: BorderRadius.circular(500)),
              child: util.gradientIcon(400, Icons.campaign, startGradient: 0, endGradient: 0.5),
            ),
          );
          break;
        }
      }
    }
    return widget;
  }

  List<Marker> _getMarkers(List<User> icemen) {
    var markers = <Marker>[];

    //Provisório
    if (userLocation != null) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: userLocation!,
          builder: (ctx) => Icon(
            Icons.place,
            color: Colors.red,
            size: 50,
          ),
        ),
      );

      for (var iceman in icemen) {
        if (iceman.position != null) {
          if (_controller.user == null || iceman.email != _controller.user!.email) {
            if ((userLocation!.latitude - iceman.position!.latitude).abs() < ICEMEN_LOOK_RANGE &&
                (userLocation!.longitude - iceman.position!.longitude).abs() < ICEMEN_LOOK_RANGE) {
              var color =
                  icemanCalled != null && iceman.email == icemanCalled!.email ? primaryColor : null;
              markers.add(Marker(
                  width: 80.0,
                  height: 80.0,
                  point: iceman.position!,
                  builder: (ctx) => AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        child: Image(
                          color: color,
                          image: AssetImage("assets/popsicle.png"),
                        ),
                      )));
            }
          }
        }
      }
    }
    return markers;
  }
}
