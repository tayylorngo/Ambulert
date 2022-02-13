import 'dart:convert';
import 'package:http/http.dart' as http;

/// This class is used to collect API data and parse JSON
class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  /// This method is used to parse JSON data from an API
  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
