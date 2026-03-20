import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IoTService {
  final String _databaseUrl =
      'https://archisri-system-default-rtdb.asia-southeast1.firebasedatabase.app/SensorData.json';

  Stream<Map<String, dynamic>> getSensorData() async* {
    print("IoTService: Starting HTTP polling to SensorData...");

    while (true) {
      try {
        final response = await http
            .get(Uri.parse(_databaseUrl))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final raw = jsonDecode(response.body);
          print("IoTService: Raw data = $raw");

          if (raw == null) {
            yield _getDefaultData();
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }

          final sensorMap = Map<String, dynamic>.from(raw as Map);

          final double rawMoisture =
              double.tryParse(sensorMap["moisture"].toString()) ?? 0.0;

          final double ecValue =
              double.tryParse(sensorMap["ec"].toString()) ?? 0.0;

          // convert moisture raw value (0 - 4095) to percentage
          final double moisturePercent = ((4095 - rawMoisture) / 4095) * 100;

          yield {
            "moisture": moisturePercent.clamp(0.0, 100.0),
            "rawMoisture": rawMoisture,
            "temperature": 25.0, // Default temperature value
            "ec": ecValue, // EC value as separate field
            "soilDensity": 1.43,
            "ph": 6.8,
            "conductivity": ecValue,
          };
        } else {
          print("IoTService: HTTP error ${response.statusCode}");
          yield _getDefaultData();
        }
      } catch (e) {
        print("IoTService: Exception polling IoT data: $e");
        yield _getDefaultData();
      }

      // Poll every 2 seconds
      await Future.delayed(const Duration(seconds: 2));
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
