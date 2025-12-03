import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_colors.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  static final List<GuideItem> brooderGuide = [
    GuideItem(
      week: 1,
      temperature: '32-35°C',
      humidity: '60-70%',
      lightHours: '24 hours',
      tips: [
        'Keep temperature consistent, chicks are most vulnerable',
        'Ensure heat source is properly positioned',
        'Check water availability frequently',
        'Monitor for signs of chilling (huddling) or overheating (panting)',
      ],
    ),
    GuideItem(
      week: 2,
      temperature: '29-32°C',
      humidity: '55-65%',
      lightHours: '18-20 hours',
      tips: [
        'Gradually reduce temperature by 3°C from week 1',
        'Increase ventilation slightly',
        'Start providing more space as chicks grow',
        'Maintain consistent feeding schedule',
      ],
    ),
    GuideItem(
      week: 3,
      temperature: '26-29°C',
      humidity: '50-60%',
      lightHours: '16-18 hours',
      tips: [
        'Continue gradual temperature reduction',
        'Monitor for respiratory issues',
        'Ensure adequate space per bird',
        'Begin transitioning to grower feed if applicable',
      ],
    ),
    GuideItem(
      week: 4,
      temperature: '23-26°C',
      humidity: '50-60%',
      lightHours: '14-16 hours',
      tips: [
        'Birds are more resilient, less heat needed',
        'Increase ventilation for better air quality',
        'Monitor humidity to prevent respiratory issues',
        'Check for signs of overcrowding',
      ],
    ),
    GuideItem(
      week: 5,
      temperature: '20-23°C',
      humidity: '45-55%',
      lightHours: '12-14 hours',
      tips: [
        'Prepare for transition to ambient temperature',
        'Ensure proper ventilation',
        'Monitor growth and adjust feeding accordingly',
        'Consider outdoor access if weather permits',
      ],
    ),
    GuideItem(
      week: 6,
      temperature: '18-21°C',
      humidity: '45-55%',
      lightHours: '12 hours',
      tips: [
        'Birds should be fully feathered',
        'Can transition to room temperature in warm climates',
        'Focus on maintaining good air quality',
        'Prepare for final housing arrangements',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.pastelYellow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.menu_book, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Brooding Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Week-by-week recommendations', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'These are general guidelines. Always observe your birds\' behavior and adjust conditions accordingly.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // List of Weeks
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: brooderGuide.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final guide = brooderGuide[index];
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Week ${guide.week}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.pastelYellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Days ${(guide.week - 1) * 7 + 1}-${guide.week * 7}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildInfoBox(Icons.thermostat, 'Temp', guide.temperature, AppColors.red50, Colors.red)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInfoBox(Icons.water_drop, 'Humidity', guide.humidity, AppColors.blue50, Colors.blue)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildInfoBox(Icons.lightbulb, 'Light', guide.lightHours, AppColors.yellow50, Colors.orange)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text('Management Tips:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    ...guide.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.pastelYellowDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(tip, style: TextStyle(fontSize: 12, color: Colors.grey[700]))),
                        ],
                      ),
                    )),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          // Best Practices
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('General Best Practices', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildBestPracticeItem('Always provide clean, fresh water'),
                _buildBestPracticeItem('Reduce temperature gradually, not abruptly'),
                _buildBestPracticeItem('Monitor bird behavior more than just numbers'),
                _buildBestPracticeItem('Maintain proper ventilation to prevent disease'),
                _buildBestPracticeItem('Keep brooder clean and dry at all times'),
              ],
            ),
          ),
          const SizedBox(height: 80), // Padding for bottom nav
        ],
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String label, String value, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBestPracticeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700]))),
        ],
      ),
    );
  }
}