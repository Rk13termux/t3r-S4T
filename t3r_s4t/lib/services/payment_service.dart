import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class PaymentService {
  /// Crear orden de pago
  static Future<Map<String, dynamic>> createOrder({
    required String scriptId,
    required double amount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/payments/create-order'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'scriptId': scriptId,
        'amount': amount,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Error al crear la orden de pago.'};
    }
  }

  /// Capturar pago
  static Future<Map<String, dynamic>> captureOrder({
    required String orderId,
    required String userId,
    required String scriptId,
    required double amount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/payments/capture-order'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'orderId': orderId,
        'userId': userId,
        'scriptId': scriptId,
        'amount': amount,
      }),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Error al capturar el pago.'};
    }
  }
}
