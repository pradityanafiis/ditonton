import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class Shared {
  static Future<HttpClient> customHttpClient() async {
    SecurityContext _securityContext = SecurityContext(withTrustedRoots: false);

    try {
      final List<int> _bytes =
          (await rootBundle.load('certificates/api.themoviedb.org.crt'))
              .buffer
              .asUint8List();

      _securityContext.setTrustedCertificatesBytes(_bytes);
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('createHttpClient() - cert already trusted! Skipping.');
      } else {
        log('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
        rethrow;
      }
    } catch (e) {
      log('unexpected error $e');
      rethrow;
    }

    HttpClient httpClient = HttpClient(context: _securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return httpClient;
  }

  static Future<http.Client> createLEClient() async =>
      IOClient(await Shared.customHttpClient());
}
