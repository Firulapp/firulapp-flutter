import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'components/report_item.dart';

class LostAndFoundMap extends StatefulWidget {
  static const routeName = "/map";

  @override
  _LostAndFoundMapState createState() => _LostAndFoundMapState();
}

class _LostAndFoundMapState extends State<LostAndFoundMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  Location _location = Location();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-25.265620626519592, -57.5632423825354),
    zoom: 16.5,
  );

  @override
  void initState() {
    _markers.add(
      Marker(
        markerId: MarkerId("myMarker"),
        draggable: false,
        onTap: () {
          print("myMarker tapped");
        },
        position: LatLng(-25.265620626519592, -57.5632423825354),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firulapp'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        label: Text('Reportar'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        title: Text(
          "Elegir tipo de reporte",
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ReportItem(
                  title: "Mascota Perdida",
                  icon: "assets/icons/medical-check.svg",
                ),
                const SizedBox(
                  height: 8,
                ),
                ReportItem(
                  title: "Mascota Encontrada",
                  icon: "assets/icons/medical-check.svg",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
