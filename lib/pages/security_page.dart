import 'package:flutter/material.dart';

// Hamare banaye hue Custom Widgets aur Theme Engine
import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 ASLI SHAKTI YAHAN HAI

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    return Scaffold(
      // 🎨 ENGINE SYNC: Global Background
      backgroundColor: AppTheme.bg, 
      body: Column(
        children: [
          const CustomNavbar(), // TOP NAVBAR
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- PAGE HEADER SECTION ---
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 80, // Thoda extra space premium look ke liye
                    ),
                    // 🎨 ENGINE SYNC: Dynamic Header Color (Gradient ya Solid toggle ke hisaab se)
                    decoration: BoxDecoration(
                      color: AppTheme.enableGradients ? null : AppTheme.cardBg.withValues(alpha: 0.3),
                      gradient: AppTheme.enableGradients ? LinearGradient(
                        colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.3)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ) : null,
                    ),
                    child: Column(
                      children: [
                        // 🚀 ENGINE SYNC: Global Animation Engine & Heading Font used
                        AppTheme.applyAnim(
                          Text(
                            'Security & Staff',
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 36 : 56,
                              weight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          100,
                        ),
                        const SizedBox(height: 15),
                        // 🚀 ENGINE SYNC: Body Font used
                        AppTheme.applyAnim(
                          Text(
                            'ENSURING SAFETY, ORDER, AND SEAMLESS SUPPORT FOR YOUR EVENT',
                            textAlign: TextAlign.center,
                            style: AppTheme.getBodyStyle(
                              fontSize: isMobile ? 12 : 16,
                              weight: FontWeight.w600,
                              color: AppTheme.accent, 
                            ).copyWith(letterSpacing: 3.0),
                          ),
                          300,
                        ),
                      ],
                    ),
                  ),

                  // --- CONTENT SECTION (Guards, Bouncers, Porters) ---
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 80,
                    ),
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildSecurityCard(
                          'Security Guards',
                          Icons.security_outlined,
                          [
                            'Venue safety & surveillance',
                            'Access control and crowd supervision',
                            'Gate management',
                            'Guest safety monitoring',
                          ],
                          100,
                        ),
                        _buildSecurityCard(
                          'Bouncers',
                          Icons.shield_outlined,
                          [
                            'High-crowd management',
                            'VIP protection',
                            'Stage and backstage security',
                            'Emergency response support',
                          ],
                          200,
                        ),
                        _buildSecurityCard(
                          'Porters / Helpers',
                          Icons.people_outline,
                          [
                            'Setup & dismantle support',
                            'Equipment and material handling',
                            'Backstage & logistic assistance',
                          ],
                          300,
                        ),
                      ],
                    ),
                  ),

                  const CustomFooter(), // BOTTOM FOOTER
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Card with UI Style Engine ---
  Widget _buildSecurityCard(String title, IconData icon, List<String> points, int delay) {
    return AppTheme.applyAnim(
      Container(
        width: 350,
        padding: const EdgeInsets.all(35),
        // 🚀 ENGINE SYNC: UI Style Engine (Glass, Flat, Solid, Bordered, Neumorphism)
        decoration: AppTheme.getCardDecoration(isHovered: false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 35, color: AppTheme.accent), // 🎨 ENGINE SYNC: Dynamic Icon Color
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    // 🚀 ENGINE SYNC: Heading Font
                    style: AppTheme.getHeadingStyle(
                      fontSize: 24,
                      weight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Divider(color: AppTheme.accent.withValues(alpha: 0.2)),
            const SizedBox(height: 25),
            ...points.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.verified_user_rounded, 
                           size: 18, 
                           color: AppTheme.accent.withValues(alpha: 0.7)), // 🎨 ENGINE SYNC
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          point,
                          // 🚀 ENGINE SYNC: Body Font
                          style: AppTheme.getBodyStyle(
                            fontSize: 15,
                            color: AppTheme.textSub,
                          ).copyWith(height: 1.5),
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