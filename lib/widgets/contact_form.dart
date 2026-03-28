import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // 🚀 ENGINE SYNC: Dynamic Snackbar/Toast Generator
  void _showCustomToast(String message, Color bgColor, IconData icon) {
    if (AppTheme.enableSoundEffects) HapticFeedback.mediumImpact();

    SnackBar behavior;
    
    // Check global toast style setting
    if (AppTheme.toastStyle == 'glass') {
      behavior = SnackBar(
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white))),
              ],
            ),
          ),
        ),
        backgroundColor: bgColor.withValues(alpha: 0.6),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
      );
    } else if (AppTheme.toastStyle == 'banner') {
      behavior = SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white))),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.fixed, // Attaches to the bottom
      );
    } else { // default floating
      behavior = SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white))),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(behavior);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      if (AppTheme.enableSoundEffects) HapticFeedback.vibrate();
      return;
    }

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
        _showCustomToast('Message sent successfully! We will contact you soon.', Colors.green.shade600, Icons.check_circle_outline);
        
        _nameController.clear();
        _emailController.clear();
        _eventTypeController.clear();
        _messageController.clear();
      } else {
        throw Exception("Failed to send data");
      }
    } catch (e) {
      if (!mounted) return; 
      _showCustomToast('Something went wrong. Please try again.', Colors.redAccent.shade700, Icons.error_outline);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ENGINE SYNC: Dynamic Button Radius based on Global Style
    double buttonRadius = AppTheme.buttonStyle == 'pill' ? 50 : (AppTheme.buttonStyle == 'square' ? 0 : AppTheme.getGlobalRadius());
    
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
              
              MouseRegion(
                // 🚀 ENGINE SYNC: Custom Cursor
                cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent, // 🚀 ENGINE SYNC: Accent Color
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)), // 🚀 ENGINE SYNC: Button Style
                      elevation: AppTheme.enableShadows ? 8 : 0, // 🚀 ENGINE SYNC: Shadow toggle
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
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
          // 🚀 ENGINE SYNC: Master Decoration from AppTheme
          decoration: AppTheme.getFormInputDecoration(hint),
        ),
      ],
    );
  }
}