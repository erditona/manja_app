import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manja_app/model/fishingspot_model.dart';
import 'package:manja_app/services/api_services.dart';
import 'package:manja_app/services/auth_manager.dart';
import 'package:manja_app/view/screen/detail_page.dart';
import 'package:manja_app/view/screen/landing_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:manja_app/view/screen/map_page.dart';
import 'package:manja_app/view/screen/user/allspot_page.dart';
import 'package:manja_app/view/screen/user/info_page.dart';
import 'package:manja_app/view/screen/user/profile_page.dart';
import 'package:manja_app/view/widget/custom_button.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({Key? key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPage();
}

class _UserDashboardPage extends State<UserDashboardPage> {
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                Navigator.pushAndRemoveUntil(
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => const LandingPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
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
                Container(
                  height: 390.0,
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
                      bottomLeft: Radius.circular(24.0),
                      bottomRight: Radius.circular(24.0),
                    ),
                  ),

                  // Main content
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 18.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 26.0,
                              ),
                              child: Row(
                                children: [
                                  // logo
                                  Image.asset(
                                    'assets/ManjaLogo.png',
                                    height: 34.0,
                                    width: 34.0,
                                  ),

                                  const SizedBox(width: 8.0),
                                  Text(
                                    'MANJA',
                                    style: TextStyle(
                                      color: const Color(0xFFFFEED9),
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, top: 19.0),
                              child: IconButton(
                                onPressed: () {
                                  _showLogoutConfirmationDialog(context);
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Color(0xFFFFEED9),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(
                        //         left: 16.0,
                        //         top: 26.0,
                        //       ),
                        //       child: Row(
                        //         children: [
                        //           // logo
                        //           Image.asset(
                        //             'assets/ManjaLogo.png',
                        //             height: 34.0,
                        //             width: 34.0,
                        //           ),

                        //           const SizedBox(width: 8.0),
                        //           Text(
                        //             'Dito',
                        //             style: TextStyle(
                        //               color: const Color(0xFFFFEED9),
                        //               fontSize: 24.0,
                        //               fontWeight: FontWeight.bold,
                        //               shadows: [
                        //                 Shadow(
                        //                   color: const Color(0xFF39A7FF)
                        //                       .withOpacity(0.5),
                        //                   offset: const Offset(1.0, 1.0),
                        //                   blurRadius: 1.0,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Expanded(
                          child: Column(
                            children: [
                              // First Section
                              Container(
                                height: 240.0,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.3), // Warna bayangan
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset:
                                          const Offset(0, 3), // Geser bayangan
                                    ),
                                  ],
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CarouselSlider(
                                        items: _carouselImages.isNotEmpty
                                            ? _carouselImages.map((image) {
                                                return Container(
                                                  height: constraints.maxHeight,
                                                  width: constraints.maxWidth,
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                    image: DecorationImage(
                                                      image:
                                                          NetworkImage(image),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              }).toList()
                                            : [Container()],
                                        options: CarouselOptions(
                                          height: 260.0,
                                          enableInfiniteScroll: true,
                                          viewportFraction: 1.0,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              const Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          pauseAutoPlayOnTouch: true,
                                          aspectRatio: 2.0,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // User Menu
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomIconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MapPage()),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.map,
                                      color: Colors.green,
                                    ),
                                  ),
                                  CustomIconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage()),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.person,
                                      color: Color(0xFF39A7FF),
                                    ),
                                  ),
                                  CustomIconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InfoPage()),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.info,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Second Section
                const SizedBox(height: 6.0),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blue, Colors.white],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
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
                                color: const Color(0xFF39A7FF).withOpacity(0.5),
                                offset: const Offset(1.0, 1.0),
                                blurRadius: 1.0,
                              ),
                            ], // Adjust text color as needed
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const allSpotPage()),
                            );
                          },
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF39A7FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: FutureBuilder<List<FishingSpot>>(
                      future: _fishingSpots,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Loading indicator jika data masih diambil
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Menampilkan pesan error jika terjadi kesalahan
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // Menampilkan pesan jika tidak ada data
                          return const Center(
                              child: Text('Tempat Mancing Belum Dibangun'));
                        } else {
                          // Menampilkan daftar kartu dalam format grid
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Dua item per baris
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: snapshot.data!.length > 6
                                ? 6
                                : snapshot.data!.length,
                            itemBuilder: (context, index) {
                              FishingSpot spot =
                                  snapshot.data!.reversed.toList()[index];

                              // Kartu untuk setiap item
                              return GestureDetector(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          12.0), // Atur sudut menjadi tumpul
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.5), // Warna bayangan
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(
                                              0, 3), // Geser bayangan
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Bagian atas kartu (gambar)
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(12.0)),
                                          child: Image.network(
                                            spot.image,
                                            height: 110.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Bagian bawah kartu (nama dan alamat)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            top: 8.0,
                                            right: 8.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                spot.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                spot.address,
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Row(
                                                children: [
                                                  Text(
                                                    spot.rating,
                                                  ),
                                                  const SizedBox(width: 5.0),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 16.0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
