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
  bool _isHoveringSubmit = false;

  void _triggerSound({bool isError = false}) {
    if (!AppTheme.enableSoundEffects) return;
    if (isError) {
      HapticFeedback.vibrate();
    } else {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else if (AppTheme.soundPack == 'clicky') {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  // 🚀 ENGINE SYNC: Dynamic Snackbar/Toast Generator (Soft & Beautiful)
  void _showCustomToast(String message, Color bgColor, IconData icon) {
    if (AppTheme.enableSoundEffects) HapticFeedback.mediumImpact();

    SnackBar behavior;
    
    // Check global toast style setting
    if (AppTheme.toastStyle == 'glass') {
      behavior = SnackBar(
        content: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // 🟢 FIX: Better padding
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 15), // 🟢 FIX: Better spacing
                Expanded(child: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white, weight: FontWeight.w600))),
              ],
            ),
          ),
        ),
        backgroundColor: bgColor.withValues(alpha: 0.8), // 🟢 FIX: Increased visibility
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
        margin: EdgeInsets.all(widget.isMobile ? 20 : 40), // 🟢 FIX: Margin to float properly
      );
    } else if (AppTheme.toastStyle == 'banner') {
      behavior = SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 15),
            Expanded(child: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white, weight: FontWeight.w600))),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.fixed, // Attaches to the bottom
      );
    } else { // default floating
      behavior = SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 15),
            Expanded(child: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white, weight: FontWeight.w600))),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
        margin: EdgeInsets.all(widget.isMobile ? 20 : 40),
        elevation: AppTheme.enableShadows ? 10 : 0,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(behavior);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _triggerSound(isError: true);
      return;
    }

    _triggerSound();
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
    int animMs = AppTheme.transitionSpeed == 'fast' ? 150 : (AppTheme.transitionSpeed == 'slow' ? 400 : 250);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 ENGINE SYNC: Dynamic Heading
        Text(
          'Inquiry',
          style: AppTheme.getHeadingStyle(
            fontSize: widget.isMobile ? 36 : 42, // 🟢 FIX: Larger, more impactful heading
            weight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Fill out the form below and our team will get back to you.',
          style: AppTheme.getBodyStyle(
            fontSize: 14,
            color: AppTheme.textSub,
          ),
        ),
        const SizedBox(height: 40),
        
        Form(
          key: _formKey,
          child: Column(
            children: [
              // 🟢 FIX: Smooth Layout Transition between Mobile and Desktop
              widget.isMobile 
                ? Column(
                    children: [
                      _buildTextField('FULL NAME', 'John Doe', _nameController, TextInputType.name),
                      const SizedBox(height: 25),
                      _buildTextField('EMAIL ADDRESS', 'johndoe@email.com', _emailController, TextInputType.emailAddress, isEmail: true),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildTextField('FULL NAME', 'John Doe', _nameController, TextInputType.name)),
                      const SizedBox(width: 30),
                      Expanded(child: _buildTextField('EMAIL ADDRESS', 'johndoe@email.com', _emailController, TextInputType.emailAddress, isEmail: true)),
                    ],
                  ),
                  
              const SizedBox(height: 25),
              _buildTextField('EVENT TYPE', 'Wedding, Corporate, Concert, etc.', _eventTypeController, TextInputType.text),
              
              const SizedBox(height: 25),
              _buildTextField('MESSAGE', 'How can we help make your event special?', _messageController, TextInputType.multiline, maxLines: 5),
              
              const SizedBox(height: 45),
              
              // ==========================================
              // 🚀 GOD TIER SUBMIT BUTTON (Animated & Reactive)
              // ==========================================
              MouseRegion(
                cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHoveringSubmit = true),
                onExit: (_) => setState(() => _isHoveringSubmit = false),
                child: GestureDetector(
                  onTap: _isLoading ? null : _submitForm,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: animMs),
                    curve: Curves.easeOutCubic,
                    width: double.infinity,
                    height: 55, // 🟢 FIX: Taller, more clickable button
                    decoration: BoxDecoration(
                      color: _isLoading 
                          ? AppTheme.accent.withValues(alpha: 0.7) // Disabled look when loading
                          : (_isHoveringSubmit ? AppTheme.accent : AppTheme.accent.withValues(alpha: 0.9)), // Hover brightness
                      borderRadius: BorderRadius.circular(buttonRadius),
                      // 🟢 FIX: Glow effect on hover
                      boxShadow: (AppTheme.enableShadows || AppTheme.enableGlow) && _isHoveringSubmit && !_isLoading
                          ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 5))]
                          : (AppTheme.enableShadows && !_isLoading ? [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : []),
                    ),
                    child: Center(
                      child: _isLoading 
                        ? const SizedBox(
                            height: 24, width: 24, 
                            // 🚀 ENGINE SYNC: Loader Color based on text main
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3) // 🟢 FIX: Solid contrast loader
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'SEND MESSAGE',
                                // 🚀 ENGINE SYNC: Body Font
                                style: AppTheme.getBodyStyle(
                                  fontSize: 15, // 🟢 FIX: Clearer text
                                  weight: FontWeight.bold,
                                  color: Colors.black, // 🟢 FIX: Solid dark text for high contrast on Accent
                                ).copyWith(letterSpacing: 2.0),
                              ),
                              const SizedBox(width: 10),
                              AnimatedSlide( // 🟢 FIX: Arrow slides slightly on hover
                                duration: Duration(milliseconds: animMs),
                                offset: _isHoveringSubmit ? const Offset(0.2, 0) : Offset.zero,
                                child: const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 20),
                              )
                            ],
                          ),
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

  // ==========================================
  // 🎯 CUSTOM TEXT FIELD BUILDER
  // ==========================================
  Widget _buildTextField(String label, String hint, TextEditingController controller, TextInputType type, {int maxLines = 1, bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 ENGINE SYNC: Dynamic Label
        Text(
          label,
          style: AppTheme.getBodyStyle(
            fontSize: 12, 
            color: AppTheme.textSub,
            weight: FontWeight.w600, // 🟢 FIX: Bolder labels for better readability
          ).copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: type,
          // 🚀 ENGINE SYNC: Input Text Font & Color Correction
          style: AppTheme.getBodyStyle(fontSize: 15, color: AppTheme.textMain), 
          cursorColor: AppTheme.accent, // 🟢 FIX: Cursor color syncs with Accent
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required'; // 🟢 FIX: Better error message
            }
            if (isEmail) {
              // 🟢 FIX: Basic Email Validation Regex
              final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
              if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
            }
            return null;
          },
          // 🚀 ENGINE SYNC: Master Decoration from AppTheme
          decoration: AppTheme.getFormInputDecoration(hint).copyWith(
            // 🟢 FIX: Premium error styling sync
            errorStyle: AppTheme.getBodyStyle(color: Colors.redAccent.shade400, fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // 🟢 FIX: Taller, more spacious input fields
          ),
        ),
      ],
    );
  } 
}