import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manja_app/services/api_services.dart';
import 'package:manja_app/model/fishingspot_model.dart';
import 'package:manja_app/services/auth_manager.dart';
import 'package:manja_app/view/screen/admin/addFishingspot_page.dart';
import 'package:manja_app/view/screen/admin/editFishingspot_page.dart';
import 'package:manja_app/view/screen/detail_page.dart';
import 'package:manja_app/view/screen/landing_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  ApiService _apiService = ApiService();
  late Future<List<FishingSpot>> _fishingSpots;

  @override
  void initState() {
    super.initState();
    _fishingSpots = _apiService.getFishingSpots();
  }

  Future<void> _refreshData() async {
    setState(() {
      _fishingSpots = _apiService.getFishingSpots();
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

  void _showDeleteConfirmationDialog(BuildContext context, FishingSpot spot) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Anda yakin ingin menghapus spot mancing ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteFishingSpot(spot);
                _refreshData();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFishingSpot(FishingSpot spot) async {
    try {
      // Panggil fungsi deleteFishingSpot dari ApiService
      await _apiService.deleteFishingSpot(spot.id);
    } catch (error) {
      // Handle error
      print('Error deleting fishing spot: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Color(0xFFFFEED9),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<FishingSpot>>(
          future: _fishingSpots,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Masih dicari tempat mancingnya..'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  FishingSpot spot = snapshot.data!.reversed.toList()[index];
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _showDeleteConfirmationDialog(context, spot);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditFishingSpotPage(fishingSpot: spot),
                              ),
                            );
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        title: Text(
                          spot.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: const TextStyle(fontSize: 14.0),
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
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                          borderRadius: BorderRadius.circular(8.0),
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
                                  DetailFishingSpotPage(fishingSpot: spot),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PostFishingSpotPage()),
          );
        },
        tooltip: 'Add Fishing Spot',
        backgroundColor: const Color(0xFF87C4FF),
        child: const Icon(Icons.add),
      ),
    );
  }

}
