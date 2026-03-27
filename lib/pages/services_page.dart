import 'package:flutter/material.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/service_card.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🚀 YE HAI ASLI BRAIN

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    return Scaffold(
      backgroundColor: AppTheme.bg, // 🎨 ENGINE SYNC: Master Color Switch
      body: Column(
        children: [
          const CustomNavbar(),
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- PAGE HEADER (ANIMATED) ---
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 80,
                    ),
                    decoration: BoxDecoration(
                      // 🚀 ENGINE SYNC: Background gradient mode check
                      gradient: AppTheme.enableGradients ? LinearGradient(
                        colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.5)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ) : null,
                      color: !AppTheme.enableGradients ? AppTheme.bg : null,
                    ),
                    child: Column(
                      children: [
                        // 🚀 ENGINE SYNC: Header Animation & Font Engine
                        AppTheme.applyAnim(
                          Text(
                            'Our Services',
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 36 : 56,
                              weight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          0,
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // 🚀 ENGINE SYNC: Body Font Engine
                        AppTheme.applyAnim(
                          Text(
                            'Comprehensive event management and operational support tailored to your needs.',
                            textAlign: TextAlign.center,
                            style: AppTheme.getBodyStyle(
                              fontSize: isMobile ? 14 : 16,
                              color: AppTheme.accent, 
                            ).copyWith(letterSpacing: 1.5),
                          ),
                          200,
                        ),
                      ],
                    ),
                  ),

                  // --- SERVICES GRID (DYNAMIC POWERED BY APP_THEME) ---
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 40,
                    ),
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      
                      // 🔥 YAHAN HAI ASLI MAGIC:
                      // Ye loop 'app_theme.dart' mein rakhi saari 8 images aur content ko 
                      // ek second mein khinch ke yahan la raha hai.
                      children: AppTheme.servicesData.map((data) {
                        return ServiceCard(
                          title: data['title'],
                          description: data['description'],
                          delay: data['delay'] ?? 100,
                          images: List<String>.from(data['images']), 
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  const CustomFooter(),   
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}