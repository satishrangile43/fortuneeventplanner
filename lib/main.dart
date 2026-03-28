import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Tumhare custom paths
import 'routes/app_router.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart'; // 🚀 MASTER ENGINE IMPORTED

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const FortuneEventApp(),
    ),
  );
}

class FortuneEventApp extends StatefulWidget {
  const FortuneEventApp({super.key});

  @override
  State<FortuneEventApp> createState() => _FortuneEventAppState();
}

class _FortuneEventAppState extends State<FortuneEventApp> {
  // 🤫 GLOBAL SECRET VARIABLES
  int _secretTapCount = 0;
  final String _adminPasscode = "LOVEDAYBITTU"; // 🔐 TERA SECRET PASSWORD
  bool _isPanelOpen = false; // 🎛️ Controls the sliding Admin Panel

  FlexScheme _getFlexScheme(String themeName) {
    switch (themeName) {
      case 'luxury': return FlexScheme.gold;
      case 'cyberpunk': return FlexScheme.cyanM3;
      case 'hacker': return FlexScheme.green;
      case 'ocean': return FlexScheme.aquaBlue;
      case 'dracula': return FlexScheme.deepPurple;
      case 'sunset': return FlexScheme.orangeM3;
      case 'minimalist': return FlexScheme.greyLaw;
      case 'light': return FlexScheme.blue;
      case 'dark': return FlexScheme.greyLaw;
      case 'neon': return FlexScheme.mandyRed;
      case 'retro': return FlexScheme.vesuviusBurn;
      case 'pastel': return FlexScheme.sakura;
      case 'midnight': return FlexScheme.indigo;
      case 'forest': return FlexScheme.jungle;
      case 'galaxy': return FlexScheme.deepBlue;
      case 'fire': return FlexScheme.redWine;
      case 'ice': return FlexScheme.cyanM3;
      default: return FlexScheme.gold;
    }
  }

  // 🔐 GLOBAL PASSCODE DIALOG
  void _showGlobalPasscodeDialog(BuildContext dialogContext, ThemeProvider provider) {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: AppTheme.accent, width: 1)),
        title: Text('RESTRICTED AREA', style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent)),
        content: TextField(
          controller: passController, obscureText: true, style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: 'Enter Admin Passcode', hintStyle: const TextStyle(color: Colors.white30), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
        ),
        actions: [
          TextButton(
            onPressed: () { 
              _secretTapCount = 0; 
              Navigator.pop(ctx); 
            }, 
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            onPressed: () {
              if (passController.text == _adminPasscode) {
                provider.unlockGodMode(); 
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('🚀 SYSTEM OVERRIDE GRANTED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)), backgroundColor: Colors.green));
              } else {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('❌ ACCESS DENIED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white)), backgroundColor: Colors.red));
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
      builder: (context, themeProvider, child) {
        String activeThemeName = AppTheme.activeTheme;
        FlexScheme currentScheme = _getFlexScheme(activeThemeName);
        ThemeMode currentMode = (activeThemeName == 'light' || activeThemeName == 'minimalist' || activeThemeName == 'ice') 
            ? ThemeMode.light : ThemeMode.dark;
        String? currentFontFamily = AppTheme.getBodyStyle(fontSize: 14).fontFamily;

        return MaterialApp.router(
          title: 'Fortune Event Planner',
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(
            scheme: currentScheme, surfaceMode: FlexSurfaceMode.highScaffoldLowSurface, blendLevel: 10, appBarStyle: FlexAppBarStyle.background, bottomAppBarElevation: 1.0, useMaterial3: true, fontFamily: currentFontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: currentScheme, surfaceMode: FlexSurfaceMode.highScaffoldLowSurface, blendLevel: 13, useMaterial3: true, fontFamily: currentFontFamily,
          ),
          themeMode: currentMode, 
          routerConfig: appRouter,

          builder: (context, routerChild) {
            return Stack(
              children: [
                routerChild!, 

                // 🕵️‍♂️ GLOBAL SECRET TRIGGER
                if (!themeProvider.isGodModeUnlocked)
                  Positioned(
                    top: 0, right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent, 
                      onTap: () {
                        _secretTapCount++;
                        if (_secretTapCount >= 5) {
                          _secretTapCount = 0; 
                          _showGlobalPasscodeDialog(context, themeProvider);
                        }
                      },
                      child: const SizedBox(width: 100, height: 100),
                    ),
                  ),

                // 🎛️ GLOBAL ADMIN PANEL
                if (themeProvider.isGodModeUnlocked)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutExpo,
                    top: 0, bottom: 0,
                    right: _isPanelOpen ? 0 : -360, 
                    width: 350,
                    child: Material(
                      elevation: 20,
                      color: Colors.black.withValues(alpha: 0.95),
                      child: _buildGlobalAdminPanel(themeProvider),
                    ),
                  ),

                // 🚀 GLOBAL SETTINGS FAB
                if (themeProvider.isGodModeUnlocked)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutExpo,
                    bottom: 80, 
                    right: _isPanelOpen ? 370 : 20, 
                    child: FloatingActionButton(
                      backgroundColor: AppTheme.accent,
                      elevation: AppTheme.enableShadows ? 10 : 0,
                      onPressed: () => setState(() => _isPanelOpen = !_isPanelOpen),
                      child: Icon(_isPanelOpen ? Icons.close : Icons.settings_suggest, color: Colors.black),
                    ).animate().fade().scale(),
                  ),

                // 🕵️‍♂️ THE GLOBAL GOD BAR
                if (themeProvider.isGodModeUnlocked)
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: themeProvider.isSelectionMode ? 60 : 6, 
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          boxShadow: [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, -2))]
                        ),
                        child: themeProvider.isSelectionMode
                            ? _buildExpandedGodBar(themeProvider)
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => themeProvider.toggleSelectionMode(), 
                                child: Container(color: Colors.transparent), 
                              ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================
  // 🎛️ THE FIXED PRO GLOBAL ADMIN PANEL UI
  // ==========================================
  Widget _buildGlobalAdminPanel(ThemeProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Icon(Icons.rocket_launch, color: AppTheme.accent),
                const SizedBox(width: 10),
                Text("PRO CONTROL CENTER", style: AppTheme.getHeadingStyle(fontSize: 18, color: AppTheme.accent)),
              ],
            ),
            const Divider(color: Colors.white24, height: 30),
            
            _buildSectionTitle("🎨 1. COLORS, THEMES & FILTERS"),
            _buildCustomPicker("Active Theme", AppTheme.activeTheme, ['luxury', 'cyberpunk', 'hacker', 'ocean', 'sunset', 'minimalist', 'dracula', 'light', 'dark', 'neon', 'retro', 'pastel', 'midnight', 'forest', 'galaxy', 'fire', 'ice'], (v) => provider.changeTheme(v)),
            _buildColorPicker("Accent Color", AppTheme.accentColor, ['auto', 'blue', 'purple', 'green', 'red', 'gold', 'pink', 'cyan'], (v) => provider.updateAccentColor(v)),
            _buildCustomPicker("Image Filters", AppTheme.imageFilter, ['none', 'grayscale', 'sepia', 'high-contrast'], (v) => provider.updateImageFilter(v)), // 🆕 NAYA
            const SizedBox(height: 20),

            _buildSectionTitle("📐 2. UI, LAYOUT & SHAPES"),
            _buildCustomPicker("UI Component Style", AppTheme.globalUIStyle, ['glass', 'solid', 'bordered', 'flat', 'neumorphism', '3d'], (v) => provider.updateUIStyle(v)),
            _buildCustomPicker("Button Style", AppTheme.buttonStyle, ['rounded', 'pill', 'square', 'outline'], (v) => provider.updateButtonStyle(v)),
            _buildCustomPicker("Card Style", AppTheme.cardStyle, ['flat', 'elevated', 'glass', 'outline', 'neumorphic'], (v) => provider.updateCardStyle(v)),
            _buildCustomPicker("Border Radius", AppTheme.borderStyle, ['sharp', 'rounded', 'squircle'], (v) => provider.updateBorderStyle(v)), // 🆕 NAYA
            _buildCustomPicker("Hero Layout", AppTheme.heroStyle, ['centered', 'split', 'fullscreen'], (v) => provider.updateHeroStyle(v)),
            const SizedBox(height: 20),

            _buildSectionTitle("🚀 3. ANIMATIONS & SPEED"),
            _buildCustomPicker("Global Animation", AppTheme.globalAnimation, ['fade', 'slide', 'zoom', 'bounce', 'flip', 'glitch', 'elastic'], (v) => provider.updateAnimation(v)),
            _buildCustomPicker("Transition Speed", AppTheme.transitionSpeed, ['slow', 'normal', 'fast'], (v) => provider.updateTransitionSpeed(v)), // 🆕 NAYA
            const SizedBox(height: 20),

            _buildSectionTitle("🔠 4. TYPOGRAPHY"),
            _buildCustomPicker("Font Style", AppTheme.fontStyle, ['modern', 'tech', 'classic', 'futuristic', 'mono'], (v) => provider.updateFontStyle(v)),
            const SizedBox(height: 20),

            _buildSectionTitle("🧩 5. HEADER, FOOTER & FORMS"), // 🆕 NAYA SECTION
            _buildCustomPicker("Navbar Style", AppTheme.navbarStyle, ['sticky', 'floating', 'hidden'], (v) => provider.updateNavbarStyle(v)),
            _buildCustomPicker("Footer Style", AppTheme.footerStyle, ['minimal', 'expanded'], (v) => provider.updateFooterStyle(v)),
            _buildCustomPicker("Form Input Style", AppTheme.formInputStyle, ['filled', 'outlined', 'underlined'], (v) => provider.updateFormInputStyle(v)),
            const SizedBox(height: 20),

            _buildSectionTitle("🔥 6. SPECIAL EFFECTS & 3D"),
            _buildCustomPicker("3D Parallax Intensity", AppTheme.parallaxIntensity, ['off', 'low', 'high'], (v) => provider.updateParallaxIntensity(v)), // 🆕 NAYA
            _buildToggle("Enable Blur Effects", AppTheme.enableBlur, (v) => provider.toggleBlur(v)),
            _buildToggle("Enable Shadows", AppTheme.enableShadows, (v) => provider.toggleShadows(v)),
            _buildToggle("Enable Glow", AppTheme.enableGlow, (v) => provider.toggleGlow(v)), // 🆕 NAYA
            _buildToggle("Enable Cursor Effect", AppTheme.enableCursorEffect, (v) => provider.toggleCursorEffect(v)), // 🆕 NAYA
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () => provider.resetToDefault(),
                icon: const Icon(Icons.warning, color: Colors.white, size: 16),
                label: const Text("MASTER RESET", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // 🛠️ UI Helpers
  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(top: 10, bottom: 15), child: Text(title, style: AppTheme.getHeadingStyle(fontSize: 14, color: Colors.white54)));
  Widget _buildAdminLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 5, top: 10), child: Text(t, style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white70)));
  
  // 🔥 THE NEW CUSTOM CHIP PICKER (REPLACES DROPDOWN)
  Widget _buildCustomPicker(String label, String currentValue, List<String> items, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminLabel(label),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: items.map((item) {
                bool isSelected = currentValue == item;
                return GestureDetector(
                  onTap: () => onSelect(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accent : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppTheme.accent : Colors.transparent),
                    ),
                    child: Text(
                      item.toUpperCase(),
                      style: AppTheme.getBodyStyle(
                        fontSize: 12, 
                        color: isSelected ? Colors.black : Colors.white70,
                        weight: isSelected ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 THE NEW COLOR PICKER
  Color _getColorFromName(String name) {
    switch(name) {
      case 'blue': return Colors.blueAccent;
      case 'purple': return Colors.purpleAccent;
      case 'green': return Colors.greenAccent;
      case 'red': return Colors.redAccent;
      case 'gold': return const Color(0xFFD6A762);
      case 'pink': return Colors.pinkAccent;
      case 'cyan': return Colors.cyanAccent;
      default: return Colors.white54;
    }
  }

  Widget _buildColorPicker(String label, String currentValue, List<String> items, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminLabel(label),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: items.map((item) {
              bool isSelected = currentValue == item;
              return GestureDetector(
                onTap: () => onSelect(item),
                child: Container(
                  width: 35, height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColorFromName(item),
                    border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: isSelected ? 3 : 1),
                    boxShadow: isSelected ? [BoxShadow(color: _getColorFromName(item), blurRadius: 10)] : [],
                  ),
                  child: item == 'auto' ? const Icon(Icons.autorenew, size: 16, color: Colors.black) : null,
                ),
              );
            }).toList(),
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
        Switch(value: value, activeThumbColor: AppTheme.accent, onChanged: onChanged)
      ]
    );
  }

  Widget _buildExpandedGodBar(ThemeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.rocket_launch, color: Colors.black, size: 20),
              const SizedBox(width: 10),
              Text("GOD MODE ACTIVE: CLICK ANY TEXT TO EDIT", style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.black, weight: FontWeight.bold)),
            ],
          ),
          TextButton.icon(
            onPressed: () => provider.toggleSelectionMode(), 
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            label: const Text("HIDE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}