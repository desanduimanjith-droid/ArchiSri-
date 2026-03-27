import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class IoTService {
  IoTService({http.Client? client, String? databaseUrl, Duration? pollInterval})
      : _client = client ?? http.Client(),
        _databaseUrl = databaseUrl ??
            'https://archisri-system-default-rtdb.asia-southeast1.firebasedatabase.app/SensorData.json',
        _pollInterval = pollInterval ?? const Duration(seconds: 2);

  final http.Client _client;
  final String _databaseUrl;
  final Duration _pollInterval;

  Stream<Map<String, dynamic>> getSensorData() async* {
    debugPrint("IoTService: Starting HTTP polling to SensorData...");

    while (true) {
      yield await fetchSensorDataOnce();

      await Future.delayed(_pollInterval);
    }
  }

  Future<Map<String, dynamic>> fetchSensorDataOnce() async {
    try {
      final response = await _client
          .get(Uri.parse(_databaseUrl))
          .timeout(const Duration(seconds: 5));

      return parseResponse(response);
    } catch (e) {
      debugPrint("IoTService: Exception polling IoT data: $e");
      return _getDefaultData();
    }
  }

  Map<String, dynamic> parseResponse(http.Response response) {
    try {
      if (response.statusCode != 200) {
        debugPrint("IoTService: HTTP error ${response.statusCode}");
        return _getDefaultData();
      }

      final raw = jsonDecode(response.body);
      debugPrint("IoTService: Raw data = $raw");

      if (raw == null || raw is! Map) {
        return _getDefaultData();
      }

      final sensorMap = Map<String, dynamic>.from(raw);

      final double rawMoisture =
          double.tryParse(sensorMap["moisture"].toString()) ?? 0.0;
      final double ecValue = double.tryParse(sensorMap["ec"].toString()) ?? 0.0;
      final double temperature =
          double.tryParse(sensorMap["temperature"].toString()) ?? 25.0;

      final double moisturePercent = (rawMoisture / 4095) * 100;

      return {
        "moisture": moisturePercent.clamp(0.0, 100.0),
        "rawMoisture": rawMoisture,
        "temperature": temperature,
        "ec": ecValue,
        "soilDensity": 1.43,
        "ph": 6.8,
        "conductivity": ecValue,
      };
    } catch (e) {
      debugPrint("IoTService: Error parsing response: $e");
      return _getDefaultData();
    }
  }

  Map<String, dynamic> _getDefaultData() {
    return {
      "moisture": 0.0,
      "rawMoisture": 0.0,
      "temperature": 0.0,
      "ec": 0.0,
      "soilDensity": 1.43,
      "ph": 6.8,
      "conductivity": 0.0,
    };
  }
}
