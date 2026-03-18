import 'package:firebase_database/firebase_database.dart';

class IoTService {
  final DatabaseReference _sensorRef = FirebaseDatabase.instance.ref(
    'SensorData',
  );

  Stream<Map<String, dynamic>> getSensorData() {
    return _sensorRef.onValue.map((event) {
      final raw = event.snapshot.value;

      if (raw == null) {
        return {
          "moisture": 0.0,
          "temperature": 0.0,
          "soilDensity": 1.43,
          "ph": 6.8,
          "conductivity": 0.0,
        };
      }

      final sensorMap = Map<String, dynamic>.from(raw as Map);

      final double rawMoisture =
          double.tryParse(sensorMap["moisture"].toString()) ?? 0.0;

      final double ecValue = double.tryParse(sensorMap["ec"].toString()) ?? 0.0;

      // convert moisture raw value (0 - 4095) to percentage
      // 0 = 100% wet, 4095 = 0% wet
      final double moisturePercent = ((4095 - rawMoisture) / 4095) * 100;

      return {
        "moisture": moisturePercent.clamp(0.0, 100.0),

        // you asked to show EC as temperature
        "temperature": ecValue,

        "soilDensity": 1.43,
        "ph": 6.8,
        "conductivity": ecValue,
      };
    });
  }
}
