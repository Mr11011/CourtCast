import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/data_source/history_data.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    userEmail = await getUserEmail();
    setState(() {});
  }



  Future<List<Map<String, dynamic>>> _getPredictionHistory() async {
    if (userEmail == null) return [];
    final dbHelper = DatabaseHelper();
    return await dbHelper.getUserHistory(userEmail!);
  }

  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> item) {
    // Parse the date
    DateTime date = DateTime.parse(item['date']);

    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    Map<String, dynamic> weather = jsonDecode(item['weather']);

    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          // Handle item tap for more details or actions
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prediction: ${item['prediction'] == 1 ? 'Suitable' : 'Not Suitable'}",
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Date: $formattedDate",
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              const SizedBox(height: 5.0),
              Text(
                "Weather: ${weather['condition']}",
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              Text(
                "Temp: ${weather['tempC']}°C",
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              Text(
                "Wind: ${weather['wind_kph']} kph",
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              Text(
                "Humidity: ${weather['humidity']}%",
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Prediction History"),
          backgroundColor: Colors.blueAccent,
          elevation: 4.0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction History"),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getPredictionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading history"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 80, color: Colors.grey),
                    const SizedBox(height: 20.0),
                    Text(
                      "No prediction history available yet.\nStart making predictions to see them here!",
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 18.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List<Map<String, dynamic>> historyData = snapshot.data!;

            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                var item = historyData[index];
                return _buildHistoryItem(context, item);
              },
            );
          }
        },
      ),
    );
  }
}




