import 'dart:convert';
import 'package:http/http.dart' as http;

class Talent {
  final String firstName;
  final String lastName;

  Talent({
    required this.firstName,
    required this.lastName,
  });

  factory Talent.fromJson(Map<String, dynamic> json) {
    return Talent(
      firstName: json['firstName'] ?? 'UNSPECIFIED',
      lastName: json['lastName'] ?? 'UNSPECIFIED',
    );
  }

  static Future<List<Talent>> fetchTalent() async {
    final response = await http.get(Uri.parse('http://localhost:8080/talent'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonList = json.decode(response.body);

        return jsonList.map((e) {
          return Talent.fromJson(e);
        }).toList();
      } on Exception catch (e) {
        throw Exception('Failed to load accounts' + e.toString());
      }
    } else {
      throw Exception('Failed to load accounts');
    }
  }
}
