import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result_screen.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({super.key});

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _aromaController = TextEditingController();
  final TextEditingController _flavourController = TextEditingController();
  final TextEditingController _altitudeController = TextEditingController();
  final TextEditingController _sweetnessController = TextEditingController();
  final TextEditingController _acidityController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  void dispose() {
    _aromaController.dispose();
    _flavourController.dispose();
    _altitudeController.dispose();
    _sweetnessController.dispose();
    _acidityController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size to calculate form width
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate form width - on large screens limit width, on small use most of screen
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
                      'Rate each attribute from 0-10 (except altitude which is in meters)',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Input Fields - arranged in grid/columns
                    _buildInputField(
                      context,
                      'Aroma',
                      'Rate from 0-10',
                      _aromaController,
                      hint: '7.5',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      context,
                      'Flavour',
                      'Rate from 0-10',
                      _flavourController,
                      hint: '8.0',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      context,
                      'Altitude',
                      'In meters',
                      _altitudeController,
                      isInteger: true,
                      hint: '1500',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      context,
                      'Sweetness',
                      'Rate from 0-10',
                      _sweetnessController,
                      hint: '6.5',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      context,
                      'Acidity',
                      'Rate from 0-10',
                      _acidityController,
                      hint: '7.0',
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      context,
                      'Balance',
                      'Rate from 0-10',
                      _balanceController,
                      hint: '8.5',
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Simply navigate to result screen with dummy data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultScreen(),
                              ),
                            );
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
    bool isInteger = false,
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
        keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
        inputFormatters: [
          isInteger
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    );
  }
}
