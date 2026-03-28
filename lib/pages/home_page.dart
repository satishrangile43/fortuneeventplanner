import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 🤫 SECRET VARIABLES
  int _secretTapCount = 0;
  final String _adminPasscode = "LOVEDAYBITTU"; // 🔐 TERA SECRET PASSWORD

  // 📸 30 MASSIVE GALLERY IMAGES
  final List<String> _gallery30 = [
    'https://images.unsplash.com/photo-1511527661048-7fe73d85e9a4?w=500', 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=500',
    'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=500', 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=500',
    'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=500', 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500',
    'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=500', 'https://images.unsplash.com/photo-1533174000220-db7f34149b5c?w=500',
    'https://images.unsplash.com/photo-1520110120835-c96534a4c984?w=500', 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=500',
    'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=500', 'https://images.unsplash.com/photo-1531058020387-3be344556be6?w=500',
    'https://images.unsplash.com/photo-1511765224389-37f0e77cf0eb?w=500', 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=500',
    'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=500', 'https://images.unsplash.com/photo-1555244162-803834f70033?w=500',
    'https://images.unsplash.com/photo-1414235077428-3389886e5643?w=500', 'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?w=500',
    'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=500', 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=500',
    'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=500', 'https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=500',
    'https://images.unsplash.com/photo-1551818255-e6e10975bc17?w=500', 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=500',
    'https://images.unsplash.com/photo-1530103862676-de8892bc952f?w=500', 'https://images.unsplash.com/photo-1586528116311-ad8ed7c1590a?w=500',
    'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=500', 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=500',
    'https://images.unsplash.com/photo-1511765224389-37f0e77cf0eb?w=500', 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500',
  ];

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

  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    TextEditingController textCtrl = TextEditingController(text: provider.elementSettings['${elementKey}_text'] ?? defaultText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.95), // 🟢 FIX: Darker for focus
        shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5), borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
        title: const Text("✏️ Edit Object", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white), maxLines: 3,
              decoration: InputDecoration(
                filled: true, 
                fillColor: Colors.white.withValues(alpha: 0.05), // 🟢 FIX: Better contrast input
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
              ),
              onChanged: (val) => provider.updateElement('${elementKey}_text', val),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton.icon(
                onPressed: () { provider.clearElementSetting('${elementKey}_text'); Navigator.pop(ctx); },
                icon: const Icon(Icons.refresh, size: 16), label: const Text("Reset", style: TextStyle(fontWeight: FontWeight.bold)),
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
            child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text("DONE", style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }

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
            color: Colors.pinkAccent.withValues(alpha: 0.05), // 🟢 FIX: Softer highlight
            borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // 🟢 FIX: Horizontal breathing room
          child: child,
        ),
      ),
    );
  }

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
          ElevatedButton(onPressed: () { if (passController.text == _adminPasscode) { provider.unlockGodMode(); Navigator.pop(context); } }, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent), child: const Text('OVERRIDE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  ScrollPhysics _getScrollPhysics() {
    switch (AppTheme.scrollEffect) {
      case 'bouncy': return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
      case 'snappy': return const PageScrollPhysics();
      case 'smooth':
      default: return const ClampingScrollPhysics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: MouseRegion(
            // 🟢 FIX: Uses basic mouse here, AppTheme cursor handles web specific overrides if needed
            cursor: SystemMouseCursors.basic, 
            child: Stack(
              children: [
                // ✨ Background Gradient Engine (Powered by AppTheme)
                Container(decoration: AppTheme.getBackgroundDecoration()),
                
                Column(
                  children: [
                    if (AppTheme.navbarStyle != 'hidden') const CustomNavbar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: _getScrollPhysics(), 
                        child: Column(
                          children: [
                            _buildDynamicHero(context, provider), 
                            _buildVibeGallery(context, provider),
                            _buildMassiveGallery(context), 
                            _buildWhyFortuneSection(context, provider),
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
  // 🚀 HERO WITH PARALLAX, RADIUS & LAYOUT ENGINE
  // ==========================================
  Widget _buildDynamicHero(BuildContext context, ThemeProvider provider) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800 || AppTheme.mobileLayout == 'compact';
    double radius = AppTheme.borderStyle == 'sharp' ? 0.0 : AppTheme.getGlobalRadius() * 2;
    
    return SizedBox(
      width: double.infinity,
      height: AppTheme.heroStyle == 'fullscreen' ? screenSize.height : (isMobile ? screenSize.height * 0.75 : screenSize.height * 0.85), // 🟢 FIX: Slightly taller on mobile
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🖼️ IMAGE FILTER SYNC
          AppTheme.applyImageFilter(
            CarouselSlider(
              options: CarouselOptions(
                height: double.infinity, 
                viewportFraction: 1.0, 
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 400 : (AppTheme.transitionSpeed == 'slow' ? 1200 : 800)), // 🟢 FIX: Smoother carousel
              ),
              items: [
                'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2070',
                'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=2070',
              ].map((img) => Image.network(img, fit: BoxFit.cover, width: double.infinity)).toList(),
            ),
          ),
          
          // 🟢 FIX: Ultra smooth gradient to blend hero into the rest of the page
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.bg.withValues(alpha: 0.7), // Top dark/light tint
                  Colors.black.withValues(alpha: 0.3), // Center clarity
                  AppTheme.bg // Bottom seamless merge
                ], 
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter
              )
            )
          ),
          
          Align(
            alignment: AppTheme.heroStyle == 'left' ? Alignment.centerLeft : (AppTheme.heroStyle == 'right' ? Alignment.centerRight : Alignment.center),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.heroStyle == 'centered' ? 20.0 : (isMobile ? 20.0 : 60.0)), // 🟢 FIX: Responsive padding
              child: AppTheme.applyAnim(
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: AppTheme.enableBlur ? 15 : 0.001, sigmaY: AppTheme.enableBlur ? 15 : 0.001),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 30 : 50), // 🟢 FIX: More breathing room
                      decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
                        // 🟢 FIX: Solid tint if blur is disabled for maximum text readability
                        color: AppTheme.enableBlur ? AppTheme.cardBg.withValues(alpha: 0.6) : AppTheme.cardBg.withValues(alpha: 0.85),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: AppTheme.heroStyle == 'left' ? CrossAxisAlignment.start : (AppTheme.heroStyle == 'right' ? CrossAxisAlignment.end : CrossAxisAlignment.center),
                        children: [
                          _buildEditable(context, provider, 'hero_top_tag', 'THE STANDARD FOR EXCELLENCE', 
                            Text(provider.elementSettings['hero_top_tag_text'] ?? 'THE STANDARD FOR EXCELLENCE', 
                            style: AppTheme.getBodyStyle(fontSize: 12, color: AppTheme.accent, weight: FontWeight.w800).copyWith(letterSpacing: 4))),
                          
                          const SizedBox(height: 25),
                          
                          GestureDetector(
                            onTap: () { 
                              _triggerSound();
                              if (!provider.isGodModeUnlocked) { _secretTapCount++; if (_secretTapCount >= 5) _showPasscodeDialog(provider); } 
                            },
                            child: _buildEditable(
                              context, provider, 'hero_title', AppTheme.heroTitle, 
                              Text(provider.elementSettings['hero_title_text'] ?? AppTheme.heroTitle, textAlign: AppTheme.heroStyle == 'centered' ? TextAlign.center : TextAlign.start, 
                              style: AppTheme.getHeadingStyle(fontSize: isMobile ? 36 : 64, color: AppTheme.textMain).copyWith( // 🟢 FIX: Larger impact desktop title
                                letterSpacing: -1.0, // Modern SaaS kerning
                                shadows: [Shadow(color: AppTheme.textMain.withValues(alpha: 0.15), offset: const Offset(0, 4), blurRadius: 15)]
                              ))),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildEditable(context, provider, 'hero_subtitle', AppTheme.heroSubtitle, 
                            Text(provider.elementSettings['hero_subtitle_text'] ?? AppTheme.heroSubtitle, textAlign: AppTheme.heroStyle == 'centered' ? TextAlign.center : TextAlign.start, 
                            style: AppTheme.getBodyStyle(fontSize: isMobile ? 15 : 18, color: AppTheme.textSub.withValues(alpha: 0.9), weight: FontWeight.w500).copyWith(height: 1.5))), // 🟢 FIX: Better line height
                          
                          const SizedBox(height: 40),
                          
                          _buildCTAButton(context, provider),
                        ],
                      ),
                    ),
                  ),
                ),
                0, // Index for animation
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(BuildContext context, ThemeProvider provider) {
    return _buildEditable(
      context, provider, 'hero_btn', AppTheme.heroCTA,
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent, 
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // 🟢 FIX: Thicker, more luxurious button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'sharp' ? 0 : (AppTheme.buttonStyle == 'pill' ? 50 : 12)), // 🟢 FIX: Subtle rounded option
            ),
            elevation: AppTheme.enableShadows ? 10 : 0, // 🟢 FIX: Stronger CTA shadow
            shadowColor: AppTheme.accent.withValues(alpha: 0.5),
          ),
          onPressed: () { 
            _triggerSound(); 
            context.go('/services'); 
          },
          child: Text(provider.elementSettings['hero_btn_text'] ?? AppTheme.heroCTA, style: AppTheme.getBodyStyle(fontSize: 16, color: Colors.black, weight: FontWeight.bold).copyWith(letterSpacing: 1.0)),
        ),
      ),
    );
  }

  // ==========================================
  // 🏢 30 MASSIVE GALLERY IMAGES WITH FILTERS
  // ==========================================
  Widget _buildMassiveGallery(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600 || AppTheme.mobileLayout == 'compact';
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40), color: Colors.transparent, 
      child: MasonryGridView.count(
        crossAxisCount: isMobile ? 2 : (AppTheme.layoutStyle == 'grid' ? 4 : 5), 
        mainAxisSpacing: AppTheme.layoutStyle == 'dense' ? 8 : 20, // 🟢 FIX: Spacing sync
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
  // 📋 WHY FORTUNE (UPGRADED UI SYNC & 7 POINTS)
  // ==========================================
  Widget _buildWhyFortuneSection(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 80), // 🟢 FIX: Balanced vertical padding
      color: Colors.transparent, // Background handled globally
      child: Column(
        children: [
          _buildEditable(context, provider, 'why_title', 'Why Fortune?', 
            Text(provider.elementSettings['why_title_text'] ?? 'Why Fortune?', style: AppTheme.getHeadingStyle(fontSize: isMobile ? 38 : 52, color: AppTheme.textMain, weight: FontWeight.w800).copyWith(letterSpacing: -1.0))),
          
          const SizedBox(height: 60),
          
          Wrap(
            spacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, // 🟢 FIX: Better responsive grid spacing
            runSpacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, 
            alignment: WrapAlignment.center, 
            children: [
              _buildFeature(context, provider, 'f1', Icons.verified_user_outlined, 'Trained Professionals', 'Every executive, coordinator, porter, and security staff follows rigorous industry standards.'),
              _buildFeature(context, provider, 'f2', Icons.groups_outlined, 'Complete Staffing Solutions', 'From elite hospitality to robust security, we provide all critical manpower under one roof.'),
              _buildFeature(context, provider, 'f3', Icons.access_time_outlined, 'High Reliability', 'Punctual, disciplined, and flawlessly event-ready staff at your command.'),
              _buildFeature(context, provider, 'f4', Icons.star_outline, 'Experienced Team Leaders', 'Highly skilled supervisors ensuring absolute smooth execution on-ground.'),
              _buildFeature(context, provider, 'f5', Icons.health_and_safety_outlined, 'Safety & Quality First', 'An unyielding emphasis on guest safety, seamless operations, and total event control.'),
              _buildFeature(context, provider, 'f6', Icons.zoom_out_map_outlined, 'Flexible & Scalable', 'Adaptable manpower available instantly for small, medium, and massive-scale events.'),
              _buildFeature(context, provider, 'f7', Icons.handshake_outlined, 'Client-Focused Approach', 'We work intimately with event companies to perfectly match their exact, unique requirements.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVibeGallery(BuildContext context, ThemeProvider provider) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      children: [
        SizedBox(height: isMobile ? 60 : 100),
        _buildEditable(context, provider, 'vibe_title', 'Experience The Vibe', 
          Text(provider.elementSettings['vibe_title_text'] ?? 'Experience The Vibe', style: AppTheme.getHeadingStyle(fontSize: isMobile ? 38 : 52, color: AppTheme.textMain, weight: FontWeight.w800).copyWith(letterSpacing: -1.0))),
        const SizedBox(height: 40), // 🟢 FIX: Tighter gap to gallery
      ],
    );
  }

  Widget _buildFeature(BuildContext context, ThemeProvider provider, String id, IconData icon, String defaultTitle, String defaultDesc) {
    return _FeatureCard(
      icon: icon, 
      titleWidget: _buildEditable(context, provider, 'feat_${id}_title', defaultTitle, Text(provider.elementSettings['feat_${id}_title_text'] ?? defaultTitle, style: AppTheme.getHeadingStyle(fontSize: 18, color: AppTheme.textMain, weight: FontWeight.w700), textAlign: TextAlign.center)),
      descWidget: _buildEditable(context, provider, 'feat_${id}_desc', defaultDesc, Text(provider.elementSettings['feat_${id}_desc_text'] ?? defaultDesc, style: AppTheme.getBodyStyle(fontSize: 14, color: AppTheme.textSub).copyWith(height: 1.6), textAlign: TextAlign.center)),
    );
  }
}

// 🚀 NAYA: PARALLAX & TILT ENGINE
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
    
    // 🟢 SUPER FIX: God Mode Scale Engine (Scale vector properly handled)
    return Matrix4.identity()..multiply(Matrix4.diagonal3Values(scale, scale, 1.0));
  }

  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : (AppTheme.transitionSpeed == 'slow' ? 500 : 300)),
        curve: Curves.easeOutCubic,
        transform: _getParallaxTransform(),
        child: widget.child, // Image is inside child
      ),
    );
  }
}

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
        width: isMobile ? MediaQuery.of(context).size.width * 0.85 : 340, // 🟢 FIX: Wider cards for 7 points to look full
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40), // 🟢 FIX: Taller padding
        decoration: AppTheme.getCardDecoration(isHovered: isHovered).copyWith(
          borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
          // 🟢 FIX: Gorgeous subtle hover glow shadow
          boxShadow: AppTheme.enableShadows && isHovered ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.25), blurRadius: 30, spreadRadius: 2, offset: const Offset(0, 10))] : [],
        ),
        transform: AppTheme.getHoverTransform(isHovered),
        child: Column(
          children: [
            // 🟢 FIX: Glowing inverted icon on hover
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isHovered ? AppTheme.accent : AppTheme.accent.withValues(alpha: 0.1),
                boxShadow: (AppTheme.enableGlow && isHovered) ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.4), blurRadius: 20)] : []
              ),
              child: Icon(widget.icon, size: 35, color: isHovered ? Colors.white : AppTheme.accent), 
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