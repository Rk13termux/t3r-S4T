import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/api_service.dart';
import '../models/script_model.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;

  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ScriptModel> _scripts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchScripts();
  }

  Future<void> _fetchScripts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/scripts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.user?.token ?? ''}', // Usar token si existe
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _scripts = data.map((e) => ScriptModel.fromJson(e)).toList();
        });
      } else {
        _showError('No se pudo obtener los scripts.');
      }
    } catch (e) {
      _showError('Error en la conexión.');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        title: const Text('Tienda de Scripts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchScripts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF3489fe)),
      )
          : _scripts.isEmpty
          ? const Center(
        child: Text(
          'No hay scripts disponibles.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: _scripts.length,
        itemBuilder: (context, index) {
          final script = _scripts[index];
          return Card(
            color: const Color(0xFF262729),
            elevation: 2,
            margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                script.title,
                style: const TextStyle(
                  color: Color(0xFF3489fe),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                script.description ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                script.type == 'free'
                    ? 'Gratis'
                    : '\$${script.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Aquí iría la navegación al detalle del script
                // Puedes usar Navigator.push(context, ...) si deseas.
              },
            ),
          );
        },
      ),
    );
  }
}
