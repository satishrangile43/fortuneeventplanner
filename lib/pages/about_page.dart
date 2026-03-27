import 'package:flutter/material.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 ASLI SHAKTI

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

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
                      horizontal: isMobile ? 20 : 100,
                      vertical: 80,
                    ),
                    child: Column(
                      children: [
                        // 🚀 ENGINE SYNC: Global Animation & Dynamic Text
                        AppTheme.applyAnim(
                          Text(
                            'About Fortune',
                            // 🚀 ENGINE SYNC: Heading font
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 36 : 56,
                              weight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          100,
                        ),
                        
                        const SizedBox(height: 50),
                        
                        // --- Main Quote / Vision Container ---
                        AppTheme.applyAnim(
                          Container(
                            padding: EdgeInsets.all(isMobile ? 30 : 50),
                            // 🚀 ENGINE SYNC: UI Style Engine (Glass, Flat, Bordered etc.)
                            decoration: AppTheme.getCardDecoration(isHovered: false),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.format_quote_rounded, 
                                  size: 60, 
                                  color: AppTheme.accent.withValues(alpha: 0.6)
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'To strengthen event companies by delivering reliable manpower and operational support that improves coordination, enhances guest experience, and maintains safety.',
                                  textAlign: TextAlign.center,
                                  // 🚀 ENGINE SYNC: Body Font
                                  style: AppTheme.getBodyStyle(
                                    fontSize: isMobile ? 18 : 24,
                                    weight: FontWeight.w500,
                                    color: AppTheme.textMain,
                                  ).copyWith(height: 1.6),
                                ),
                                const SizedBox(height: 40),
                                Divider(
                                  color: AppTheme.accent.withValues(alpha: 0.2), 
                                  indent: 50, 
                                  endIndent: 50
                                ),
                                const SizedBox(height: 40),
                                Text(
                                  'We aim to simplify event execution by providing trained professionals capable of handling every segment of event management with discipline and efficiency.',
                                  textAlign: TextAlign.center,
                                  // 🚀 ENGINE SYNC: Body Font
                                  style: AppTheme.getBodyStyle(
                                    fontSize: isMobile ? 14 : 17,
                                    color: AppTheme.textSub,
                                  ).copyWith(height: 1.8),
                                ),
                              ],
                            ),
                          ),
                          300,
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
}