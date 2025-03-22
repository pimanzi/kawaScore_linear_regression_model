import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double prediction;
  final Map<String, double> inputValues;

  const ResultScreen({
    super.key,
    required this.prediction,
    required this.inputValues,
  });

  @override
  Widget build(BuildContext context) {
    final qualityInfo = _getQualityInfo(prediction);
    final qualityColor = qualityInfo['color'] as Color;
    final qualityText = qualityInfo['text'] as String;

    final screenWidth = MediaQuery.of(context).size.width;
    final circleSize = screenWidth * 0.4; // 40% of screen width

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Result'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Coffee Quality Score',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: circleSize,
                  height: circleSize,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: qualityColor.withOpacity(0.1),
                    border: Border.all(
                      color: qualityColor,
                      width: 5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${prediction.toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: qualityColor,
                          ),
                        ),
                        Text(
                          'points',
                          style: TextStyle(
                            fontSize: 16,
                            color: qualityColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: qualityColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    qualityText,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: qualityColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.brown[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.coffee, color: Colors.brown[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Coffee Attributes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildAttributeRow(
                        'Aroma',
                        inputValues['Aroma']!,
                        'Acidity',
                        inputValues['Acidity']!,
                      ),
                      const SizedBox(height: 16),
                      _buildAttributeRow(
                        'Body',
                        inputValues['Body']!,
                        'Uniformity',
                        inputValues['Uniformity']!,
                      ),
                      const SizedBox(height: 16),
                      _buildAttributeRow(
                        'Clean Cup',
                        inputValues['CleanCup']!,
                        'Sweetness',
                        inputValues['Sweetness']!,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Try Another Prediction',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeRow(
    String label1,
    double value1,
    String label2,
    double value2,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildAttributeItem(label1, value1),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAttributeItem(label2, value2),
        ),
      ],
    );
  }

  Widget _buildAttributeItem(String label, double value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.brown[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.brown[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900],
                ),
              ),
              const Spacer(),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getAttributeColor(value),
                ),
                child: Center(
                  child: Text(
                    value.round().toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getAttributeColor(double score) {
    if (score >= 8.0) return Colors.green[700]!;
    if (score >= 6.0) return Colors.orange[700]!;
    if (score >= 4.0) return Colors.amber[700]!;
    return Colors.red[700]!;
  }

  Map<String, dynamic> _getQualityInfo(double score) {
    if (score >= 90.0) {
      return {
        'text': 'Excellent Quality',
        'color': Colors.green[700]!,
      };
    } else if (score >= 70.0) {
      return {
        'text': 'Good Quality',
        'color': Colors.orange[700]!,
      };
    } else if (score >= 50.0) {
      return {
        'text': 'Average Quality',
        'color': Colors.amber[700]!,
      };
    } else {
      return {
        'text': 'Poor Quality',
        'color': Colors.red[700]!,
      };
    }
  }
}
