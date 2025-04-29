import 'package:flutter/foundation.dart';

class SensorData {
  final double temperature;
  final double humidity;
  final DateTime timestamp;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.timestamp,
  });

  factory SensorData.fromMap(Map<dynamic, dynamic> map) {
    return SensorData(
      temperature: (map['temperature'] ?? 0.0).toDouble(),
      humidity: (map['humidity'] ?? 0.0).toDouble(),
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

class SensorDataModel extends ChangeNotifier {
  double _temperature = 0.0;
  double _humidity = 0.0;
  bool _ledState = false;
  List<SensorData> _history = [];

  double get temperature => _temperature;
  double get humidity => _humidity;
  bool get ledState => _ledState;
  List<SensorData> get history => _history;

  void updateData(Map<dynamic, dynamic> data) {
    if (data.containsKey('temperature')) {
      _temperature = (data['temperature'] ?? 0.0).toDouble();
    }
    
    if (data.containsKey('humidity')) {
      _humidity = (data['humidity'] ?? 0.0).toDouble();
    }
    
    if (data.containsKey('led')) {
      _ledState = data['led'] ?? false;
    }
    
    // Add to history if we have both temperature and humidity
    if (data.containsKey('temperature') && data.containsKey('humidity')) {
      _history.add(SensorData(
        temperature: _temperature,
        humidity: _humidity,
        timestamp: DateTime.now(),
      ));
      
      // Keep history to a reasonable size
      if (_history.length > 100) {
        _history.removeAt(0);
      }
    }
    
    notifyListeners();
  }

  void setLedState(bool state) {
    _ledState = state;
    notifyListeners();
  }
}