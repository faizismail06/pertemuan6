import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iot_control_app/models/sensor_data.dart';
import 'package:intl/intl.dart';

class HistoryChart extends StatelessWidget {
  final List<SensorData> data;
  final String valueType;
  final Color color;

  const HistoryChart({
    super.key, 
    required this.data,
    required this.valueType,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty container if no data
    if (data.isEmpty) {
      return Container();
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 10,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length && index % 5 == 0) {
                  final timestamp = data[index].timestamp;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('HH:mm').format(timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: getYAxisInterval(),
              getTitlesWidget: (double value, TitleMeta meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: getMinY(),
        maxY: getMaxY(),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(data.length, (index) {
              return FlSpot(
                index.toDouble(),
                getValue(data[index]),
              );
            }),
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.3),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < data.length) {
                  final timestamp = data[index].timestamp;
                  final value = getValue(data[index]);
                  
                  return LineTooltipItem(
                    '${DateFormat('HH:mm:ss').format(timestamp)}\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '$valueType: ${value.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  double getValue(SensorData data) {
    switch (valueType) {
      case 'temperature':
        return data.temperature;
      case 'humidity':
        return data.humidity;
      default:
        return 0;
    }
  }

  double getMinY() {
    if (data.isEmpty) return 0;
    
    double minValue = double.infinity;
    for (var item in data) {
      final value = getValue(item);
      if (value < minValue) {
        minValue = value;
      }
    }
    
    // Round down to nearest 10
    return (minValue ~/ 10) * 10.0;
  }

  double getMaxY() {
    if (data.isEmpty) return 100;
    
    double maxValue = double.negativeInfinity;
    for (var item in data) {
      final value = getValue(item);
      if (value > maxValue) {
        maxValue = value;
      }
    }
    
    // Round up to nearest 10
    return ((maxValue ~/ 10) + 1) * 10.0;
  }

  double getYAxisInterval() {
    final range = getMaxY() - getMinY();
    if (range <= 20) return 2;
    if (range <= 50) return 5;
    return 10;
  }
}