import 'package:flutter/material.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    final List<String> clientsList = [
      'Event Management Companies',
      'Wedding Planners',
      'Corporate Event Agencies',
      'Brand Activation Companies',
      'Exhibition & Expo Organizers',
      'Production Houses',
      'Hospitality Partners',
      'Private Concierge Services',
    ];

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
                      vertical: 80, // Premium spacing
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🚀 ENGINE SYNC: Global Animation Engine & Font Engine
                        AppTheme.applyAnim(
                          Text(
                            'Who We Serve',
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 36 : 56,
                              weight: FontWeight.bold,
                              color: AppTheme.textMain, // 🎨 Dynamic Text Color
                            ),
                          ),
                          100,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // 🚀 ENGINE SYNC: Global Animation Engine & Font Engine
                        AppTheme.applyAnim(
                          Text(
                            'Partnering with industry leaders to deliver flawless event execution.',
                            textAlign: TextAlign.center,
                            style: AppTheme.getBodyStyle(
                              fontSize: isMobile ? 14 : 18,
                              color: AppTheme.accent, // 🎨 Dynamic Accent Color
                            ).copyWith(letterSpacing: 1.2),
                          ),
                          300,
                        ),

                        const SizedBox(height: 80),

                        // Clients Grid
                        Wrap(
                          spacing: 25,
                          runSpacing: 25,
                          alignment: WrapAlignment.center,
                          children: List.generate(clientsList.length, (index) {
                            return _buildClientChip(clientsList[index], index);
                          }),
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

  // Stylish Client Name Card with UI Style Engine
  Widget _buildClientChip(String name, int index) {
    return AppTheme.applyAnim(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        // 🚀 ENGINE SYNC: UI Style Engine (Glass, Flat, Solid, Bordered)
        decoration: AppTheme.getCardDecoration(isHovered: false),
        child: Text(
          name.toUpperCase(),
          // 🚀 ENGINE SYNC: Font Engine
          style: AppTheme.getBodyStyle(
            fontSize: 14,
            weight: FontWeight.bold,
            color: AppTheme.textMain, // 🎨 Dynamic Text
          ).copyWith(letterSpacing: 2.0),
        ),
      ),
      (index * 100) + 400, // Staggered delay for smooth entrance
    );
  }
}