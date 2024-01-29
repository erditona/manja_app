import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manja_app/services/api_services.dart';
import 'package:manja_app/model/fishingspot_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  late List<FishingSpot> fishingSpotMarkers;

  @override
  void initState() {
    super.initState();
    _fetchFishingSpot();
  }

  void _fetchFishingSpot() async {
    fishingSpotMarkers = await ApiService().getFishingSpots();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta'),
      ),
      body: FutureBuilder<List<FishingSpot>>(
        future: ApiService().getFishingSpots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // atau widget loading lainnya
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            fishingSpotMarkers = snapshot.data!;
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-6.898883760417612, 107.6175856588862),
                zoom: 12,
              ),
              markers: Set<Marker>.from(fishingSpotMarkers.map((spot) {
                return Marker(
                  markerId: MarkerId(spot.id.toString()),
                  position: LatLng(double.parse(spot.latitude),
                      double.parse(spot.longitude)),
                  infoWindow:
                      InfoWindow(title: spot.name, snippet: spot.address),
                );
              })),
            );
          }
        },
      ),
    );
  }
}
