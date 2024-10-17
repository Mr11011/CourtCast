import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Future<int?> getAIModelSource(List<int> features) async {
  final url = Uri.parse('http://10.0.2.2:5001/predict');

  // Create the POST request body
  Map<String, dynamic> body = {'features': features};

  // Send the POST request
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  // Handle the response
  if (response.statusCode == 200) {
    final prediction = json.decode(response.body)['prediction'];
    if (kDebugMode) {
      print('Prediction: $prediction');
    }
    return prediction[0];
  } else {
    if (kDebugMode) {
      print('Failed to get prediction');
    }
    return null;
  }
}
