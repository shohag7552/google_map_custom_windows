import 'package:flutter/material.dart';
import 'package:google_map_custom_windows/google_map_custom_windows.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomInfoWindow(),
    );
  }
}

class CustomInfoWindow extends StatefulWidget {
  const CustomInfoWindow({super.key});

  @override
  State<CustomInfoWindow> createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {

  LatLng initPosition = const LatLng(23.794818, 90.416216);
  LatLng fromLocation = const LatLng(23.798054, 90.413459);
  LatLng toLocation = const LatLng(23.789451, 90.419584);
  
  Set<Marker> markers = {};
  late GoogleMapCustomWindowController _googleMapCustomWindowController;

  @override
  void initState() {
    super.initState();
    _googleMapCustomWindowController = GoogleMapCustomWindowController();
  }

  List<Widget> infoWidgets = [
    MyCustomInfoWidget(title: 'From Marker'),
    MyCustomInfoWidget(title: 'To Marker'),
  ];

  List<LatLng> infoPositions = [
    LatLng(23.798054, 90.413459),
    LatLng(23.789451, 90.419584),
  ];

  Future<void> _setFromToMarker() async {
    markers = {};
    Marker fromMarker = Marker(
      markerId: const MarkerId('from_marker'), 
      position: fromLocation,
      onTap: () {
        _googleMapCustomWindowController.addInfoWindow!([MyCustomInfoWidget(title: 'From Marker')], [fromLocation]);
      },
    );
    markers.add(fromMarker);
    
    Marker toMarker = Marker(
      markerId: const MarkerId('to_marker'), position: toLocation,
      onTap: (){
        _googleMapCustomWindowController.addInfoWindow!([MyCustomInfoWidget(title: 'To Marker')], [toLocation]);
      },
    );
    markers.add(toMarker);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Info Window Example'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers,
            initialCameraPosition: CameraPosition(target: initPosition, zoom: 15),
            onMapCreated: (GoogleMapController controller) {
              _setFromToMarker();
              _googleMapCustomWindowController.googleMapController = controller;
              _googleMapCustomWindowController.addInfoWindow!(infoWidgets, infoPositions);
            },
            onTap: (position) {
              _googleMapCustomWindowController.hideInfoWindow!();
            },
            onCameraMove: (CameraPosition cameraPosition) {
              _googleMapCustomWindowController.onCameraMove!();
            },
          ),

          CustomMapInfoWindow(
            controller: _googleMapCustomWindowController,
            offset: const Offset(0, 50),
            height: 40,
            width: 100,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _googleMapCustomWindowController.dispose();
    super.dispose();
  }
}

class MyCustomInfoWidget extends StatelessWidget {
  final String title;
  const MyCustomInfoWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}


