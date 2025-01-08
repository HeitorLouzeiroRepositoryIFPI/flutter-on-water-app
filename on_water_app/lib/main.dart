import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const OnWaterApp());
}

class OnWaterApp extends StatelessWidget {
  const OnWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnWater App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      home: const OnWaterScreen(),
    );
  }
}

class OnWaterScreen extends StatefulWidget {
  const OnWaterScreen({super.key});

  @override
  State<OnWaterScreen> createState() => _OnWaterScreenState();
}

class _OnWaterScreenState extends State<OnWaterScreen> {
  String _result = '';
  bool _isLoading = false;
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

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
          _result = data['water'] == true ? "🌊 Localização está sobre água." : "🌍 Localização está sobre terra.";
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
        title: const Text("OnWater API"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.water_drop_outlined,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                "Verifique se uma localização está sobre água ou terra",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Latitude",
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Longitude",
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_searching),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  final latitude = double.tryParse(_latitudeController.text);
                  final longitude = double.tryParse(_longitudeController.text);

                  if (latitude == null || longitude == null) {
                    setState(() {
                      _result = "Por favor, insira valores válidos para latitude e longitude.";
                    });
                    return;
                  }

                  fetchWaterData(latitude, longitude);
                },
                icon: const Icon(Icons.search),
                label: const Text("Consultar Localização"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
