import 'dart:async';
import 'dart:collection';

import 'package:firulapp/provider/pets.dart';
import 'package:firulapp/src/pets/lost_and_found/found_pet/found_pet_form_step1.dart';
import 'package:firulapp/src/pets/lost_and_found/lost_pet/show_report.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'components/report_option.dart';
import '../../../provider/reports.dart';
import 'lost_pet/lost_pet_form.dart';

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
  static LatLng _initialPosition;
  GoogleMapController _controller;

  void _getUserLocation() async {
    _location = await _locationTracker.getLocation();

    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    setState(() {
      _initialPosition = LatLng(_location.latitude, _location.longitude);
    });
  }

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
    _getUserLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController cntl) async {
    _controller = cntl;
    await Provider.of<Pets>(context, listen: false).fetchFoundPetList();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        new CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(_location.latitude, _location.longitude),
          tilt: 0,
          zoom: 16.5,
        ),
      ),
    );

    var bounds = await _controller
        .getVisibleRegion(); //TODO usar los bounds para obtener los markers
    await Provider.of<Reports>(context, listen: false).fetchReports(
      latitudeMax: 250.0,
      latitudeMin: -250.0,
      longitudeMin: -250.0,
      longitudeMax: 250.0,
    );
    var items = Provider.of<Reports>(context, listen: false).items;

    setState(() {
      _markers = HashSet<Marker>();
      items.forEach((marker) {
        _markers.add(
          Marker(
            markerId: MarkerId("${marker.id}"),
            draggable: false,
            onTap: () async {
              await Navigator.of(context).pushNamed(
                ShowReport.routeName,
                arguments: marker,
              );
              _onMapCreated(_controller);
            },
            icon: marker.reportType == 'MASCOTA_PERDIDA'
                ? lostMarker
                : foundMarker,
            position: LatLng(marker.locationLatitude, marker.locationLongitude),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firulapp'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 16.5,
        ),
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
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        LostPetForm.routeName,
                        arguments: GeographicPoints(
                          "${_location.longitude}",
                          "${_location.latitude}",
                        ),
                      );
                      _onMapCreated(_controller);
                    }),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  child: ReportOption(
                    title: "¡Encontré una mascota!",
                    icon: "assets/icons/foundDog.svg",
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      FoundPetFormStep1.routeName,
                      arguments: GeographicPoints(
                        "${_location.longitude}",
                        "${_location.latitude}",
                      ),
                    );
                    _onMapCreated(_controller);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
