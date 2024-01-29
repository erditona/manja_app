import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:manja_app/model/fishingspot_model.dart';
import 'package:manja_app/model/login_model.dart';
import 'package:manja_app/model/profile_model.dart';
import 'package:manja_app/model/register_model.dart';
import 'package:manja_app/services/auth_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio = Dio();

  final String baseUrl =
      "https://asia-southeast2-keamanansistem.cloudfunctions.net";

  // Function to get the token from AuthManager
  Future<String?> getToken() {
    return AuthManager.getToken();
  }

  Future<List<FishingSpot>> getFishingSpots() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/fishingspot'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 200) {
          List<dynamic> spotsData = data['data'];
          List<FishingSpot> fishingSpots =
              spotsData.map((spot) => FishingSpot.fromJson(spot)).toList();
          return fishingSpots;
        } else {
          throw Exception(
              "Failed to get fishing spots. Status: ${data['status']}, Message: ${data['message']}");
        }
      } else {
        throw Exception(
            "Failed to get fishing spots. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get fishing spots. Error: $e");
    }
  }

  Future<Map<String, dynamic>> updateFishingSpot({
    required String id,
    required String name,
    required String rating,
    required String topFish,
    required String phoneNumber,
    required String openingHour,
    required String address,
    required String description,
    required String latitude,
    required String longitude,
    required dynamic image,
  }) async {
    try {
      // Get token from AuthManager
      String? token = await getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      MultipartFile? imageFile;
      if (image is File) {
        imageFile = await MultipartFile.fromFile(image.path);
      } else if (image is String) {
        imageFile = MultipartFile.fromString(image);
      }

      // Create FormData for the request
      FormData formData = FormData.fromMap({
        'name': name,
        'rating': rating,
        'topfish': topFish,
        'phonenumber': phoneNumber,
        'openinghour': openingHour,
        'address': address,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'file': imageFile,
      });

      // Make the PUT request using Dio
      Response response = await dio.put(
        '$baseUrl/fishingspot?id=$id',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': token,
          },
        ),
      );

      // Parse and return the response data
      return json.decode(response.toString());
    } catch (error) {
      // Handle the error
      print('Error in updateFishingSpot: $error');
      rethrow;
    }
  }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$baseUrl/login-manja',
        data: login.toJson(),
      );
      print(response.data);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.data));
      }
      return null;
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      // Create RegisterInput model
      RegisterModel registerInput = RegisterModel(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );

      // Make the POST request using Dio
      Response response = await dio.post(
        '$baseUrl/register-manja',
        data: registerInput.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Parse and return the response data
      return json.decode(response.toString());
    } catch (error) {
      // Handle the error
      print('Error in register: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postFishingSpot({
    required String name,
    required String rating,
    required String topFish,
    required String phoneNumber,
    required String openingHour,
    required String address,
    required String description,
    required String latitude,
    required String longitude,
    required File image,
  }) async {
    try {
      // Get token from AuthManager
      String? token = await getToken();

      if (token == null) {
        // Handle the case where the token is null (not authenticated)
        throw Exception('User not authenticated');
      }

      // Create FormData for the request
      FormData formData = FormData.fromMap({
        'name': name,
        'rating': rating,
        'topfish': topFish,
        'phonenumber': phoneNumber,
        'openinghour': openingHour,
        'address': address,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'file': await MultipartFile.fromFile(image.path),
      });

      // Make the POST request using Dio
      Response response = await dio.post(
        '$baseUrl/fishingspot',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': token,
          },
        ),
      );

      // Parse and return the response data
      return json.decode(response.toString());
    } catch (error) {
      // Handle the error
      print('Error in postFishingSpot: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteFishingSpot(String id) async {
    try {
      // Get token from AuthManager
      String? token = await getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Make the DELETE request using Dio
      Response response = await dio.delete(
        '$baseUrl/fishingspot?id=$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
        ),
      );

      // Parse and return the response data
      return response.data;
    } catch (error) {
      // Handle the error
      print('Error in deleteFishingSpot: $error');
      rethrow;
    }
  }

  Future<Profile> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? $token = prefs.getString('token');
      // String? token = await AuthManager.getToken();

      if ($token == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.get(
        '$baseUrl/user-manja',
        options: Options(
          headers: {
            'Authorization': $token,
          },
        ),
      );

      if (response.statusCode == 200) {
        final profile = Profile.fromJson(jsonDecode(response.data)['data']);
        print(response.data);
        print($token);
        return profile;
      } else {
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return Profile.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
