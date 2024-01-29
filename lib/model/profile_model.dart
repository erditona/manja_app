class Profile {
  final String id;
  final String namalengkap;
  final String phonenumber;
  final String email;
  final String password;

  Profile({
    required this.id,
    required this.namalengkap,
    required this.phonenumber,
    required this.email,
    required this.password,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      namalengkap: json['nama_lengkap'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

class ProfileResponse {
  final List<ProfileResponse> data;
  final String message;
  final int status;

  ProfileResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  static Profile fromApiResponse(Map<String, dynamic>? apiResponse) {
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

      return Profile(
        id: responseData['id'] ?? '',
        namalengkap: responseData['nama_lengkap'] ?? '',
        phonenumber: responseData['phonenumber'] ?? '',
        email: responseData['email'] ?? '',
        password: responseData['password'] ?? '',
      );
    } else {
      // Handle cases where 'data' key is missing in the response
      throw Exception('Invalid API response format');
    }
  }
}
