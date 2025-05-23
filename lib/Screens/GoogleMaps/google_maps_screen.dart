import 'package:diapce/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.id,
    });

  final double latitude;
  final double longitude;
  final int id;
  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {

  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {

    final Set<Marker> _markers = {
      Marker(
        markerId: const MarkerId('Placa'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: 'Placa - ${widget.id}',
          snippet: 'Ubicación de la placa',
        ),
      ),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '', onPressed: () => Navigator.pop(context), color: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            ),
        ),
      )
    );
  }
}