import 'package:flutter/material.dart';

// Hamare banaye hue Custom Widgets aur Theme Engine
import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/contact_form.dart'; 
import '../theme/app_theme.dart'; // 🔥 ASLI POWER

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 850;

    return Scaffold(
      // 🎨 ENGINE SYNC: Dynamic Background
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          const CustomNavbar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 80, // Thoda extra premium padding
                    ),
                    child: isMobile
                        ? Column(
                            children: [
                              _buildContactInfo(isMobile),
                              const SizedBox(height: 50),
                              // 🚀 ENGINE SYNC: Form Container with UI Style Engine
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: AppTheme.getCardDecoration(isHovered: false),
                                child: ContactFormWidget(isMobile: isMobile),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Side: Text & Contact Details
                              Expanded(flex: 1, child: _buildContactInfo(isMobile)),
                              const SizedBox(width: 80),
                              // Right Side: Form Container with UI Style Engine
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(50),
                                  // 🚀 ENGINE SYNC: UI Style Engine (Glass, Flat, etc.)
                                  decoration: AppTheme.getCardDecoration(isHovered: false),
                                  child: ContactFormWidget(isMobile: isMobile),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const CustomFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Left Side (Contact Details)
  Widget _buildContactInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 ENGINE SYNC: Global Animation Engine used
        AppTheme.applyAnim(
          Text(
            "Let's\nConnect.",
            style: AppTheme.getHeadingStyle(
              fontSize: isMobile ? 56 : 82,
              weight: FontWeight.bold,
              color: AppTheme.textMain, // 🎨 ENGINE SYNC: Dynamic Color
            ).copyWith(height: 1.0),
          ),
          100,
        ),
        
        const SizedBox(height: 30),
        
        // 🚀 ENGINE SYNC: Font Engine used
        AppTheme.applyAnim(
          Text(
            'Ready to elevate your next event?\nContact our team for a consultation.',
            style: AppTheme.getBodyStyle(
              fontSize: isMobile ? 16 : 18,
              color: AppTheme.textSub, // 🎨 ENGINE SYNC: Dynamic Color
            ).copyWith(height: 1.6),
          ),
          300,
        ),

        const SizedBox(height: 50),

        _buildDetailItem('KAUSHIK PANJRE', '+91 91745 64996', 400),
        _buildDetailItem('MEET SHAH', '+91 7693064811', 500),
        _buildDetailItem('PUSHPENDRA THAKUR', '+91 8224968245', 600),
        
        const SizedBox(height: 20),
        
        _buildDetailItem('EMAIL', 'fortuneeventplanner1@gmail.com', 700),
        _buildDetailItem('ADDRESS', '152 orbit mall vijay nagar indore', 800),
      ],
    );
  }

  Widget _buildDetailItem(String title, String detail, int delay) {
    return AppTheme.applyAnim(
      Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              // 🚀 ENGINE SYNC: Font Engine used
              style: AppTheme.getBodyStyle(
                fontSize: 12,
                weight: FontWeight.bold,
                color: AppTheme.accent.withValues(alpha: .7), // 🎨 ENGINE SYNC: Dynamic Accent
              ).copyWith(letterSpacing: 3.0),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              // 🚀 ENGINE SYNC: Font Engine used
              style: AppTheme.getBodyStyle(
                fontSize: 17,
                weight: FontWeight.w500,
                color: AppTheme.textMain, // 🎨 ENGINE SYNC: Dynamic Color
              ),
            ),
          ],
        ),
      ),
      delay,
    );
  }
}