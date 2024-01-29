import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manja_app/model/fishingspot_model.dart';
import 'package:manja_app/services/api_services.dart';
import 'package:manja_app/view/screen/detail_page.dart';
import 'package:manja_app/view/screen/user/dashboard_page.dart';

class allSpotPage extends StatefulWidget {
  const allSpotPage({Key? key});

  @override
  State<allSpotPage> createState() => _allSpotPageState();
}

class _allSpotPageState extends State<allSpotPage> {
  late Future<List<FishingSpot>> _fishingSpots;
  late List<String> _carouselImages = [];

  @override
  void initState() {
    super.initState();
    _fishingSpots = ApiService().getFishingSpots();

    // Load carousel images from API
    _fishingSpots.then((spots) {
      setState(() {
        _carouselImages = spots
            .map((spot) => spot.image)
            .take(3)
            .toList(); // Take the first 3 images
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late Future<List<FishingSpot>> _fishingSpots;
    _fishingSpots = ApiService().getFishingSpots();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _fishingSpots = ApiService().getFishingSpots();
          });
        },
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Top Bar
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF87C4FF),
                    ),

                    // Main content
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 28.0,
                        bottom: 14.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserDashboardPage()),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFFFFEED9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Card(
                            elevation: 0.0,
                            margin: EdgeInsets.zero,
                            child: Container(
                              height: 150.0,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF87C4FF),
                                    Colors.white,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(22.0),
                                  bottomRight: Radius.circular(22.0),
                                ),
                              ),
                              child: Image.asset(
                                'assets/ManjaLogo.png',
                                width: 450.0,
                                height: 150.0,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Column(
                              children: [
                                // First Section
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [Colors.blue, Colors.white],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tempat Mancing Favorit',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFFEED9),
                                            shadows: [
                                              Shadow(
                                                color: const Color(0xFF39A7FF)
                                                    .withOpacity(0.5),
                                                offset: const Offset(1.0, 1.0),
                                                blurRadius: 1.0,
                                              ),
                                            ], // Adjust text color as needed
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white, // Your desired color
                                  height: 150.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder<List<FishingSpot>>(
                                      future: _fishingSpots,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text(
                                                'Masih dicari tempat mancingnya..'),
                                          );
                                        } else {
                                          // Reverse the list to display the latest card first
                                          final reversedSpots =
                                              snapshot.data!.reversed.toList();

                                          // Sort the spots based on rating in descending order
                                          final sortedSpots = reversedSpots
                                              .where(
                                                  (spot) => spot.rating != null)
                                              .toList()
                                            ..sort((a, b) => double.parse(
                                                    b.rating)
                                                .compareTo(
                                                    double.parse(a.rating)));

                                          // Display only the latest ... cards
                                          final latestSpots =
                                              sortedSpots.take(5).toList();

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 8.0),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: latestSpots.length,
                                              itemBuilder: (context, index) {
                                                FishingSpot spot =
                                                    latestSpots[index];
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailFishingSpotPage(
                                                                  fishingSpot:
                                                                      spot),
                                                        ),
                                                      );
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        // Image
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            spot.image,
                                                            width: 220.0,
                                                            height: 130.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        // Overlay with name and rating
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      8.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors
                                                                        .transparent,
                                                                    const Color(
                                                                            0xFF39A7FF)
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    spot.name,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        spot.rating,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.amber,
                                                                        ),
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 150.0,
                                )
                              ],
                            ),
                          ),

                          // End of other widgets
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // DraggableScrollableSheet
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.blue, Colors.white],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tempat Mancing Terbaru',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFFEED9),
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFF39A7FF)
                                          .withOpacity(0.5),
                                      offset: const Offset(1.0, 1.0),
                                      blurRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<FishingSpot>>(
                          future: _fishingSpots,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('Masih dicari tempat mancingnya..'),
                              );
                            } else {
                              // Reverse the list to display the latest card first
                              final reversedSpots =
                                  snapshot.data!.reversed.toList();

                              // Display only the latest 10 cards
                              final latestSpots =
                                  reversedSpots.take(10).toList();

                              return ListView.builder(
                                controller: scrollController,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  FishingSpot spot = latestSpots[index];
                                  return Card(
                                    margin: const EdgeInsets.all(8.0),
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFF39A7FF),
                                            Colors.white,
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(12.0),
                                        title: Text(
                                          spot.name,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8.0),
                                            Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.fish,
                                                  color: Colors.blue,
                                                  size: 16.0,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  spot.topFish,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.green,
                                                  size: 18.0,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  spot.address,
                                                  style: const TextStyle(
                                                      fontSize: 14.0),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  spot.rating,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 20.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            spot.image,
                                            width: 80.0,
                                            height: 80.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailFishingSpotPage(
                                                fishingSpot: spot,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
