import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // ==========================================
  // 🤫 ADMIN SECRETS
  // ==========================================
  int _secretTapCount = 0;
  final String _adminPasscode = "LOVEDAYBITTU"; 
  late AnimationController _pulseController;

  // ==========================================
  // 📸 MASSIVE GALLERY DATA
  // ==========================================
  final List<String> _gallery30 = [
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/1.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/2.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/3.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/4.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/5.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/6.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/7.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/8.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/9.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/10.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/11.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/12.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/13.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/14.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/15.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/16.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/17.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/18.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/19.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/20.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/21.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/22.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/23.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/24.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/25.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/26.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/27.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/28.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/29.jpg',
    'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/30.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ==========================================
  // 🔊 SOUND ENGINE
  // ==========================================
  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else if (AppTheme.soundPack == 'clicky') {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  // ==========================================
  // 🛠️ GOD MODE: OBJECT EDITOR DIALOG
  // ==========================================
  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    TextEditingController textCtrl = TextEditingController(text: provider.elementSettings['${elementKey}_text'] ?? defaultText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.95), 
        shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5), borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
        title: const Text("✏️ Edit Object", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white), 
              maxLines: 3,
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white.withValues(alpha: 0.05), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
              ),
              onChanged: (val) => provider.updateElement('${elementKey}_text', val),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton.icon(
                onPressed: () { 
                  provider.clearElementSetting('${elementKey}_text'); 
                  Navigator.pop(ctx); 
                },
                icon: const Icon(Icons.refresh, size: 16), 
                label: const Text("Reset", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent, 
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            )
          ],
        ),
        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: Text("DONE", style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold))
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // 🎯 GOD MODE: EDITABLE WRAPPER
  // ==========================================
  Widget _buildEditable(BuildContext context, ThemeProvider provider, String key, String defaultText, Widget child) {
    if (!provider.isSelectionMode) return child; 
    return GestureDetector(
      onTap: () {
        _triggerSound();
        _showObjectEditor(context, provider, key, defaultText);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent, width: 2, style: BorderStyle.solid), 
            color: Colors.pinkAccent.withValues(alpha: 0.05), 
            borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 
          child: child,
        ),
      ),
    );
  }

  // ==========================================
  // 🔐 ADMIN PASSCODE DIALOG
  // ==========================================
  void _showPasscodeDialog(ThemeProvider provider) {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: AppTheme.accent, width: 1)),
        title: Text('RESTRICTED AREA', style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent)),
        content: TextField(
          controller: passController, obscureText: true, style: const TextStyle(color: Colors.white), 
          decoration: InputDecoration(
            hintText: 'Enter Admin Passcode', hintStyle: const TextStyle(color: Colors.white54),
            filled: true, fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            onPressed: () { 
              if (passController.text == _adminPasscode) { 
                provider.unlockGodMode(); 
                Navigator.pop(context); 
              } 
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent), 
            child: const Text('OVERRIDE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }

  // ==========================================
  // ⚡ DYNAMIC SCROLL PHYSICS
  // ==========================================
  ScrollPhysics _getScrollPhysics() {
    switch (AppTheme.scrollEffect) {
      case 'bouncy': return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
      case 'snappy': return const PageScrollPhysics();
      case 'smooth':
      default: return const ClampingScrollPhysics();
    }
  }

  // ==========================================
  // 🏗️ MAIN BUILD METHOD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: MouseRegion(
            cursor: SystemMouseCursors.basic, 
            child: Stack(
              children: [
                // 🌌 BACKGROUND ENGINE
                Container(decoration: AppTheme.getBackgroundDecoration()),
                
                // 🧩 MAIN CONTENT
                Column(
                  children: [
                    if (AppTheme.navbarStyle != 'hidden') const CustomNavbar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: _getScrollPhysics(), 
                        child: Column(
                          children: [
                            _buildDynamicHero(context, provider), 
                            _buildShortInfoStrip(context, provider), 
                            
                            // 🚀 NEW: Our Expertise / Services Section
                            _buildExpertiseSection(context, provider),
                            
                            // 🚀 NEW: Company Stats / Trust Builder
                            _buildStatsSection(context, provider),
                            
                            _buildWhyFortuneSection(context, provider),
                            _buildVibeGallery(context, provider), 
                            _buildMassiveGallery(context), 
                            _buildCustomerRatingsSection(context, provider), 
                            if (AppTheme.footerStyle != 'hidden') const CustomFooter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // ==========================================
  // 🌟 DYNAMIC HERO SECTION
  // ==========================================
  Widget _buildDynamicHero(BuildContext context, ThemeProvider provider) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800 || AppTheme.mobileLayout == 'compact';
    double radius = AppTheme.borderStyle == 'sharp' ? 0.0 : AppTheme.getGlobalRadius() * 2;
    
    TextAlign heroTextAlign = AppTheme.heroStyle == 'centered' 
        ? TextAlign.center 
        : (AppTheme.heroStyle == 'right' ? TextAlign.end : TextAlign.start);
        
    CrossAxisAlignment heroCrossAlign = AppTheme.heroStyle == 'left' 
        ? CrossAxisAlignment.start 
        : (AppTheme.heroStyle == 'right' ? CrossAxisAlignment.end : CrossAxisAlignment.center);

    return SizedBox(
      width: double.infinity,
      height: AppTheme.heroStyle == 'fullscreen' ? screenSize.height : (isMobile ? screenSize.height * 0.85 : screenSize.height * 0.90), 
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🎞️ CAROUSEL BACKGROUND
          AppTheme.applyImageFilter(
            CarouselSlider(
              options: CarouselOptions(
                height: double.infinity, 
                viewportFraction: 1.0, 
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 400 : (AppTheme.transitionSpeed == 'slow' ? 1200 : 800)), 
              ),
              items: [
                'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/1 (1).jpg',
                'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/1 (2).jpg',
                'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/1 (3).jpg',
                'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/1 (4).jpg',
              ].map((img) => Image.network(img, fit: BoxFit.cover, width: double.infinity)).toList(),
            ),
          ),
          
          // 🖤 GRADIENT OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.bg.withValues(alpha: 0.8), 
                  Colors.black.withValues(alpha: 0.4), 
                  AppTheme.bg.withValues(alpha: 0.95), // Fade nicely into next section
                ], 
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter
              )
            )
          ),
          
          // 📝 HERO CONTENT BOX
          Align(
            alignment: AppTheme.heroStyle == 'left' ? Alignment.centerLeft : (AppTheme.heroStyle == 'right' ? Alignment.centerRight : Alignment.center),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.heroStyle == 'centered' ? 20.0 : (isMobile ? 20.0 : 60.0)), 
              child: AppTheme.applyAnim(
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: AppTheme.enableBlur ? 15 : 0.001, sigmaY: AppTheme.enableBlur ? 15 : 0.001),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 25 : 50), 
                      decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
                        color: AppTheme.enableBlur ? AppTheme.cardBg.withValues(alpha: 0.5) : AppTheme.cardBg.withValues(alpha: 0.85),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: heroCrossAlign,
                        children: [
                          _buildEditable(
                            context, provider, 'hero_top_tag', 'THE STANDARD FOR EXCELLENCE', 
                            Text(
                              provider.elementSettings['hero_top_tag_text'] ?? 'THE STANDARD FOR EXCELLENCE', 
                              style: AppTheme.getBodyStyle(fontSize: isMobile ? 10 : 12, color: AppTheme.accent, weight: FontWeight.w800).copyWith(letterSpacing: 4),
                              textAlign: heroTextAlign, 
                            )
                          ),
                          
                          const SizedBox(height: 20),
                          
                          GestureDetector(
                            onTap: () { 
                              _triggerSound();
                              if (!provider.isGodModeUnlocked) { _secretTapCount++; if (_secretTapCount >= 5) _showPasscodeDialog(provider); } 
                            },
                            child: _buildEditable(
                              context, provider, 'hero_title', AppTheme.heroTitle, 
                              Text(
                                provider.elementSettings['hero_title_text'] ?? AppTheme.heroTitle, 
                                textAlign: heroTextAlign, 
                                style: AppTheme.getHeadingStyle(fontSize: isMobile ? 36 : 68, color: AppTheme.textMain).copyWith( 
                                  letterSpacing: -1.0, 
                                  shadows: [Shadow(color: AppTheme.textMain.withValues(alpha: 0.2), offset: const Offset(0, 4), blurRadius: 20)]
                                )
                              )
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildEditable(
                            context, provider, 'hero_subtitle', AppTheme.heroSubtitle, 
                            Text(
                              provider.elementSettings['hero_subtitle_text'] ?? AppTheme.heroSubtitle, 
                              textAlign: heroTextAlign, 
                              style: AppTheme.getBodyStyle(fontSize: isMobile ? 15 : 20, color: AppTheme.textSub.withValues(alpha: 0.9), weight: FontWeight.w500).copyWith(height: 1.5)
                            )
                          ), 
                          
                          const SizedBox(height: 40),
                          
                          _buildCTAButton(context, provider),

                          const SizedBox(height: 40),

                          // 🚀 PREMIUM TRUST BADGES
                          Wrap(
                            spacing: 15, runSpacing: 15,
                            alignment: AppTheme.heroStyle == 'centered' ? WrapAlignment.center : WrapAlignment.start,
                            children: [
                              _buildHeroTrustBadge(context, provider, 'badge1', Icons.star_border_rounded, '100+ Events'),
                              _buildHeroTrustBadge(context, provider, 'badge2', Icons.shield_outlined, '100% Reliable Staff'),
                              _buildHeroTrustBadge(context, provider, 'badge3', Icons.military_tech_outlined, 'Industry Leaders'),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                0, 
              ),
            ),
          ),
          
          // 🖱️ SCROLL INDICATOR (Animated)
          Positioned(
            bottom: 30, left: 0, right: 0,
            child: FadeTransition(
              opacity: _pulseController,
              child: Column(
                children: [
                  Text("SCROLL TO EXPLORE", style: AppTheme.getBodyStyle(fontSize: 10, color: AppTheme.textSub).copyWith(letterSpacing: 2.0)),
                  const SizedBox(height: 10),
                  Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.accent, size: 28),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // 🚀 HERO TRUST BADGE WIDGET
  // ==========================================
  Widget _buildHeroTrustBadge(BuildContext context, ThemeProvider provider, String id, IconData icon, String defaultText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bg.withValues(alpha: 0.5),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.accent, size: 16),
          const SizedBox(width: 8),
          _buildEditable(
            context, provider, id, defaultText,
            Text(
              provider.elementSettings['${id}_text'] ?? defaultText,
              style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.textMain, weight: FontWeight.w600),
            )
          )
        ],
      ),
    );
  }

  // ==========================================
  // 🔘 CTA BUTTON
  // ==========================================
  Widget _buildCTAButton(BuildContext context, ThemeProvider provider) {
    return _buildEditable(
      context, provider, 'hero_btn', 'Book Your Event Now',
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent, 
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 22), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'sharp' ? 0 : (AppTheme.buttonStyle == 'pill' ? 50 : 8)), 
            ),
            elevation: AppTheme.enableShadows ? 15 : 0, 
            shadowColor: AppTheme.accent.withValues(alpha: 0.6),
          ),
          onPressed: () { 
            _triggerSound(); 
            context.go('/contact'); 
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                provider.elementSettings['hero_btn_text'] ?? 'Book Your Event Now', 
                style: AppTheme.getBodyStyle(fontSize: 16, color: Colors.black, weight: FontWeight.bold).copyWith(letterSpacing: 1.0)
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 20)
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 🚀 SHORT INFO STRIP
  // ==========================================
  Widget _buildShortInfoStrip(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 70, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.03),
        border: Border.symmetric(horizontal: BorderSide(color: AppTheme.accent.withValues(alpha: 0.1), width: 1)),
      ),
      child: Column(
        children: [
          _buildEditable(
            context, provider, 'strip_text_1', 'We provide complete event manpower solutions',
            Text(
              provider.elementSettings['strip_text_1_text'] ?? 'We provide complete event manpower solutions',
              style: AppTheme.getHeadingStyle(fontSize: isMobile ? 24 : 36, color: AppTheme.textMain, weight: FontWeight.w600),
              textAlign: TextAlign.center,
            )
          ),
          const SizedBox(height: 15),
          _buildEditable(
            context, provider, 'strip_text_2', '—from security to hospitality— all in one place.',
            Text(
              provider.elementSettings['strip_text_2_text'] ?? '—from security to hospitality— all in one place.',
              style: AppTheme.getBodyStyle(fontSize: isMobile ? 16 : 24, color: AppTheme.accent, weight: FontWeight.w400).copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            )
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🆕 OUR EXPERTISE (SERVICES) SECTION
  // ==========================================
  Widget _buildExpertiseSection(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 800;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 20 : 60),
      child: Column(
        children: [
          _buildEditable(
            context, provider, 'expertise_title', 'Our Core Expertise',
            Text(
              provider.elementSettings['expertise_title_text'] ?? 'Our Core Expertise',
              style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 52, color: AppTheme.textMain, weight: FontWeight.w800).copyWith(letterSpacing: -1.0),
              textAlign: TextAlign.center,
            )
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 30, runSpacing: 30, alignment: WrapAlignment.center,
            children: [
              _buildExpertiseCard(context, provider, 'exp1', Icons.business_center, 'Corporate Events', 'Seamless management for conferences, seminars, and corporate galas.'),
              _buildExpertiseCard(context, provider, 'exp2', Icons.favorite, 'Luxury Weddings', 'Premium hospitality and security to make your special day flawless.'),
              _buildExpertiseCard(context, provider, 'exp3', Icons.music_note, 'Live Concerts', 'Robust crowd management and artist security for massive audiences.'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildExpertiseCard(BuildContext context, ThemeProvider provider, String id, IconData icon, String defaultTitle, String defaultDesc) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return _ParallaxWrapper(
      child: Container(
        width: isMobile ? double.infinity : 350,
        padding: const EdgeInsets.all(35),
        decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: AppTheme.accent),
            const SizedBox(height: 20),
            _buildEditable(
              context, provider, '${id}_title', defaultTitle,
              Text(provider.elementSettings['${id}_title_text'] ?? defaultTitle, style: AppTheme.getHeadingStyle(fontSize: 22, color: AppTheme.textMain, weight: FontWeight.bold))
            ),
            const SizedBox(height: 15),
            _buildEditable(
              context, provider, '${id}_desc', defaultDesc,
              Text(provider.elementSettings['${id}_desc_text'] ?? defaultDesc, style: AppTheme.getBodyStyle(fontSize: 15, color: AppTheme.textSub).copyWith(height: 1.6))
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🆕 COMPANY STATS SECTION (TRUST BUILDER)
  // ==========================================
  Widget _buildStatsSection(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: isMobile ? 20 : 60),
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 40, runSpacing: 40,
        children: [
          _buildStatItem(context, provider, 'stat1', '100+', 'Successful Events'),
          _buildStatItem(context, provider, 'stat2', '1000+', 'Trained Staff'),
          _buildStatItem(context, provider, 'stat3', '100%', 'Client Satisfaction'),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, ThemeProvider provider, String id, String defaultNum, String defaultLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEditable(
          context, provider, '${id}_num', defaultNum,
          Text(provider.elementSettings['${id}_num_text'] ?? defaultNum, style: AppTheme.getHeadingStyle(fontSize: 48, color: AppTheme.accent, weight: FontWeight.w900))
        ),
        const SizedBox(height: 8),
        _buildEditable(
          context, provider, '${id}_label', defaultLabel,
          Text(provider.elementSettings['${id}_label_text'] ?? defaultLabel, style: AppTheme.getBodyStyle(fontSize: 16, color: AppTheme.textMain, weight: FontWeight.w600).copyWith(letterSpacing: 1.5))
        ),
      ],
    );
  }

  // ==========================================
  // ⭐ WHY FORTUNE SECTION
  // ==========================================
  Widget _buildWhyFortuneSection(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 80), 
      child: Column(
        children: [
          _buildEditable(
            context, provider, 'why_title', 'Why Choose Us?', 
            Text(
              provider.elementSettings['why_title_text'] ?? 'Why Choose Us?', 
              style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 52, color: AppTheme.textMain, weight: FontWeight.w800).copyWith(letterSpacing: -1.0),
              textAlign: TextAlign.center, 
            )
          ),
          
          const SizedBox(height: 60),
          
          Wrap(
            spacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, 
            runSpacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, 
            alignment: WrapAlignment.center, 
            children: [
              _buildFeature(context, provider, 'f1', Icons.verified_user_outlined, 'Trained Professionals', 'Every executive, coordinator, porter, and security staff follows rigorous industry standards.'),
              _buildFeature(context, provider, 'f2', Icons.groups_outlined, 'Complete Staffing Solutions', 'From elite hospitality to robust security, we provide all critical manpower under one roof.'),
              _buildFeature(context, provider, 'f3', Icons.access_time_outlined, 'High Reliability', 'Punctual, disciplined, and flawlessly event-ready staff at your command.'),
              _buildFeature(context, provider, 'f4', Icons.star_outline, 'Experienced Team Leaders', 'Highly skilled supervisors ensuring absolute smooth execution on-ground.'),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🖼️ VIBE GALLERY TITLE
  // ==========================================
  Widget _buildVibeGallery(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        SizedBox(height: isMobile ? 60 : 100),
        _buildEditable(
          context, provider, 'vibe_title', 'Experience The Vibe', 
          Text(
            provider.elementSettings['vibe_title_text'] ?? 'Experience The Vibe', 
            style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 52, color: AppTheme.textMain, weight: FontWeight.w800).copyWith(letterSpacing: -1.0),
            textAlign: TextAlign.center, 
          )
        ),
        const SizedBox(height: 40), 
      ],
    );
  }

  // ==========================================
  // 🧱 MASSIVE MASONRY GALLERY
  // ==========================================
  Widget _buildMassiveGallery(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600 || AppTheme.mobileLayout == 'compact';
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40), color: Colors.transparent, 
      child: MasonryGridView.count(
        crossAxisCount: isMobile ? 2 : (AppTheme.layoutStyle == 'grid' ? 4 : 5), 
        mainAxisSpacing: AppTheme.layoutStyle == 'dense' ? 8 : 20, 
        crossAxisSpacing: AppTheme.layoutStyle == 'dense' ? 8 : 20, 
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _gallery30.length,
        itemBuilder: (context, index) => AppTheme.applyAnim(
          _ParallaxWrapper( 
            child: AppTheme.applyImageFilter( 
              Container(
                decoration: AppTheme.getCardDecoration(isHovered: false),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
                  child: Image.network(_gallery30[index], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          (index % 5) * (AppTheme.transitionSpeed == 'fast' ? 20 : 50), 
        ),
      ),
    );
  }

  // ==========================================
  // ⭐ CUSTOMER RATINGS & REVIEWS SECTION
  // ==========================================
  Widget _buildCustomerRatingsSection(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          _buildEditable(
            context, provider, 'rating_title', 'What Our Clients Say',
            Text(
              provider.elementSettings['rating_title_text'] ?? 'What Our Clients Say',
              style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 48, color: AppTheme.textMain, weight: FontWeight.w800).copyWith(letterSpacing: -1.0),
              textAlign: TextAlign.center,
            )
          ),
          const SizedBox(height: 60),
          
          SizedBox(
            height: 250, 
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildReviewCard(context, provider, 'rev1', 'Absolutely flawless execution. The security team was highly professional and polite. Will definitely hire again.', 'Rajesh Verma', 'Corporate Event Planner'),
                _buildReviewCard(context, provider, 'rev2', 'Best event management staffing we have ever hired. They handled our crowd of 5000+ smoothly without any chaos.', 'Amit Singhal', 'Wedding Organizer'),
                _buildReviewCard(context, provider, 'rev3', 'The valet and hospitality team made our VIP guests feel incredibly special. Highly recommended!', 'Neha Sharma', 'Private Gala Host'),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper for Individual Review Cards
  Widget _buildReviewCard(BuildContext context, ThemeProvider provider, String id, String defaultReview, String defaultName, String defaultRole) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return _ParallaxWrapper(
      child: Container(
        width: isMobile ? 300 : 400,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(30),
        decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 24)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildEditable(
                context, provider, '${id}_text', defaultReview,
                Text(
                  provider.elementSettings['${id}_text_text'] ?? defaultReview,
                  style: AppTheme.getBodyStyle(fontSize: 16, color: AppTheme.textSub).copyWith(fontStyle: FontStyle.italic, height: 1.5),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                )
              ),
            ),
            const SizedBox(height: 15),
            _buildEditable(
              context, provider, '${id}_name', defaultName,
              Text(
                provider.elementSettings['${id}_name_text'] ?? defaultName,
                style: AppTheme.getBodyStyle(fontSize: 18, color: AppTheme.textMain, weight: FontWeight.bold),
              )
            ),
            const SizedBox(height: 4),
            _buildEditable(
              context, provider, '${id}_role', defaultRole,
              Text(
                provider.elementSettings['${id}_role_text'] ?? defaultRole,
                style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.accent, weight: FontWeight.w600).copyWith(letterSpacing: 1.0),
              )
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🧩 FEATURE CARD BUILDER
  // ==========================================
  Widget _buildFeature(BuildContext context, ThemeProvider provider, String id, IconData icon, String defaultTitle, String defaultDesc) {
    return _FeatureCard(
      icon: icon, 
      titleWidget: _buildEditable(
        context, provider, 'feat_${id}_title', defaultTitle, 
        Text(
          provider.elementSettings['feat_${id}_title_text'] ?? defaultTitle, 
          style: AppTheme.getHeadingStyle(fontSize: 20, color: AppTheme.textMain, weight: FontWeight.w700), 
          textAlign: TextAlign.center
        )
      ),
      descWidget: _buildEditable(
        context, provider, 'feat_${id}_desc', defaultDesc, 
        Text(
          provider.elementSettings['feat_${id}_desc_text'] ?? defaultDesc, 
          style: AppTheme.getBodyStyle(fontSize: 15, color: AppTheme.textSub).copyWith(height: 1.6), 
          textAlign: TextAlign.center
        )
      ),
    );
  }
}

// ==========================================
// 🌀 3D PARALLAX WRAPPER
// ==========================================
class _ParallaxWrapper extends StatefulWidget {
  final Widget child; const _ParallaxWrapper({required this.child});
  @override State<_ParallaxWrapper> createState() => _ParallaxWrapperState();
}
class _ParallaxWrapperState extends State<_ParallaxWrapper> {
  bool isHovered = false;
  
  Matrix4 _getParallaxTransform() {
    if (!isHovered) return AppTheme.getHoverTransform(false);
    
    double scale = 1.05;
    if (AppTheme.parallaxIntensity == 'high') scale = 1.15;
    if (AppTheme.parallaxIntensity == 'none') scale = 1.0;
    
    return Matrix4.identity()..multiply(Matrix4.diagonal3Values(scale, scale, 1.0));
  }

  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : (AppTheme.transitionSpeed == 'slow' ? 500 : 300)),
        curve: Curves.easeOutCubic,
        transformAlignment: FractionalOffset.center,
        transform: _getParallaxTransform(),
        child: widget.child, 
      ),
    );
  }
}

// ==========================================
// 🃏 INDIVIDUAL FEATURE CARD COMPONENT
// ==========================================
class _FeatureCard extends StatefulWidget {
  final IconData icon; final Widget titleWidget; final Widget descWidget;
  const _FeatureCard({required this.icon, required this.titleWidget, required this.descWidget});
  @override State<_FeatureCard> createState() => _FeatureCardState();
}
class _FeatureCardState extends State<_FeatureCard> {
  bool isHovered = false;
  
  @override Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky') HapticFeedback.selectionClick();
      }, 
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300),
        width: isMobile ? MediaQuery.of(context).size.width * 0.85 : 340, 
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40), 
        transformAlignment: FractionalOffset.center,
        decoration: AppTheme.getCardDecoration(isHovered: isHovered).copyWith(
          borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
          boxShadow: AppTheme.enableShadows && isHovered ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.25), blurRadius: 30, spreadRadius: 2, offset: const Offset(0, 10))] : [],
        ),
        transform: AppTheme.getHoverTransform(isHovered),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHovered ? AppTheme.accent : AppTheme.accent.withValues(alpha: 0.1),
                boxShadow: (AppTheme.enableGlow && isHovered) ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.4), blurRadius: 20)] : []
              ),
              child: Icon(widget.icon, size: 38, color: isHovered ? Colors.black : AppTheme.accent), 
            ),
            const SizedBox(height: 25), 
            widget.titleWidget, 
            const SizedBox(height: 15), 
            widget.descWidget
          ]
        ),
      ),
    );
  }
}