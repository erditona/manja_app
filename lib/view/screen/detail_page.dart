import 'package:flutter/material.dart';
import 'package:manja_app/model/fishingspot_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailFishingSpotPage extends StatefulWidget {
  final FishingSpot fishingSpot;

  const DetailFishingSpotPage({super.key, required this.fishingSpot});

  @override
  State<DetailFishingSpotPage> createState() => _DetailFishingSpotPageState();
}

class _DetailFishingSpotPageState extends State<DetailFishingSpotPage> {
  @override
  Widget build(BuildContext context) {
    double latitude = double.parse(widget.fishingSpot.latitude);
    double longitude = double.parse(widget.fishingSpot.longitude);

    final pFishingspot = LatLng(latitude, longitude);
    final pSetView = LatLng(latitude, longitude);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.fishingSpot.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          widget.fishingSpot.name,
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        // ... Other information sections
                        // Use ListTile for a cleaner look
                        ListTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: Text('Rating: ${widget.fishingSpot.rating}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.fish,
                              color: Colors.blue),
                          title: Text('Top Fish: ${widget.fishingSpot.topFish}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.blue),
                          title: Text(
                              'Phone Number: ${widget.fishingSpot.phoneNumber}'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.access_time,
                              color: Colors.orange),
                          title: Text(
                              'Opening Hour: ${widget.fishingSpot.openingHour}'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.location_on,
                              color: Colors.green),
                          title: Text('Address: ${widget.fishingSpot.address}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.description,
                              color: Colors.green),
                          title: Text(
                              'Description: ${widget.fishingSpot.description}'),
                        ),
                        const Divider(),

                        // Map Section
                        const SizedBox(height: 16.0),
                        const ListTile(
                          leading: Icon(Icons.map, color: Colors.blue),
                          title: Text('Google Maps'),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          height: 200.0, // Adjust the height as needed
                          child: GoogleMap(
                            initialCameraPosition:
                                CameraPosition(target: pSetView, zoom: 14),
                            markers: {
                              Marker(
                                markerId: const MarkerId('fishingSpot'),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueAzure,
                                ),
                                position: pFishingspot,
                                infoWindow: InfoWindow(
                                  title: widget.fishingSpot.name,
                                  snippet: widget.fishingSpot.address,
                                ),
                              ),
                            },
                          ),
                        ),
                        const SizedBox(height: 80.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
