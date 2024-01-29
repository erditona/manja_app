class FishingSpot {
  final String id;
  final String name;
  final String phoneNumber;
  final String topFish;
  final String rating;
  final String openingHour;
  final String description;
  final String image;
  final String address;
  final String longitude;
  final String latitude;

  FishingSpot({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.topFish,
    required this.rating,
    required this.openingHour,
    required this.description,
    required this.image,
    required this.address,
    required this.longitude,
    required this.latitude,
  });

  factory FishingSpot.fromJson(Map<String, dynamic> json) {
    return FishingSpot(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phonenumber'] ?? '',
      topFish: json['topfish'] ?? '',
      rating: json['rating'] ?? '',
      openingHour: json['openinghour'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      address: json['address'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
    );
  }

  // Static method to create a FishingSpot instance from API response
  static FishingSpot fromApiResponse(Map<String, dynamic>? apiResponse) {
    if (apiResponse == null) {
      // Handle null response gracefully, throw an exception or return a default instance
      throw Exception('Null API response');
    }

    if (apiResponse.containsKey('status') &&
        apiResponse.containsKey('message')) {
      // Extract error details from the response
      int status = apiResponse['status'];
      String message = apiResponse['message'];

      // Handle specific error scenarios
      if (status == 400 &&
          message.contains('invalid number of message parts in token')) {
        throw Exception('Invalid number of message parts in token');
      } else {
        // Handle other error scenarios
        throw Exception('API error: Status $status, Message: $message');
      }
    } else if (apiResponse.containsKey('data')) {
      // Extract data from the response
      var responseData = apiResponse['data'];

      return FishingSpot(
        id: responseData?['_id'] ?? '',
        name: responseData?['name'] ?? '',
        phoneNumber: responseData?['phonenumber'] ?? '',
        topFish: responseData?['topfish'] ?? '',
        rating: responseData?['rating'] ?? '',
        openingHour: responseData?['openinghour'] ?? '',
        description: responseData?['description'] ?? '',
        image: responseData?['image'] ?? '',
        address: responseData?['address'] ?? '',
        longitude: responseData?['longitude'] ?? '',
        latitude: responseData?['latitude'] ?? '',
      );
    } else {
      // Handle cases where 'data' key is missing in the response
      throw Exception('Invalid API response format');
    }
  }
}
