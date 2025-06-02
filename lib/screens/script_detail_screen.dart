import 'package:flutter/material.dart';
import '../models/script_model.dart';
import '../services/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ScriptDetailScreen extends StatefulWidget {
  final ScriptModel script;

  const ScriptDetailScreen({super.key, required this.script});

  @override
  State<ScriptDetailScreen> createState() => _ScriptDetailScreenState();
}

class _ScriptDetailScreenState extends State<ScriptDetailScreen> {
  bool _isLoading = false;

  Future<void> _downloadScript() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.script.type == 'free') {
        // Descarga directa
        await _launchURL(widget.script.downloadUrl);
      } else {
        // Crea orden de pago
        final orderResponse = await PaymentService.createOrder(
          scriptId: widget.script.id,
          amount: widget.script.price,
        );

        if (orderResponse['success']) {
          final approvalLink = orderResponse['data']['approvalLink'];
          await _launchURL(approvalLink);
        } else {
          _showError(orderResponse['message'] ?? 'No se pudo crear la orden de pago.');
        }
      }
    } catch (e) {
      _showError('Error en la descarga.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.script.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.script.title,
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF3489fe),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.script.description ?? 'Sin descripción.',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              widget.script.type == 'free'
                  ? 'Este script es gratis.'
                  : 'Precio: \$${widget.script.price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            _isLoading
                ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3489fe)),
            )
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _downloadScript,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3489fe),
                ),
                child: Text(
                  widget.script.type == 'free' ? 'Descargar' : 'Comprar y Descargar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
