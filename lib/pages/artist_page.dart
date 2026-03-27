import 'package:flutter/material.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    return Scaffold(
      // 🎨 ENGINE SYNC: Global Background
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          const CustomNavbar(),
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- PAGE HEADER ---
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 80,
                    ),
                    // 🎨 ENGINE SYNC: Dynamic Gradient check
                    decoration: BoxDecoration(
                      color: AppTheme.enableGradients ? null : AppTheme.cardBg.withValues(alpha: 0.3),
                      gradient: AppTheme.enableGradients ? LinearGradient(
                        colors: [
                          AppTheme.activeTheme == 'luxury' 
                              ? Colors.deepPurple.shade900 
                              : AppTheme.cardBg.withValues(alpha: 0.8), 
                          AppTheme.bg
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ) : null,
                    ),
                    child: Column(
                      children: [
                        // 🚀 ENGINE SYNC: Global Animation Engine & Font Engine
                        AppTheme.applyAnim(
                          Text(
                            'Artist & Talent Management',
                            textAlign: TextAlign.center,
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 32 : 56,
                              weight: FontWeight.bold,
                              color: AppTheme.textMain, // 🎨 Dynamic Text Color
                            ),
                          ),
                          100,
                        ),
                        const SizedBox(height: 15),
                        // 🚀 ENGINE SYNC: Font Engine
                        AppTheme.applyAnim(
                          Text(
                            'SEAMLESS COORDINATION & SPECIALIZED SECURITY FOR VIPS',
                            textAlign: TextAlign.center,
                            style: AppTheme.getBodyStyle(
                              fontSize: isMobile ? 12 : 16,
                              weight: FontWeight.w600,
                              color: AppTheme.accent, // 🎨 Dynamic Accent Color
                            ).copyWith(letterSpacing: 3.0),
                          ),
                          300,
                        ),
                      ],
                    ),
                  ),

                  // --- MAIN CONTENT CARDS ---
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 60,
                    ),
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildArtistCard(
                          title: 'Talent Coordination',
                          icon: Icons.mic_external_on_outlined,
                          description: 'We provide seamless coordination between artists and event organizers ensuring all technical and hospitality riders are met with precision.',
                          features: [
                            'Artist Liaison & Shadowing',
                            'Technical Rider Management',
                            'Hospitality & Travel Coordination',
                          ],
                          delay: 400,
                        ),
                        _buildArtistCard(
                          title: 'Crowd Control',
                          icon: Icons.groups_outlined,
                          description: 'Specialized security and crowd management for artist zones, ensuring a safe and controlled environment for talent and guests alike.',
                          features: [
                            'Backstage Security',
                            'Green Room Management',
                            'Entry/Exit Point Control',
                            'VVIP Zone Security',
                          ],
                          delay: 600,
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

  // --- Reusable Card with UI Style Engine ---
  Widget _buildArtistCard({
    required String title,
    required IconData icon,
    required String description,
    required List<String> features,
    required int delay,
  }) {
    return AppTheme.applyAnim(
      Container(
        width: 450, // Card width optimized
        padding: const EdgeInsets.all(40),
        // 🚀 ENGINE SYNC: UI Style Engine (Glass, Flat, Solid, Neumorphism, etc.)
        decoration: AppTheme.getCardDecoration(isHovered: false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 35, color: AppTheme.accent),
            ),
            const SizedBox(height: 25),
            // 🚀 ENGINE SYNC: Heading Font
            Text(
              title,
              style: AppTheme.getHeadingStyle(
                fontSize: 28,
                weight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 15),
            // 🚀 ENGINE SYNC: Body Font
            Text(
              description,
              style: AppTheme.getBodyStyle(
                fontSize: 15,
                color: AppTheme.textSub,
              ).copyWith(height: 1.6),
            ),
            const SizedBox(height: 30),
            Divider(color: AppTheme.accent.withValues(alpha: 0.2)),
            const SizedBox(height: 25),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.star_rounded, size: 20, color: AppTheme.accent), // 🎨 Accent Star
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          // 🚀 ENGINE SYNC: Feature List Font
                          style: AppTheme.getBodyStyle(
                            fontSize: 15,
                            weight: FontWeight.w500,
                            color: AppTheme.textMain,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      delay,
    );
  }
}