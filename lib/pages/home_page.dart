import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  // 📸 30 MASSIVE GALLERY IMAGES (Event, Crowd, Stage, Setup)
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

  // ==========================================
  // 🛠️ THE MINI-EDITOR (CLICK-TO-EDIT POPUP)
  // ==========================================
  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    TextEditingController textCtrl = TextEditingController(text: provider.elementSettings['${elementKey}_text'] ?? defaultText);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.accent, width: 1), borderRadius: BorderRadius.circular(15)),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white), maxLines: 3, minLines: 1,
              decoration: InputDecoration(
                labelText: "Text Content", labelStyle: const TextStyle(color: Colors.white54),
                filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (val) => provider.updateElement('${elementKey}_text', val),
            ),
            const SizedBox(height: 20),
            Text("Select Color:", style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white54)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: [Colors.white, Colors.black, AppTheme.accent, Colors.blueAccent, Colors.redAccent, Colors.greenAccent, Colors.purpleAccent, Colors.orangeAccent]
                .map((c) => GestureDetector(
                  onTap: () => provider.updateElement('${elementKey}_color', c),
                  child: Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: c, border: Border.all(color: Colors.white38))),
                )).toList(),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.clearElementSetting('${elementKey}_text');
                  provider.clearElementSetting('${elementKey}_color');
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                label: const Text("Reset", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withValues(alpha: 0.8)),
              ),
            )
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text("DONE", style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold)))],
      ),
    );
  }

  // ==========================================
  // 🖼️ EDITABLE WRAPPER (HIGHLIGHTS IN GOD MODE)
  // ==========================================
  Widget _buildEditable(BuildContext context, ThemeProvider provider, String key, String defaultText, Widget child) {
    if (!provider.isSelectionMode) return child; 
    return GestureDetector(
      onTap: () => _showObjectEditor(context, provider, key, defaultText),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pinkAccent, width: 2, style: BorderStyle.solid), 
          color: Colors.pinkAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4),
        child: child,
      ),
    );
  }

  // 🔐 PASSCODE DIALOG
  void _showPasscodeDialog(ThemeProvider provider) {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: AppTheme.accent, width: 1)),
        title: Text('RESTRICTED AREA', style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent)),
        content: TextField(
          controller: passController, obscureText: true, style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: 'Enter Admin Passcode', hintStyle: const TextStyle(color: Colors.white30), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
        ),
        actions: [
          TextButton(onPressed: () { _secretTapCount = 0; Navigator.pop(context); }, child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () {
              if (passController.text == _adminPasscode) {
                provider.unlockGodMode(); // 🔓 GLOBAL UNLOCK
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🚀 SYSTEM OVERRIDE GRANTED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)), backgroundColor: Colors.green));
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ ACCESS DENIED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)), backgroundColor: Colors.red));
                _secretTapCount = 0; 
              }
            },
            child: Text('OVERRIDE', style: TextStyle(color: AppTheme.bg, fontWeight: FontWeight.bold)),
          ),
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
          
          // 🚀 THE ULTIMATE MEGA ADMIN DRAWER
          endDrawer: Drawer(
            width: 350,
            backgroundColor: Colors.black.withValues(alpha: 0.95),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Icon(Icons.rocket_launch, color: AppTheme.accent),
                      const SizedBox(width: 10),
                      Text("GOD MODE PANEL", style: AppTheme.getHeadingStyle(fontSize: 18, color: AppTheme.accent)),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 30),
                  
                  _buildSectionTitle("🎨 COLORS & THEMES"),
                  _buildDropdown("Active Theme", AppTheme.activeTheme, ['luxury', 'cyberpunk', 'hacker', 'ocean', 'sunset', 'minimalist', 'dracula', 'light', 'dark', 'neon', 'retro', 'pastel', 'midnight', 'forest', 'galaxy', 'fire', 'ice'], (v) => provider.changeTheme(v!)),
                  _buildDropdown("Accent Color", AppTheme.accentColor, ['auto', 'blue', 'purple', 'green', 'red', 'gold', 'pink', 'cyan'], (v) => provider.updateAccentColor(v!)),
                  const SizedBox(height: 20),

                  _buildSectionTitle("📐 UI & LAYOUT STYLES"),
                  _buildDropdown("UI Component Style", AppTheme.globalUIStyle, ['glass', 'solid', 'bordered', 'flat', 'neumorphism', '3d'], (v) => provider.updateUIStyle(v!)),
                  _buildDropdown("Button Style", AppTheme.buttonStyle, ['rounded', 'pill', 'square', 'outline'], (v) => provider.updateButtonStyle(v!)),
                  _buildDropdown("Card Style", AppTheme.cardStyle, ['flat', 'elevated', 'glass', 'outline', 'neumorphic'], (v) => provider.updateCardStyle(v!)),
                  _buildDropdown("Hero Layout", AppTheme.heroStyle, ['centered', 'split', 'fullscreen'], (v) => provider.updateHeroStyle(v!)),
                  const SizedBox(height: 20),

                  _buildSectionTitle("🔠 TYPOGRAPHY & MOTION"),
                  _buildDropdown("Font Style", AppTheme.fontStyle, ['modern', 'tech', 'classic', 'futuristic', 'mono'], (v) => provider.updateFontStyle(v!)),
                  _buildDropdown("Global Animation", AppTheme.globalAnimation, ['fade', 'slide', 'zoom', 'bounce', 'flip', 'glitch', 'elastic'], (v) => provider.updateAnimation(v!)),
                  const SizedBox(height: 20),

                  _buildSectionTitle("🔥 SPECIAL EFFECTS"),
                  _buildToggle("Enable Blur Effects", AppTheme.enableBlur, (v) => provider.toggleBlur(v)),
                  _buildToggle("Enable Shadows", AppTheme.enableShadows, (v) => provider.toggleShadows(v)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 🤫 SECRET FAB
          floatingActionButton: provider.isGodModeUnlocked 
            ? Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  backgroundColor: AppTheme.accent,
                  child: Icon(Icons.settings_suggest, color: AppTheme.bg),
                ),
              ).animate().fade(delay: 100.ms).scale()
            : null, 

          body: Column(
            children: [
              const CustomNavbar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildDynamicHero(context, provider), 
                      _buildVibeGallery(context, provider),
                      _buildMassiveGallery(context), // 📸 30 IMAGES HERE
                      _buildWhyFortuneSection(context, provider), // 📋 TERA PURA DATA YAHAN HAI
                      const CustomFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  // ==========================================
  // 🚀 DYNAMIC HERO SECTION
  // ==========================================
  Widget _buildDynamicHero(BuildContext context, ThemeProvider provider) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;
    
    return SizedBox(
      width: double.infinity,
      height: AppTheme.heroStyle == 'fullscreen' ? screenSize.height : (isMobile ? screenSize.height * 0.7 : screenSize.height * 0.85),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
            options: CarouselOptions(height: double.infinity, viewportFraction: 1.0, autoPlay: true),
            items: [
              'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2070',
              'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=2070',
            ].map((img) => Image.network(img, fit: BoxFit.cover, width: double.infinity)).toList(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.bg.withValues(alpha: 0.8), Colors.transparent, AppTheme.bg], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Center(
            child: AppTheme.applyAnim(
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: AppTheme.enableBlur ? 15 : 0, sigmaY: AppTheme.enableBlur ? 15 : 0),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: AppTheme.getCardDecoration(isHovered: false),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildEditable(
                          context, provider, 'hero_top_tag', 'THE STANDARD FOR EXCELLENCE',
                          Text(provider.elementSettings['hero_top_tag_text'] ?? 'THE STANDARD FOR EXCELLENCE', style: AppTheme.getBodyStyle(fontSize: 12, color: provider.elementSettings['hero_top_tag_color'] ?? AppTheme.accent, weight: FontWeight.bold).copyWith(letterSpacing: 4)),
                        ),
                        const SizedBox(height: 20),
                        
                        // 🤫 SECRET TRIGGER
                        GestureDetector(
                          onTap: () {
                            if (!provider.isGodModeUnlocked) {
                              _secretTapCount++;
                              if (_secretTapCount >= 5) _showPasscodeDialog(provider);
                            }
                          },
                          child: _buildEditable(
                            context, provider, 'hero_title', AppTheme.heroTitle,
                            Text(provider.elementSettings['hero_title_text'] ?? AppTheme.heroTitle, textAlign: TextAlign.center, style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 60, color: provider.elementSettings['hero_title_color'] ?? AppTheme.textMain)),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        _buildEditable(
                          context, provider, 'hero_subtitle', AppTheme.heroSubtitle,
                          Text(provider.elementSettings['hero_subtitle_text'] ?? AppTheme.heroSubtitle, textAlign: TextAlign.center, style: AppTheme.getBodyStyle(fontSize: 16, color: provider.elementSettings['hero_subtitle_color'] ?? AppTheme.textSub)),
                        ),
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
    double radius = (AppTheme.buttonStyle == 'pill') ? 50 : ((AppTheme.buttonStyle == 'square') ? 0 : 12);
    return _buildEditable(
      context, provider, 'hero_btn', AppTheme.heroCTA,
      ElevatedButton(
        onPressed: () => context.go('/services'),
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.elementSettings['hero_btn_color'] ?? AppTheme.accent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          elevation: AppTheme.enableShadows ? 10 : 0,
        ),
        child: Text(provider.elementSettings['hero_btn_text'] ?? AppTheme.heroCTA, style: AppTheme.getHeadingStyle(fontSize: 16, color: AppTheme.bg, weight: FontWeight.bold)),
      ),
    );
  }

  // ==========================================
  // 📸 VIBE GALLERY
  // ==========================================
  Widget _buildVibeGallery(BuildContext context, ThemeProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: AppTheme.bg,
      child: Column(
        children: [
          _buildEditable(
            context, provider, 'vibe_title', 'Experience The Vibe',
            AppTheme.applyAnim(Text(provider.elementSettings['vibe_title_text'] ?? 'Experience The Vibe', style: AppTheme.getHeadingStyle(fontSize: 42, color: provider.elementSettings['vibe_title_color'] ?? AppTheme.textMain)), 100),
          ),
          const SizedBox(height: 50),
          const Wrap(
            spacing: 20, runSpacing: 20,
            children: [
              _ImageHoverCard(url: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800'),
              _ImageHoverCard(url: 'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800'),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🏢 30 MASSIVE GALLERY IMAGES
  // ==========================================
  Widget _buildMassiveGallery(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppTheme.bg,
      child: MasonryGridView.count(
        crossAxisCount: isMobile ? 2 : 5, // Mobile pe 2, PC pe 5 columns to fit 30 nicely
        mainAxisSpacing: 15, crossAxisSpacing: 15, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _gallery30.length, // 🔥 EXACTLY 30 IMAGES
        itemBuilder: (context, index) => AppTheme.applyAnim(
          Container(
            decoration: AppTheme.getCardDecoration(isHovered: false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'pill' ? 30 : (AppTheme.buttonStyle == 'square' ? 0 : 15)),
              child: Image.network(_gallery30[index], fit: BoxFit.cover),
            ),
          ),
          (index % 5) * 50, // Staggered Animation
        ),
      ),
    );
  }

  // ==========================================
  // 📋 TERA PURA CONTENT (WHY FORTUNE)
  // ==========================================
  Widget _buildWhyFortuneSection(BuildContext context, ThemeProvider provider) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80, vertical: 100),
      color: AppTheme.bg,
      child: Column(
        children: [
          _buildEditable(
            context, provider, 'why_title', 'Why Fortune?',
            Text(provider.elementSettings['why_title_text'] ?? 'Why Fortune?', style: AppTheme.getHeadingStyle(fontSize: 48, color: provider.elementSettings['why_title_color'] ?? AppTheme.textMain)),
          ),
          const SizedBox(height: 20),
          _buildEditable(
            context, provider, 'why_desc_1', 'To strengthen event companies by delivering reliable manpower and operational support that improves coordination, enhances guest experience, and maintains safety.',
            Text(
              provider.elementSettings['why_desc_1_text'] ?? 'To strengthen event companies by delivering reliable manpower and operational support that improves coordination, enhances guest experience, and maintains safety.',
              textAlign: TextAlign.center,
              style: AppTheme.getBodyStyle(fontSize: 16, color: provider.elementSettings['why_desc_1_color'] ?? AppTheme.textSub),
            ),
          ),
          const SizedBox(height: 10),
          _buildEditable(
            context, provider, 'why_desc_2', 'We aim to simplify event execution by providing trained professionals capable of handling every segment of event management with discipline and efficiency.',
            Text(
              provider.elementSettings['why_desc_2_text'] ?? 'We aim to simplify event execution by providing trained professionals capable of handling every segment of event management with discipline and efficiency.',
              textAlign: TextAlign.center,
              style: AppTheme.getBodyStyle(fontSize: 16, color: provider.elementSettings['why_desc_2_color'] ?? AppTheme.textSub),
            ),
          ),
          const SizedBox(height: 60),

          // FEATURES MAP
          Wrap(
            spacing: 30, runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildFeature(context, provider, 'f1', Icons.verified_user_outlined, 'Trained Professionals', 'Every executive, coordinator, and security staff follows industry standards with absolute precision.'),
              _buildFeature(context, provider, 'f2', Icons.groups_outlined, 'Complete Staffing', 'From hospitality to security, we provide all manpower under one roof, ensuring unified command.'),
              _buildFeature(context, provider, 'f3', Icons.access_time_outlined, 'High Reliability', 'Punctual, disciplined, and event-ready staff with skilled supervisors overseeing every detail.'),
              _buildFeature(context, provider, 'f4', Icons.health_and_safety_outlined, 'Safety & Quality First', 'A strong emphasis on guest safety, operations and event control is at our core.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(BuildContext context, ThemeProvider provider, String id, IconData icon, String defaultTitle, String defaultDesc) {
    return _FeatureCard(
      icon: icon, 
      titleWidget: _buildEditable(context, provider, 'feat_${id}_title', defaultTitle, Text(provider.elementSettings['feat_${id}_title_text'] ?? defaultTitle, style: AppTheme.getHeadingStyle(fontSize: 18, color: provider.elementSettings['feat_${id}_title_color'] ?? AppTheme.textMain), textAlign: TextAlign.center)),
      descWidget: _buildEditable(context, provider, 'feat_${id}_desc', defaultDesc, Text(provider.elementSettings['feat_${id}_desc_text'] ?? defaultDesc, style: AppTheme.getBodyStyle(fontSize: 14, color: provider.elementSettings['feat_${id}_desc_color'] ?? AppTheme.textSub), textAlign: TextAlign.center)),
    );
  }

  // ADMIN PANEL UI HELPERS
  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(top: 10, bottom: 15), child: Text(title, style: AppTheme.getHeadingStyle(fontSize: 14, color: Colors.white54)));
  Widget _buildAdminLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 5, top: 10), child: Text(t, style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white70)));
  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildAdminLabel(label), Container(padding: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)), child: DropdownButton<String>(value: value, isExpanded: true, underline: const SizedBox(), dropdownColor: Colors.black, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(), onChanged: onChanged))]));
  }
  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white70)), Switch(value: value, activeThumbColor: AppTheme.accent, onChanged: onChanged)]);
  }
}

// ==========================================
// 🎨 REUSABLE COMPONENTS
// ==========================================
class _ImageHoverCard extends StatefulWidget {
  final String url; const _ImageHoverCard({required this.url});
  @override State<_ImageHoverCard> createState() => _ImageHoverCardState();
}
class _ImageHoverCardState extends State<_ImageHoverCard> {
  bool isHovered = false;
  @override Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true), onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 350, height: 250,
        decoration: AppTheme.getCardDecoration(isHovered: isHovered),
        transform: Matrix4.translationValues(0, isHovered && AppTheme.hoverEffect == 'lift' ? -10 : 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'pill' ? 50 : (AppTheme.buttonStyle == 'square' ? 0 : 20)),
          child: Image.network(widget.url, fit: BoxFit.cover)
        ),
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
        duration: const Duration(milliseconds: 300),
        width: 300, padding: const EdgeInsets.all(30),
        decoration: AppTheme.getCardDecoration(isHovered: isHovered),
        transform: Matrix4.translationValues(0, isHovered && AppTheme.hoverEffect == 'lift' ? -10 : 0, 0),
        child: Column(
          children: [
            Icon(widget.icon, size: 40, color: isHovered ? AppTheme.textMain : AppTheme.accent),
            const SizedBox(height: 20),
            widget.titleWidget,
            const SizedBox(height: 15),
            widget.descWidget,
          ],
        ),
      ),
    );
  }
}