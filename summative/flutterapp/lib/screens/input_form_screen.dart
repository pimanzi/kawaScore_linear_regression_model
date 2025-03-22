import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'result_screen.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({super.key});

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _aromaController = TextEditingController();
  final TextEditingController _acidityController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _uniformityController = TextEditingController();
  final TextEditingController _cleanCupController = TextEditingController();
  final TextEditingController _sweetnessController = TextEditingController();

  @override
  void dispose() {
    _aromaController.dispose();
    _acidityController.dispose();
    _bodyController.dispose();
    _uniformityController.dispose();
    _cleanCupController.dispose();
    _sweetnessController.dispose();
    super.dispose();
  }

  Future<double> predictCoffeeScore({
    required double aroma,
    required double acidity,
    required double body,
    required double uniformity,
    required double cleanCup,
    required double sweetness,
  }) async {
    final url = Uri.parse(
        'https://kawascore-linear-regression-model.onrender.com/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'aroma': aroma,
        'acidity': acidity,
        'body': body,
        'uniformity': uniformity,
        'Clean Cup': cleanCup,
        'sweetness': sweetness,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the response and return the prediction
      final responseData = jsonDecode(response.body);
      return responseData['predicted_total_cup_points'];
    } else {
      throw Exception('Failed to get prediction');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Attributes'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Container(
              width: formWidth,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.coffee,
                      size: 48,
                      color: Colors.brown[800],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter Coffee Characteristics',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rate each attribute from 0-10 (decimal values allowed)',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildInputField(
                      context,
                      'Aroma',
                      'The fragrance of the coffee (0-10)',
                      _aromaController,
                      hint: '7.5',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      context,
                      'Acidity',
                      'The brightness and sharpness of the coffee (0-10)',
                      _acidityController,
                      hint: '8.0',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      context,
                      'Body',
                      'The weight and texture of the coffee (0-10)',
                      _bodyController,
                      hint: '7.0',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      context,
                      'Uniformity',
                      'Consistency of the coffee across cups (0-10)',
                      _uniformityController,
                      hint: '9.0',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      context,
                      'Clean Cup',
                      'Absence of defects in the coffee (0-10)',
                      _cleanCupController,
                      hint: '10.0',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      context,
                      'Sweetness',
                      'The natural sweetness of the coffee (0-10)',
                      _sweetnessController,
                      hint: '8.5',
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final aroma = double.parse(_aromaController.text);
                              final acidity =
                                  double.parse(_acidityController.text);
                              final body = double.parse(_bodyController.text);
                              final uniformity =
                                  double.parse(_uniformityController.text);
                              final cleanCup =
                                  double.parse(_cleanCupController.text);
                              final sweetness =
                                  double.parse(_sweetnessController.text);

                              final prediction = await predictCoffeeScore(
                                aroma: aroma,
                                acidity: acidity,
                                body: body,
                                uniformity: uniformity,
                                cleanCup: cleanCup,
                                sweetness: sweetness,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    prediction: prediction,
                                    inputValues: {
                                      'Aroma': aroma,
                                      'Acidity': acidity,
                                      'Body': body,
                                      'Uniformity': uniformity,
                                      'CleanCup': cleanCup,
                                      'Sweetness': sweetness,
                                    },
                                  ),
                                ),
                              );
                            } catch (e) {
                              // Show an error message if the API call fails
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[800],
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Predict',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    String label,
    String helper,
    TextEditingController controller, {
    String? hint,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.brown[700]!, width: 2),
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          final numericValue = double.tryParse(value);
          if (numericValue == null || numericValue < 0 || numericValue > 10) {
            return 'Value must be between 0 and 10';
          }
          return null;
        },
      ),
    );
  }
}
