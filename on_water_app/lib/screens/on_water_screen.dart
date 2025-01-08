import 'package:flutter/material.dart';
import 'package:on_water_app/service/api_service.dart';

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

    try {
      final data = await ApiService.fetchWaterData(latitude, longitude);
      setState(() {
        _result = data == true ? "🌊 Localização está sobre água." : "🌍 Localização está sobre terra.";
      });
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
                label: const Text(
                  "Consultar Localização",
                  style: TextStyle(
                    fontSize: 18, // Tamanho da fonte
                    fontWeight: FontWeight.bold, // Negrito
                    color: Colors.blue, // Cor do texto
                  ),
                ),
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
