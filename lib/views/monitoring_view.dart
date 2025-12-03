import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MonitoringView extends StatelessWidget {
  final String dateStarted;
  final double temperature;
  final double targetTemperature;
  final double humidity;
  final String lightStatus;
  final String lightMode;
  final Function(double) onTemperatureChange;
  final VoidCallback onLightToggle;
  final VoidCallback onLightModeToggle;

  const MonitoringView({
    super.key,
    required this.dateStarted,
    required this.temperature,
    required this.targetTemperature,
    required this.humidity,
    required this.lightStatus,
    required this.lightMode,
    required this.onTemperatureChange,
    required this.onLightToggle,
    required this.onLightModeToggle,
  });

  String _getTempStatus() {
    if (temperature > targetTemperature + 2) return 'high';
    if (temperature < targetTemperature - 2) return 'low';
    return 'normal';
  }

  String _getHumidityStatus() {
    if (humidity > 70) return 'high';
    if (humidity < 50) return 'low';
    return 'normal';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'high': return AppColors.danger;
      case 'low': return AppColors.warning;
      default: return AppColors.success;
    }
  }

  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  @override
  Widget build(BuildContext context) {
    final tempStatus = _getTempStatus();
    final humidityStatus = _getHumidityStatus();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date Started Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.pastelYellow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Started Monitoring',
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStarted,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Temperature Card
          _buildStatusCard(
            title: 'Temperature',
            value: '${temperature.toStringAsFixed(1)}°C',
            icon: Icons.thermostat,
            status: tempStatus,
            statusColor: _getStatusColor(tempStatus),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Target Temperature', style: TextStyle(color: Colors.grey[600])),
                    Text('${targetTemperature.toStringAsFixed(0)}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: targetTemperature,
                  min: 20,
                  max: 40,
                  activeColor: AppColors.pastelYellowDark,
                  inactiveColor: Colors.grey[200],
                  onChanged: onTemperatureChange,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('20°C', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                    Text('40°C', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Humidity Card
          _buildStatusCard(
            title: 'Humidity',
            value: '${humidity.toStringAsFixed(0)}%',
            icon: Icons.water_drop,
            status: humidityStatus,
            statusColor: _getStatusColor(humidityStatus),
          ),
          const SizedBox(height: 24),

          // Light Control Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: lightStatus == 'on' ? AppColors.pastelYellowDark : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.lightbulb,
                            color: lightStatus == 'on' ? Colors.grey[800] : Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Light', style: TextStyle(color: Colors.grey[600])),
                            Text(
                              _capitalize(lightStatus),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: lightStatus == 'on',
                      activeColor: AppColors.pastelYellowDark,
                      onChanged: (_) => onLightToggle(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Automatic Mode', style: TextStyle(color: Colors.grey[600])),
                    Switch(
                      value: lightMode == 'automatic',
                      activeColor: AppColors.pastelYellowDark,
                      onChanged: (_) => onLightModeToggle(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
    required String status,
    required Color statusColor,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.pastelYellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.grey[800]),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _capitalize(status),
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          if (status == 'high')
                            const Icon(Icons.trending_up, size: 16, color: AppColors.danger),
                          if (status == 'low')
                            const Icon(Icons.trending_down, size: 16, color: AppColors.warning),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          if (child != null) child,
        ],
      ),
    );
  }
}