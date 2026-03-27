import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/app_theme.dart'; // 🚀 GLOBAL THEME ENGINE IMPORTED

class ContactFormWidget extends StatefulWidget {
  final bool isMobile;
  const ContactFormWidget({super.key, required this.isMobile});

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    const String scriptUrl = "https://script.google.com/macros/s/AKfycbxv4oF0vFaETW9dCac-BrB9NnaiKN7bIyV8irBXmxZfurgQCUoVLvSf9NHWCZRhTJjSSg/exec";

    try {
      final response = await http.post(
        Uri.parse(scriptUrl),
        headers: {"Accept": "application/json"},
        body: jsonEncode({
          "name": _nameController.text,
          "email": _emailController.text,
          "eventType": _eventTypeController.text,
          "message": _messageController.text,
        }),
      );

      if (!mounted) return; 

      if (response.statusCode == 200 || response.statusCode == 302) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // 🚀 ENGINE SYNC: Dynamic Font
            content: Text('Message sent successfully!', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _nameController.clear();
        _emailController.clear();
        _eventTypeController.clear();
        _messageController.clear();
      } else {
        throw Exception("Failed to send data");
      }
    } catch (e) {
      if (!mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // 🚀 ENGINE SYNC: Dynamic Font
          content: Text('Something went wrong. Please try again.', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ENGINE SYNC: Dynamic Button Radius based on Global Style
    double buttonRadius = AppTheme.buttonStyle == 'pill' ? 50 : (AppTheme.buttonStyle == 'square' ? 0 : 10);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 ENGINE SYNC: Dynamic Heading
        Text(
          'Inquiry',
          style: AppTheme.getHeadingStyle(
            fontSize: 32,
            weight: FontWeight.bold,
            color: AppTheme.textMain,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 30),
        
        Form(
          key: _formKey,
          child: Column(
            children: [
              widget.isMobile 
                ? Column(
                    children: [
                      _buildTextField('FULL NAME', 'John Doe', _nameController),
                      const SizedBox(height: 20),
                      _buildTextField('EMAIL ADDRESS', 'johndoe@gmail.com', _emailController),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildTextField('FULL NAME', 'John Doe', _nameController)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField('EMAIL ADDRESS', 'johndoe@gmail.com', _emailController)),
                    ],
                  ),
                  
              const SizedBox(height: 20),
              _buildTextField('EVENT TYPE', 'Wedding, Corporate, etc.', _eventTypeController),
              
              const SizedBox(height: 20),
              _buildTextField('MESSAGE', 'How can we help you?', _messageController, maxLines: 4),
              
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent, // 🚀 ENGINE SYNC: Accent Color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)), // 🚀 ENGINE SYNC: Button Style
                    elevation: AppTheme.enableShadows ? 5 : 0, // 🚀 ENGINE SYNC: Shadow toggle
                    shadowColor: AppTheme.accent.withValues(alpha: 0.4),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 25, width: 25, 
                        // 🚀 ENGINE SYNC: Loader Color based on text main
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : Text(
                        'SEND MESSAGE',
                        // 🚀 ENGINE SYNC: Body Font
                        style: AppTheme.getBodyStyle(
                          fontSize: 14,
                          weight: FontWeight.bold,
                          color: AppTheme.bg, // 🚀 Contrast text color
                        ).copyWith(letterSpacing: 2.0),
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    // 🚀 ENGINE SYNC: Form Field Radius based on Global Component Style
    double fieldRadius = AppTheme.buttonStyle == 'pill' ? 25 : (AppTheme.buttonStyle == 'square' ? 0 : 10);
    if(maxLines > 1 && AppTheme.buttonStyle == 'pill') fieldRadius = 20; // Don't make large text areas fully rounded

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 ENGINE SYNC: Dynamic Label
        Text(
          label,
          style: AppTheme.getBodyStyle(
            fontSize: 12, 
            color: AppTheme.textSub
          ).copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          // 🚀 ENGINE SYNC: Input Text Font
          style: AppTheme.getBodyStyle(fontSize: 14, color: AppTheme.textMain), 
          validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            // 🚀 ENGINE SYNC: Hint Font
            hintStyle: AppTheme.getBodyStyle(fontSize: 14, color: AppTheme.textSub.withValues(alpha: 0.5)),
            filled: true,
            fillColor: AppTheme.cardBg, // 🚀 ENGINE SYNC: Dynamic Card Background
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
              borderSide: BorderSide(color: AppTheme.textSub.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
              borderSide: BorderSide(color: AppTheme.accent, width: 2), // 🚀 ENGINE SYNC: Active Border
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}