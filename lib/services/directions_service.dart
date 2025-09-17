// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class DirectionsService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> getRoute({
    required String apiKey,
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destLat,$destLng&key=$apiKey";

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data["routes"].isNotEmpty) {
        return response.data;
      }
    } catch (e) {
      print("Error in DirectionsService: $e");
    }
    return null;
  }
}
