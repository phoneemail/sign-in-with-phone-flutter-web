import 'package:http/http.dart' as http;

class EmailCountService {
  final String apiUrl = 'https://eapi.phone.email/email-count';
  Future<String> getEmailCount(String jwtToken) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'merchant_phone_email_jwt': jwtToken},
      );
      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw Exception('Failed to load email count');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load email count');
    }
  }
}
