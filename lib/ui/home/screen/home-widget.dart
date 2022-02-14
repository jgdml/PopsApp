// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pops_app/ui/home/home-controller.dart';

import 'home-page.dart';

class HomeWidget extends State<HomeScreen> {
    HomeController _controller = HomeController();

    @override
    Widget build(BuildContext context) {
        _controller.getClientLocation();
        return Stack(
            children: [
                FlutterMap(
                    options: MapOptions(
                        center: LatLng(-23.07993, -52.46181),
                        zoom: 16.0,
                    ),
                    layers: [
                        TileLayerOptions(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                            attributionBuilder: (_) {
                                return Text(
                                    "© OpenStreetMap contributors",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                );
                            },
                        ),
                        MarkerLayerOptions(
                            markers: [
                                Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: LatLng(-23.07993, -52.46181),
                                    builder: (ctx) => Image(
                                        image: AssetImage("assets/popsicle.png"),
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
                Scaffold(
                    drawer: Drawer(
                        child: Center(child: Text("abc")),
                    ),
                    appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.transparent,
                    ),
                    backgroundColor: Colors.transparent,
                    floatingActionButton: FloatingActionButton(
                        onPressed: () => _controller.showLoginModal(context),
                        child: Icon(Icons.center_focus_strong),
                        backgroundColor: Colors.white,
                    ),
                ),
            ],
        );
    }
}
