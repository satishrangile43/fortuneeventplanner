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
import '../theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _heroTitleController;
  late TextEditingController _heroSubController;

  // 🤫 SECRET VARIABLES
  int _secretTapCount = 0;
  bool _isGodModeUnlocked = false; 
  final String _adminPasscode = "LOVEDAYBITTU"; // 🔐 TERA SECRET PASSWORD

  @override
  void initState() {
    super.initState();
    _heroTitleController = TextEditingController(text: AppTheme.heroTitle);
    _heroSubController = TextEditingController(text: AppTheme.heroSubtitle);
  }

  @override
  void dispose() {
    _heroTitleController.dispose();
    _heroSubController.dispose();
    super.dispose();
  }

  // 🔐 PASSCODE DIALOG
  void _showPasscodeDialog() {
    final TextEditingController passController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: AppTheme.accent, width: 1),
        ),
        title: Text(
          'RESTRICTED AREA',
          style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent),
        ),
        content: TextField(
          controller: passController,
          obscureText: true, // Password hidden
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter Admin Passcode',
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _secretTapCount = 0; 
              Navigator.pop(context);
            },
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () {
              if (passController.text == _adminPasscode) {
                setState(() => _isGodModeUnlocked = true); // 🔓 UNLOCK GOD MODE
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🚀 SYSTEM OVERRIDE GRANTED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)), 
                    backgroundColor: Colors.green
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ ACCESS DENIED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)), 
                    backgroundColor: Colors.red
                  ),
                );
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
              
              // --- 🎨 1. COLORS & THEMES ---
              _buildSectionTitle("🎨 COLORS & THEMES"),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Active Theme", AppTheme.activeTheme, ['luxury', 'cyberpunk', 'hacker', 'ocean', 'sunset', 'minimalist', 'dracula', 'light', 'dark', 'neon', 'retro', 'pastel', 'midnight', 'forest', 'galaxy', 'fire', 'ice'], (v) => p.changeTheme(v!))),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Accent Color", AppTheme.accentColor, ['auto', 'blue', 'purple', 'green', 'red', 'gold', 'pink', 'cyan'], (v) => p.updateAccentColor(v!))),
              
              const SizedBox(height: 20),

              // --- 📐 2. UI & LAYOUT ---
              _buildSectionTitle("📐 UI & LAYOUT STYLES"),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("UI Component Style", AppTheme.globalUIStyle, ['glass', 'solid', 'bordered', 'flat', 'neumorphism', '3d'], (v) => p.updateUIStyle(v!))),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Button Style", AppTheme.buttonStyle, ['rounded', 'pill', 'square', 'outline'], (v) => p.updateButtonStyle(v!))),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Card Style", AppTheme.cardStyle, ['flat', 'elevated', 'glass', 'outline', 'neumorphic'], (v) => p.updateCardStyle(v!))),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Hero Layout", AppTheme.heroStyle, ['centered', 'split', 'fullscreen'], (v) => p.updateHeroStyle(v!))),

              const SizedBox(height: 20),

              // --- 🔠 3. TYPOGRAPHY & ANIMATION ---
              _buildSectionTitle("🔠 TYPOGRAPHY & MOTION"),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Font Style", AppTheme.fontStyle, ['modern', 'tech', 'classic', 'futuristic', 'mono'], (v) => p.updateFontStyle(v!))),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildDropdown("Global Animation", AppTheme.globalAnimation, ['fade', 'slide', 'zoom', 'bounce', 'flip', 'glitch', 'elastic'], (v) => p.updateAnimation(v!))),

              const SizedBox(height: 20),

              // --- 🔥 4. SPECIAL EFFECTS ---
              _buildSectionTitle("🔥 SPECIAL EFFECTS"),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildToggle("Enable Blur Effects", AppTheme.enableBlur, (v) => p.toggleBlur(v))),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildToggle("Enable Shadows", AppTheme.enableShadows, (v) => p.toggleShadows(v))),

              const SizedBox(height: 20),

              // --- 🎯 5. CONTENT ---
              _buildSectionTitle("🎯 HERO CONTENT"),
              _buildAdminLabel("Hero Title:"),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildTextField(_heroTitleController, (v) => p.updateHeroTitle(v))),
              const SizedBox(height: 10),
              _buildAdminLabel("Hero Subtitle:"),
              Consumer<ThemeProvider>(builder: (c, p, _) => _buildTextField(_heroSubController, (v) => p.updateHeroSubtitle(v))),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // 🤫 SECRET FAB: Sirf Passcode match hone par dikhega
      floatingActionButton: _isGodModeUnlocked 
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
                  _buildDynamicHero(context), 
                  _buildVibeGallery(context),
                  _buildMassiveGallery(context),
                  _buildWhyFortuneSection(context),
                  const CustomFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🚀 DYNAMIC HERO SECTION (Reacts to Hero Style)
  // ==========================================
  Widget _buildDynamicHero(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;
    
    // Split Layout Mode
    if (AppTheme.heroStyle == 'split' && !isMobile) {
      return Container(
        height: screenSize.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTheme.applyAnim(Text('THE STANDARD FOR EXCELLENCE', style: AppTheme.getBodyStyle(fontSize: 14, color: AppTheme.accent, weight: FontWeight.bold).copyWith(letterSpacing: 4)), 100),
                  const SizedBox(height: 20),
                  
                  // 🤫 SECRET TRIGGER (Split Mode)
                  GestureDetector(
                    onTap: () {
                      if (!_isGodModeUnlocked) {
                        _secretTapCount++;
                        if (_secretTapCount >= 5) _showPasscodeDialog();
                      }
                    },
                    child: AppTheme.applyAnim(Text(AppTheme.heroTitle, style: AppTheme.getHeadingStyle(fontSize: 56, color: AppTheme.textMain)), 300),
                  ),
                  
                  const SizedBox(height: 20),
                  AppTheme.applyAnim(Text(AppTheme.heroSubtitle, style: AppTheme.getBodyStyle(fontSize: 18, color: AppTheme.textSub)), 500),
                  const SizedBox(height: 40),
                  AppTheme.applyAnim(_buildCTAButton(context), 700),
                ],
              ),
            ),
            Expanded(
              child: AppTheme.applyAnim(
                Container(
                  decoration: AppTheme.getCardDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'pill' ? 50 : (AppTheme.buttonStyle == 'square' ? 0 : 20)),
                    child: Image.network('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2070', fit: BoxFit.cover, height: double.infinity),
                  ),
                ),
                400
              ),
            ),
          ],
        ),
      );
    }

    // Centered or Fullscreen Mode
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
              gradient: LinearGradient(
                colors: [AppTheme.bg.withValues(alpha: 0.8), Colors.transparent, AppTheme.bg],
                begin: Alignment.topCenter, end: Alignment.bottomCenter
              ),
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
                        Text('THE STANDARD FOR EXCELLENCE', style: AppTheme.getBodyStyle(fontSize: 12, color: AppTheme.accent, weight: FontWeight.bold).copyWith(letterSpacing: 4)),
                        const SizedBox(height: 20),
                        
                        // 🤫 SECRET TRIGGER (Centered Mode)
                        GestureDetector(
                          onTap: () {
                            if (!_isGodModeUnlocked) {
                              _secretTapCount++;
                              if (_secretTapCount >= 5) _showPasscodeDialog();
                            }
                          },
                          child: Text(AppTheme.heroTitle, textAlign: TextAlign.center, style: AppTheme.getHeadingStyle(fontSize: isMobile ? 32 : 60, color: AppTheme.textMain)),
                        ),
                        
                        const SizedBox(height: 20),
                        Text(AppTheme.heroSubtitle, textAlign: TextAlign.center, style: AppTheme.getBodyStyle(fontSize: 16, color: AppTheme.textSub)),
                        const SizedBox(height: 30),
                        _buildCTAButton(context),
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

  // 🔘 Dynamic CTA Button
  Widget _buildCTAButton(BuildContext context) {
    double radius = (AppTheme.buttonStyle == 'pill') ? 50 : ((AppTheme.buttonStyle == 'square') ? 0 : 12);
    return ElevatedButton(
      onPressed: () => context.go('/services'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accent,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        elevation: AppTheme.enableShadows ? 10 : 0,
        shadowColor: AppTheme.accent.withValues(alpha: 0.5),
      ),
      child: Text(AppTheme.heroCTA, style: AppTheme.getHeadingStyle(fontSize: 16, color: AppTheme.bg, weight: FontWeight.bold)),
    );
  }

  // ==========================================
  // 📸 VIBE GALLERY
  // ==========================================
  Widget _buildVibeGallery(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: AppTheme.bg,
      child: Column(
        children: [
          AppTheme.applyAnim(Text('Experience The Vibe', style: AppTheme.getHeadingStyle(fontSize: 42, color: AppTheme.textMain)), 100),
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
  // 🏢 MASSIVE GALLERY
  // ==========================================
  Widget _buildMassiveGallery(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppTheme.bg,
      child: MasonryGridView.count(
        crossAxisCount: isMobile ? 2 : 4, mainAxisSpacing: 15, crossAxisSpacing: 15, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) => AppTheme.applyAnim(
          Container(
            decoration: AppTheme.getCardDecoration(isHovered: false),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'pill' ? 50 : (AppTheme.buttonStyle == 'square' ? 0 : 20)),
              child: Image.network('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=500', fit: BoxFit.cover),
            ),
          ),
          index * 100,
        ),
      ),
    );
  }

  Widget _buildWhyFortuneSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: AppTheme.bg,
      child: const Wrap(
        spacing: 30, runSpacing: 30,
        alignment: WrapAlignment.center,
        children: [
          _FeatureCard(icon: Icons.verified_user_outlined, title: 'Trained Professionals'),
          _FeatureCard(icon: Icons.groups_outlined, title: 'Complete Staffing'),
        ],
      ),
    );
  }

  // ==========================================
  // 🛠️ ADMIN PANEL HELPERS
  // ==========================================
  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(top: 10, bottom: 15), child: Text(title, style: AppTheme.getHeadingStyle(fontSize: 14, color: Colors.white54)));
  Widget _buildAdminLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 5, top: 10), child: Text(t, style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white70)));
  
  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminLabel(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
            child: DropdownButton<String>(
              value: value, isExpanded: true, underline: const SizedBox(), dropdownColor: Colors.black,
              style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white70)),
        Switch(value: value, activeThumbColor: AppTheme.accent, onChanged: onChanged),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, Function(String) onChanged) {
    return TextField(
      controller: controller,
      style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white),
      maxLines: 2,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      onChanged: onChanged,
    );
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
  final IconData icon; final String title;
  const _FeatureCard({required this.icon, required this.title});
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
            Text(widget.title, style: AppTheme.getHeadingStyle(fontSize: 18, color: isHovered ? AppTheme.textMain : AppTheme.textSub)),
          ],
        ),
      ),
    );
  }
}