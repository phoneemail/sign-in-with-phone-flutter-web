import 'dart:convert';
import 'package:http/http.dart' as http;

class LogoutService {

  final String countryCode = '+91';   //Replace with your country code
  final String phoneNumber = '**********';  //Replace with your phone number
  final String redirectUrl = 'https://example.com'; //Replace with your redirect URL
  final String baseUrl =
      "https://auth.phone.email/sign-in?countrycode=$countryCode&phone_no=$phoneNumber&redirect_url=$redirectUrl";
  Future<String> logOut(
      {String? token,
      String? code,
      String? phone,
      String? redirect_url}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'countrycode': code,
          'phone_no': phone,
          'redirect_url': redirect_url,
          'mode': 'othernum',
          'auth_type': ''
        },
      );
      if (response.statusCode == 200) {
        return '1';
      } else {
        return '';
      }
    } catch (e) {
      print('Error during logout: $e');
      return '';
    }
  }
}
