// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manja_app/services/api_services.dart';
import 'package:manja_app/services/auth_manager.dart';
import 'package:manja_app/view/screen/admin/dashboard_page.dart';
import 'package:manja_app/view/widget/text_field_builder.dart';

class PostFishingSpotPage extends StatefulWidget {
  const PostFishingSpotPage({Key? key}) : super(key: key);

  @override
  _PostFishingSpotPageState createState() => _PostFishingSpotPageState();
}

class _PostFishingSpotPageState extends State<PostFishingSpotPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController openingHourController = TextEditingController();
  final TextEditingController topFishController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  File? _selectedImage;
  LatLng _selectedLatLng = const LatLng(-6.902269122629447, 107.61873398154628);
  bool _isLoading = false;

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  void _postFishingSpot() async {
    try {
      if (!_validateInputs()) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      String? token = await AuthManager.getToken();

      if (token == null) {
        _showErrorAlert('You are not authenticated');
        return;
      }

      ApiService apiService = ApiService();

      Map<String, dynamic> postData = {
        'name': nameController.text,
        'description': descriptionController.text,
        'phoneNumber': phoneNumberController.text,
        'rating': ratingController.text,
        'openingHour': openingHourController.text,
        'topFish': topFishController.text,
        'address': addressController.text,
        'latitude': latitudeController.text,
        'longitude': longitudeController.text,
        'image': _selectedImage,
      };

      Map<String, dynamic> apiResponse = await apiService.postFishingSpot(
        address: postData['address'],
        description: postData['description'],
        image: postData['image'],
        latitude: postData['latitude'],
        longitude: postData['longitude'],
        name: postData['name'],
        openingHour: postData['openingHour'],
        phoneNumber: postData['phoneNumber'],
        rating: postData['rating'],
        topFish: postData['topFish'],
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();

      if (apiResponse['status'] == 201) {
        _showSuccessAlert('${apiResponse['message']}');
      } else {
        _showErrorAlert(
            'Failed to post Fishing Spot: ${apiResponse['message']}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      print('Error posting Fishing Spot: $error');
      _showErrorAlert('FAIL: $error');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Menambahkan Fishing Spot...'),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearInputs();
                _navigateToNextPage();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {}

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
      latitudeController.text = latLng.latitude.toString();
      longitudeController.text = latLng.longitude.toString();
    });
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        ratingController.text.isEmpty ||
        openingHourController.text.isEmpty ||
        topFishController.text.isEmpty ||
        addressController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        _selectedImage == null) {
      _showErrorAlert('Lengkap Semua Data');
      return false;
    }

    // Validate Name: Each word should start with a capital letter
    if (!RegExp(r'^[A-Z][a-zA-Z ]+[ ][A-Z][a-zA-Z ]+$')
        .hasMatch(nameController.text)) {
      _showErrorAlert('Kesalahan Format Nama (Contoh: "Budi Wati")');
      return false;
    }

    // Validate Phone Number: Should start with '62' and contain 8-13 digits
    if (!RegExp(r'^62[0-9]{8,13}$').hasMatch(phoneNumberController.text)) {
      _showErrorAlert(
          'Kesalahan Format Nomor Telepon (Contoh: "628123456789")');
      return false;
    }

    // Validate Rating: Should be a number between 0 and 5
    double rating = double.tryParse(ratingController.text) ?? -1;
    if (rating < 0 || rating > 5) {
      _showErrorAlert('Kesalah Format Rating, Rating 1-5 (Contoh: "4.5")');
      return false;
    }

    // Validate Description: First letter of the first word should be a capital letter, and length should be <= 200
    if (!RegExp(r'^[A-Z].{0,50}$').hasMatch(descriptionController.text)) {
      _showErrorAlert(
          'Kesalahan Format Deskripsi (Contoh: "Pemancing pa budi wati")');
      return false;
    }

    // Validate Address length
    if (!RegExp(r'^[A-Z].{0,50}$').hasMatch(addressController.text)) {
      _showErrorAlert('Kesalahan Format Alamat (Contoh: "Jl. Kenangan No. 1")');
      return false;
    }

    return true;
  }

  void _clearInputs() {
    nameController.clear();
    descriptionController.clear();
    phoneNumberController.clear();
    ratingController.clear();
    openingHourController.clear();
    topFishController.clear();
    addressController.clear();
    latitudeController.clear();
    longitudeController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  void _navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Fishing Spot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField(nameController, 'Name', TextInputType.text),
              buildTextField(descriptionController, 'Description',
                  TextInputType.multiline),
              buildTextField(
                  phoneNumberController, 'Phone Number', TextInputType.phone),
              buildTextField(ratingController, 'Rating',
                  const TextInputType.numberWithOptions(decimal: true)),
              buildTextField(
                  openingHourController, 'Opening Hour', TextInputType.text),
              buildTextField(topFishController, 'Top Fish', TextInputType.text),
              buildTextField(
                  addressController, 'Address', TextInputType.streetAddress),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: const Text('Pilih Foto'),
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
                child: const Text('Ambil Foto'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Grey background
                      Container(
                        height: 150,
                        width: 370,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                      ),

                      // Display selected image or camera icon
                      _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 145,
                              width: 370,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: Colors.grey,
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildTextField(latitudeController, 'Latitude',
                  const TextInputType.numberWithOptions(decimal: true)),
              buildTextField(longitudeController, 'Longitude',
                  const TextInputType.numberWithOptions(decimal: true)),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTap,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLatLng,
                    zoom: 13,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('selectedLocation'),
                      position: _selectedLatLng,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                    ),
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _postFishingSpot();
                  if (_isLoading) {
                    _showLoadingDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Set button color
                ),
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
