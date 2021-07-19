import 'dart:convert';
import 'package:http/http.dart' as http;

class Account {
  final String name;
  final String squadManager;
  final String designManager;
  final String btcManager;
  final String ctl;

  Account({
    required this.name,
    required this.squadManager,
    required this.designManager,
    required this.btcManager,
    required this.ctl,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'] ?? 'UNSPECIFIED',
      squadManager: json['squadManager'] ?? 'OPEN',
      designManager: json['designManager'] ?? 'OPEN',
      btcManager: json['btcManager'] ?? 'OPEN',
      ctl: json['ctl'] ?? 'OPEN',
    );
  }

  static Future<List<Account>> fetchAccounts() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/accounts'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> jsonList = json.decode(response.body);

        return jsonList.map((e) {
          return Account.fromJson(e);
        }).toList();
      } on Exception catch (e) {
        throw Exception('Failed to load accounts' + e.toString());
      }
    } else {
      throw Exception('Failed to load accounts');
    }
  }
}
