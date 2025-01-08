import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Carrega as variáveis do arquivo .env
  await dotenv.load(fileName: ".env");
  runApp(OnWaterApp());
}

class OnWaterApp extends StatelessWidget {
  const OnWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnWater API Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnWaterScreen(),
    );
  }
}

class OnWaterScreen extends StatefulWidget {
  const OnWaterScreen({super.key});

  @override
  _OnWaterScreenState createState() => _OnWaterScreenState();
}

class _OnWaterScreenState extends State<OnWaterScreen> {
  String _result = '';
  bool _isLoading = false;

  Future<void> fetchWaterData(double latitude, double longitude) async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    final String apiKey = dotenv.env['API_KEY'] ?? '';
    final String apiHost = dotenv.env['API_HOST'] ?? '';

    final url = Uri.parse("https://isitwater-com.p.rapidapi.com/?latitude=$latitude&longitude=$longitude");

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Rapidapi-Key': apiKey,
          'X-Rapidapi-Host': apiHost,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = data['water'] == true ? "Está sobre água." : "Está sobre terra.";
        });
      } else {
        setState(() {
          _result = "Erro ao buscar dados: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Erro ao buscar dados: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OnWater API"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verificar se a localização é água ou terra",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => fetchWaterData(-10.4294517, -45.1695369),
              child: Text("Consultar Localização"),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              Text(
                _result,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
