import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'components/report_option.dart';
import '../../../provider/reports.dart';
import 'lost_pet_form.dart';

class LostAndFoundMap extends StatefulWidget {
  static const routeName = "/map";

  @override
  _LostAndFoundMapState createState() => _LostAndFoundMapState();
}

class _LostAndFoundMapState extends State<LostAndFoundMap> {
  Set<Marker> _markers = HashSet<Marker>();
  BitmapDescriptor lostMarker;
  BitmapDescriptor foundMarker;
  Location _locationTracker = Location();
  StreamSubscription _locationSubscription;
  LocationData _location;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-25.265620626519592, -57.5632423825354),
    zoom: 16.5,
  );

  void setCustomMarker() async {
    lostMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/pinLost.png',
    );
    foundMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/pinFound.png',
    );
  }

  @override
  void initState() {
    setCustomMarker();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _location = await _locationTracker.getLocation();

    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        new CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(_location.latitude, _location.longitude),
          tilt: 0,
          zoom: 16.5,
        ),
      ),
    );
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;

    ScreenCoordinate northEast = ScreenCoordinate(x: screenWidth.round(), y: 0);
    ScreenCoordinate southWest =
        ScreenCoordinate(x: 0, y: screenHeight.round());
    LatLng northEastPoint = await controller.getLatLng(northEast);
    LatLng southWestPoint = await controller.getLatLng(southWest);
    Provider.of<Reports>(context, listen: false).fetchReports(
      latitudeMax: northEastPoint.latitude,
      latitudeMin: southWestPoint.latitude,
      longitudeMin: southWestPoint.longitude,
      longitudeMax: northEastPoint.longitude,
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("myMarker"),
          draggable: false,
          onTap: () {
            print("myMarker tapped");
          },
          icon: lostMarker,
          position: LatLng(-25.265620626519592, -57.5632423825354),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("myMarker3"),
          draggable: false,
          onTap: () {
            print("myMarker3 tapped");
          },
          icon: foundMarker,
          position: LatLng(-25.2655, -57.5632423825354),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId("myMarker2"),
          draggable: false,
          onTap: () {
            print("myMarker2 tapped");
          },
          icon: foundMarker,
          position: LatLng(-25.2637, -57.5759),
        ),
      );
    });
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
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: _showAddDialog,
        backgroundColor: Color(0xE6FDBE83),
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
                GestureDetector(
                  child: ReportOption(
                    title: "¡Perdí a mi mascota!",
                    icon: "assets/icons/lostDog.svg",
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    LostPetForm.routeName,
                    arguments: GeographicPoints(
                      "${_location.longitude}",
                      "${_location.latitude}",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  child: ReportOption(
                    title: "¡Encontré una mascota!",
                    icon: "assets/icons/foundDog.svg",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
