import 'package:firebase_database/firebase_database.dart';
import 'package:iot_control_app/models/sensor_data.dart';

class FirebaseService {
  final DatabaseReference _iotReference = FirebaseDatabase.instance.ref('iot');
  
  // Initialize listeners for realtime updates
  void initListeners(SensorDataModel model) {
    _iotReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        model.updateData(data);
      }
    });
  }
  
  // Set the LED state in Firebase
  Future<void> setLedState(bool state) async {
    try {
      await _iotReference.update({'led': state});
      return;
    } catch (e) {
      print('Error setting LED state: $e');
      throw e;
    }
  }
  
  // Get the latest data
  Future<Map<dynamic, dynamic>?> getLatestData() async {
    try {
      final snapshot = await _iotReference.get();
      if (snapshot.exists && snapshot.value != null) {
        return snapshot.value as Map<dynamic, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting latest data: $e');
      return null;
    }
  }
}