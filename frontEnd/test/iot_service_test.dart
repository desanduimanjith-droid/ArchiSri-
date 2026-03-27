import 'dart:convert';

import 'package:archisri_1/iot_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('IoTService.parseResponse', () {
    test('maps valid payload to normalized sensor data', () {
      final service = IoTService();
      final response = http.Response(
        jsonEncode({'moisture': 2047, 'ec': 1.75}),
        200,
      );

      final result = service.parseResponse(response);

      expect(result['rawMoisture'], 2047.0);
      expect(result['ec'], 1.75);
      expect(result['conductivity'], 1.75);
      expect(result['temperature'], 25.0);
      expect((result['moisture'] as num).toDouble(), closeTo(50.01, 0.1));
    });

    test('returns default data when backend returns null body', () {
      final service = IoTService();
      final response = http.Response('null', 200);

      final result = service.parseResponse(response);

      expect(result['moisture'], 0.0);
      expect(result['rawMoisture'], 0.0);
      expect(result['temperature'], 0.0);
      expect(result['ec'], 0.0);
      expect(result['conductivity'], 0.0);
    });

    test('returns default data on non-200 responses', () {
      final service = IoTService();
      final response = http.Response('server down', 500);

      final result = service.parseResponse(response);

      expect(result['moisture'], 0.0);
      expect(result['rawMoisture'], 0.0);
      expect(result['ec'], 0.0);
    });
  });

  group('IoTService.fetchSensorDataOnce', () {
    test('returns parsed values for successful http response', () async {
      final client = MockClient((_) async {
        return http.Response(jsonEncode({'moisture': 0, 'ec': 3.2}), 200);
      });

      final service = IoTService(client: client);
      final result = await service.fetchSensorDataOnce();

      expect(result['rawMoisture'], 0.0);
      expect(result['ec'], 3.2);
      expect(result['moisture'], 0.0);
    });

    test('returns default data when http client throws', () async {
      final client = MockClient((_) async {
        throw Exception('network error');
      });

      final service = IoTService(client: client);
      final result = await service.fetchSensorDataOnce();

      expect(result['moisture'], 0.0);
      expect(result['rawMoisture'], 0.0);
      expect(result['temperature'], 0.0);
      expect(result['ec'], 0.0);
    });

    test('stream emits parsed item as first value', () async {
      final client = MockClient((_) async {
        return http.Response(jsonEncode({'moisture': 1000, 'ec': 2.4}), 200);
      });

      final service = IoTService(
        client: client,
        pollInterval: const Duration(milliseconds: 1),
      );

      final first = await service.getSensorData().first;

      expect(first['rawMoisture'], 1000.0);
      expect(first['ec'], 2.4);
      expect((first['moisture'] as num).toDouble(), greaterThan(0.0));
    });
  });
}
