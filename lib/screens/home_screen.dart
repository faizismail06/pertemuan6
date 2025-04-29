import 'package:flutter/material.dart';
import 'package:iot_control_app/models/sensor_data.dart';
import 'package:iot_control_app/services/firebase_service.dart';
import 'package:iot_control_app/widgets/gauge_widget.dart';
import 'package:iot_control_app/widgets/history_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize Firebase listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseService =
          Provider.of<FirebaseService>(context, listen: false);
      final sensorModel = Provider.of<SensorDataModel>(context, listen: false);
      firebaseService.initListeners(sensorModel);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Control Dashboard'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'CURRENT', icon: Icon(Icons.dashboard)),
            Tab(text: 'HISTORY', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DashboardTab(),
          HistoryTab(),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorDataModel>(
      builder: (context, sensorModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Readings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Temperature and Humidity Gauges
              Row(
                children: [
                  Expanded(
                    child: GaugeWidget(
                      title: 'Temperature',
                      value: sensorModel.temperature,
                      unit: '°C',
                      minValue: 0,
                      maxValue: 50,
                      gradient: const [Colors.blue, Colors.orange, Colors.red],
                    ),
                  ),
                  Expanded(
                    child: GaugeWidget(
                      title: 'Humidity',
                      value: sensorModel.humidity,
                      unit: '%',
                      minValue: 0,
                      maxValue: 100,
                      gradient: const [
                        Colors.orange,
                        Colors.blue,
                        Colors.indigo
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // LED Control
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LED Control',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sensorModel.ledState ? 'LED is ON' : 'LED is OFF',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: sensorModel.ledState
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          Switch(
                            value: sensorModel.ledState,
                            onChanged: (value) {
                              Provider.of<FirebaseService>(context,
                                      listen: false)
                                  .setLedState(value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Last updated info
              Text(
                'Last updated: ${DateTime.now().toString().substring(0, 19)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorDataModel>(
      builder: (context, sensorModel, child) {
        if (sensorModel.history.isEmpty) {
          return const Center(
            child: Text('No history data available yet.'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Temperature History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: HistoryChart(
                  data: sensorModel.history,
                  valueType: 'temperature',
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Humidity History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: HistoryChart(
                  data: sensorModel.history,
                  valueType: 'humidity',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
