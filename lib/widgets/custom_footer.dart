import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // 🚀 GLOBAL THEME ENGINE IMPORTED

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardBg, // 🚀 ENGINE SYNC: Dynamic Background
        border: Border(
          top: BorderSide(
            color: AppTheme.accent, // 🚀 ENGINE SYNC: Dynamic Accent Border
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        children: [
          // Main Content Area
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 30 : 80,
              vertical: 80,
            ),
            child: Wrap(
              spacing: 60,
              runSpacing: 50,
              alignment: WrapAlignment.spaceBetween,
              children: [
                
                // 1. Brand Section
                SizedBox(
                  width: isMobile ? double.infinity : 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🚀 ENGINE SYNC: Heading Font Engine
                      Text(
                        'FORTUNE',
                        style: AppTheme.getHeadingStyle(
                          fontSize: 32,
                          color: AppTheme.textMain, 
                          weight: FontWeight.bold,
                        ).copyWith(letterSpacing: 4.0),
                      ),
                      // 🚀 ENGINE SYNC: Body Font Engine
                      Text(
                        'EVENT PLANNER',
                        style: AppTheme.getBodyStyle(
                          fontSize: 12,
                          color: AppTheme.accent, 
                          weight: FontWeight.w600,
                        ).copyWith(letterSpacing: 6.0),
                      ),
                      const SizedBox(height: 25),
                      // 🚀 ENGINE SYNC: Body Font Engine
                      Text(
                        'The Ultimate Event Management.\nDelivering premium execution and unified staffing solutions across the industry.',
                        style: AppTheme.getBodyStyle(
                          color: AppTheme.textSub, 
                          fontSize: 14,
                        ).copyWith(height: 1.8),
                      ),
                    ],
                  ),
                ),

                // 2. Direct Contacts
                SizedBox(
                  width: isMobile ? double.infinity : 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🚀 ENGINE SYNC: Body Font Engine
                      Text(
                        'CONNECT', 
                        style: AppTheme.getBodyStyle(
                          fontSize: 14, 
                          color: AppTheme.textMain,
                          weight: FontWeight.bold,
                        ).copyWith(letterSpacing: 2.0),
                      ),
                      const SizedBox(height: 25),
                      _buildContactRow('Kaushik Panjre', '+91 91745 64996'),
                      _buildContactRow('Meet Shah', '+91 7693064811'),
                      _buildContactRow('Pushpendra Thakur', '+91 8224968245'),
                    ],
                  ),
                ),

                // 3. Address & Email
                SizedBox(
                  width: isMobile ? double.infinity : 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🚀 ENGINE SYNC: Body Font Engine
                      Text(
                        'HEADQUARTERS', 
                        style: AppTheme.getBodyStyle(
                          fontSize: 14, 
                          color: AppTheme.textMain,
                          weight: FontWeight.bold,
                        ).copyWith(letterSpacing: 2.0),
                      ),
                      const SizedBox(height: 25),
                      _buildIconRow(Icons.location_on_outlined, '152 Orbit Mall,\nVijay Nagar, Indore'),
                      const SizedBox(height: 20),
                      _buildIconRow(Icons.email_outlined, 'fortuneeventplanner1\n@gmail.com'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Copyright Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            color: AppTheme.bg, // 🚀 ENGINE SYNC: Base Background
            child: Text(
              '© ${DateTime.now().year} Fortune Event Planner. All Rights Reserved.',
              textAlign: TextAlign.center,
              // 🚀 ENGINE SYNC: Body Font Engine
              style: AppTheme.getBodyStyle(
                color: AppTheme.textSub, 
                fontSize: 12,
              ).copyWith(letterSpacing: 1.0),
            ),
          ),
        ],
      ),
    );
  }

  // Stylish Contact Detail
  Widget _buildContactRow(String name, String phone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🚀 ENGINE SYNC: Body Font Engine
          Text(
            name.toUpperCase(),
            style: AppTheme.getBodyStyle(
              color: AppTheme.textSub, 
              fontSize: 11,
              weight: FontWeight.w600,
            ).copyWith(letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          // 🚀 ENGINE SYNC: Body Font Engine
          Text(
            phone,
            style: AppTheme.getBodyStyle(
              color: AppTheme.accent, 
              fontSize: 16,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Stylish Address/Email Details
  Widget _buildIconRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.accent, size: 22), // 🚀 ENGINE SYNC: Dynamic Accent Icon
        const SizedBox(width: 15),
        Expanded(
          // 🚀 ENGINE SYNC: Body Font Engine
          child: Text(
            text,
            style: AppTheme.getBodyStyle(
              color: AppTheme.textMain.withValues(alpha: 0.8), 
              fontSize: 14,
            ).copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}