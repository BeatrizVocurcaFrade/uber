import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class PassengerPanel extends StatefulWidget {
  const PassengerPanel({Key? key}) : super(key: key);

  @override
  State<PassengerPanel> createState() => _PassengerPanelState();
}

class _PassengerPanelState extends State<PassengerPanel> {
  List<String> menuItens = ['Configurações', 'Deslogar'];
  final Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition = const CameraPosition(
      target: LatLng(-19.967744091134854, -43.95664732148595), zoom: 18);

  _logOutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  _addListenerLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      _cameraPosition = CameraPosition(
          target: LatLng(position!.latitude, position.longitude), zoom: 18);
      _moveCamara(_cameraPosition);
    });
  }

  _moveCamara(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  _retrieveLastKnownLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position? position = await Geolocator.getLastKnownPosition();
    setState(() {
      if (position != null) {
        _cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 19);
        _moveCamara(_cameraPosition);
      }
    });
  }

  _selectMenuItem(String item) {
    switch (item) {
      case 'Configurações':
        break;
      case 'Deslogar':
        _logOutUser();
        Navigator.pushReplacementNamed(context, '/');
        break;
      default:
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    _retrieveLastKnownLocation();
    _addListenerLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Uber'),
        actions: [
          PopupMenuButton(
              onSelected: _selectMenuItem,
              itemBuilder: (_) => menuItens
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList()),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
              left: 10,
              bottom: 10,
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.car_crash_outlined),
              )),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(3)),
                child: const TextField(
                  readOnly: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                        ),
                      ),
                      hintText: "Meu Local",
                      hintStyle: TextStyle(color: Colors.black),
                      ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 60,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(3)),
                child: const TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                        ),
                      ),
                      hintText: "Meu Local",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
