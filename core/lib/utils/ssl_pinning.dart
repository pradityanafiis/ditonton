import 'package:core/utils/shared.dart';
import 'package:http/http.dart' as http;

class HttpSslPinning {
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.createLEClient();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
