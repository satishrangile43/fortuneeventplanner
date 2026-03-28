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

  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    TextEditingController textCtrl = TextEditingController(text: provider.elementSettings['${elementKey}_text'] ?? defaultText);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.accent, width: 1), borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white), maxLines: 3,
              decoration: InputDecoration(filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
              onChanged: (val) => provider.updateElement('${elementKey}_text', val),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () { provider.clearElementSetting('${elementKey}_text'); Navigator.pop(ctx); },
                icon: const Icon(Icons.refresh, size: 16), label: const Text("Reset"),
              ),
            )
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("DONE"))],
      ),
    );
  }

  Widget _buildEditable(BuildContext context, ThemeProvider provider, String key, String defaultText, Widget child) {
    if (!provider.isSelectionMode) return child; 
    return GestureDetector(
      onTap: () => _showObjectEditor(context, provider, key, defaultText),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.pinkAccent, width: 2), color: Colors.pinkAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(4),
        child: child,
      ),
    );
  }

  void _showPasscodeDialog(ThemeProvider provider) {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: AppTheme.accent, width: 1)),
        title: Text('RESTRICTED AREA', style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent)),
        content: TextField(controller: passController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Enter Admin Passcode')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () { if (passController.text == _adminPasscode) { provider.unlockGodMode(); Navigator.pop(context); } }, child: const Text('OVERRIDE')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          // 🤫 CURSOR ENGINE SYNC
          body: MouseRegion(
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.basic,
            child: Column(
              children: [
                const CustomNavbar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildDynamicHero(context, provider), 
                        _buildVibeGallery(context, provider),
                        _buildMassiveGallery(context), 
                        _buildWhyFortuneSection(context, provider),
                        const CustomFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // ==========================================
  // 🚀 HERO WITH PARALLAX & RADIUS
  // ==========================================
  Widget _buildDynamicHero(BuildContext context, ThemeProvider provider) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;
    double radius = AppTheme.getGlobalRadius() * 2;
    
    return SizedBox(
      width: double.infinity,
      height: AppTheme.heroStyle == 'fullscreen' ? screenSize.height : (isMobile ? screenSize.height * 0.7 : screenSize.height * 0.85),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🖼️ IMAGE FILTER SYNC
          AppTheme.applyImageFilter(
            CarouselSlider(
              options: CarouselOptions(height: double.infinity, viewportFraction: 1.0, autoPlay: true),
              items: [
                'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2070',
                'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=2070',
              ].map((img) => Image.network(img, fit: BoxFit.cover, width: double.infinity)).toList(),
            ),
          ),
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.bg.withValues(alpha: 0.8), Colors.transparent, AppTheme.bg], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
          Center(
            child: AppTheme.applyAnim(
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: AppTheme.enableBlur ? 15 : 0, sigmaY: AppTheme.enableBlur ? 15 : 0),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: AppTheme.getCardDecoration(isHovered: false),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildEditable(context, provider, 'hero_top_tag', 'THE STANDARD FOR EXCELLENCE', Text(provider.elementSettings['hero_top_tag_text'] ?? 'THE STANDARD FOR EXCELLENCE', style: AppTheme.getBodyStyle(fontSize: 12, color: AppTheme.accent, weight: FontWeight.bold).copyWith(letterSpacing: 4))),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () { if (!provider.isGodModeUnlocked) { _secretTapCount++; if (_secretTapCount >= 5) _showPasscodeDialog(provider); } },
                          child: _buildEditable(context, provider, 'hero_title', AppTheme.heroTitle, Text(provider.elementSettings['hero_title_text'] ?? AppTheme.heroTitle, textAlign: TextAlign.center, style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 60, color: AppTheme.textMain))),
                        ),
                        const SizedBox(height: 20),
                        _buildEditable(context, provider, 'hero_subtitle', AppTheme.heroSubtitle, Text(provider.elementSettings['hero_subtitle_text'] ?? AppTheme.heroSubtitle, textAlign: TextAlign.center, style: AppTheme.getBodyStyle(fontSize: 16, color: AppTheme.textSub))),
                        const SizedBox(height: 30),
                        _buildCTAButton(context, provider),
                      ],
                    ),
                  ),
                ),
              ),
              0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(BuildContext context, ThemeProvider provider) {
    return _buildEditable(
      context, provider, 'hero_btn', AppTheme.heroCTA,
      ElevatedButton(
        onPressed: () { if (AppTheme.enableSoundEffects) HapticFeedback.lightImpact(); context.go('/services'); },
        child: Text(provider.elementSettings['hero_btn_text'] ?? AppTheme.heroCTA, style: AppTheme.getHeadingStyle(fontSize: 16, color: AppTheme.bg, weight: FontWeight.bold)),
      ),
    );
  }

  // ==========================================
  // 🏢 30 MASSIVE GALLERY IMAGES WITH FILTERS
  // ==========================================
  Widget _buildMassiveGallery(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.all(40), color: AppTheme.bg,
      child: MasonryGridView.count(
        crossAxisCount: isMobile ? 2 : 5, mainAxisSpacing: 15, crossAxisSpacing: 15, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _gallery30.length,
        itemBuilder: (context, index) => AppTheme.applyAnim(
          _ParallaxWrapper( // 🚀 NAYA: 3D PARALLAX EFFECT
            child: AppTheme.applyImageFilter( // 🚀 NAYA: FILTER ENGINE
              Container(
                decoration: AppTheme.getCardDecoration(isHovered: false),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()),
                  child: Image.network(_gallery30[index], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          (index % 5) * 50,
        ),
      ),
    );
  }

  // ==========================================
  // 📋 WHY FORTUNE (UPGRADED UI SYNC)
  // ==========================================
  Widget _buildWhyFortuneSection(BuildContext context, ThemeProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100), color: AppTheme.bg,
      child: Column(
        children: [
          _buildEditable(context, provider, 'why_title', 'Why Fortune?', Text(provider.elementSettings['why_title_text'] ?? 'Why Fortune?', style: AppTheme.getHeadingStyle(fontSize: 48, color: AppTheme.textMain))),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30, runSpacing: 30, alignment: WrapAlignment.center,
            children: [
              _buildFeature(context, provider, 'f1', Icons.verified_user_outlined, 'Trained Professionals', 'Every executive follows industry standards with precision.'),
              _buildFeature(context, provider, 'f2', Icons.groups_outlined, 'Complete Staffing', 'Unified command for all event manpower needs.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVibeGallery(BuildContext context, ThemeProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 80),
        _buildEditable(context, provider, 'vibe_title', 'Experience The Vibe', Text(provider.elementSettings['vibe_title_text'] ?? 'Experience The Vibe', style: AppTheme.getHeadingStyle(fontSize: 42, color: AppTheme.textMain))),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildFeature(BuildContext context, ThemeProvider provider, String id, IconData icon, String defaultTitle, String defaultDesc) {
    return _FeatureCard(
      icon: icon, 
      titleWidget: _buildEditable(context, provider, 'feat_${id}_title', defaultTitle, Text(provider.elementSettings['feat_${id}_title_text'] ?? defaultTitle, style: AppTheme.getHeadingStyle(fontSize: 18, color: AppTheme.textMain), textAlign: TextAlign.center)),
      descWidget: _buildEditable(context, provider, 'feat_${id}_desc', defaultDesc, Text(provider.elementSettings['feat_${id}_desc_text'] ?? defaultDesc, style: AppTheme.getBodyStyle(fontSize: 14, color: AppTheme.textSub), textAlign: TextAlign.center)),
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
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppTheme.durationMs),
        transform: AppTheme.getHoverTransform(isHovered),
        child: widget.child,
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
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true), onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppTheme.durationMs),
        width: 300, padding: const EdgeInsets.all(30),
        decoration: AppTheme.getCardDecoration(isHovered: isHovered),
        transform: AppTheme.getHoverTransform(isHovered),
        child: Column(children: [Icon(widget.icon, size: 40, color: isHovered ? AppTheme.textMain : AppTheme.accent), const SizedBox(height: 20), widget.titleWidget, const SizedBox(height: 15), widget.descWidget]),
      ),
    );
  }
}