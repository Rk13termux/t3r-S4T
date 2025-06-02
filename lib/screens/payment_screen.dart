import 'package:flutter/material.dart';
import '../services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final String userId;
  final String scriptId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.userId,
    required this.scriptId,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String? _message;

  Future<void> _capturePayment() async {
    setState(() {
      _isProcessing = true;
      _message = null;
    });

    try {
      final response = await PaymentService.captureOrder(
        orderId: widget.orderId,
        userId: widget.userId,
        scriptId: widget.scriptId,
        amount: widget.amount,
      );

      if (response['success']) {
        setState(() {
          _message = '¡Pago confirmado! Ahora puedes descargar tu script.';
        });
      } else {
        setState(() {
          _message = response['message'] ?? 'Error al confirmar el pago.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error al procesar el pago.';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _capturePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmación de Pago')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isProcessing
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF3489fe)),
        )
            : _message != null
            ? Center(
          child: Text(
            _message!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
            : const SizedBox(),
      ),
    );
  }
}
