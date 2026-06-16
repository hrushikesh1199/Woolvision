// lib/models/wool_data.dart
import 'dart:math';

class WoolData {
  final double moistureLevel;
  final String colorGrade;
  final double weight;
  final double temperature;
  final int qualityScore;
  final String qualityLabel;
  final List<double> trendData;

  WoolData({
    required this.moistureLevel,
    required this.colorGrade,
    required this.weight,
    required this.temperature,
    required this.qualityScore,
    required this.qualityLabel,
    required this.trendData,
  });

  factory WoolData.generate() {
    final rng = Random();

    final moisture = 8.0 + rng.nextDouble() * 10; // 8–18%
    final grades = ['Grade A', 'Grade A+', 'Grade B', 'Premium'];
    final grade = grades[rng.nextInt(grades.length)];
    final weight = 400.0 + rng.nextDouble() * 300; // 400–700g
    final temp = 24.0 + rng.nextDouble() * 10; // 24–34°C
    final score = 65 + rng.nextInt(36); // 65–100

    String label;
    if (score >= 90) {
      label = 'Excellent Quality';
    } else if (score >= 80) {
      label = 'Very Good';
    } else if (score >= 70) {
      label = 'Good Quality';
    } else {
      label = 'Average Quality';
    }

    final trend = List.generate(7, (_) => 55.0 + rng.nextDouble() * 45);

    return WoolData(
      moistureLevel: double.parse(moisture.toStringAsFixed(1)),
      colorGrade: grade,
      weight: double.parse(weight.toStringAsFixed(0)),
      temperature: double.parse(temp.toStringAsFixed(1)),
      qualityScore: score,
      qualityLabel: label,
      trendData: trend,
    );
  }
}
