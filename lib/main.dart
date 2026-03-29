import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart'; // 🚀 Haptics support

// Tumhare custom paths (Agar path error aaye toh inko check kar lena)
import 'routes/app_router.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart'; // 🚀 MASTER ENGINE IMPORTED

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 🟢 Makes system nav bar transparent for a cleaner edge-to-edge look on Android/iOS
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, systemNavigationBarColor: Colors.transparent),
  );
  
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
  // ==========================================
  // 🤫 GLOBAL SECRET VARIABLES (YAHAN SE PASSWORD CHANGE KARO)
  // ==========================================
  int _secretTapCount = 0;
  
  // 👇 ISKO CHANGE KARKE APNA NAYA PASSWORD RAKH SAKTE HO 👇
  final String _adminPasscode = "LOVEDAYBITTU"; 
  
  bool _isPanelOpen = false; // 🎛️ Controls the sliding Admin Panel

  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }
  }

  // Yahan se FlexScheme connect hoti hai active theme se
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

  // 🔐 GLOBAL PASSCODE DIALOG (Admin Panel Unlock UI)
  void _showGlobalPasscodeDialog(BuildContext dialogContext, ThemeProvider provider) {
    _triggerSound();
    final TextEditingController passController = TextEditingController();
    
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.95), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: AppTheme.accent, width: 1.5)), 
        title: Text('RESTRICTED AREA', style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent)),
        content: TextField(
          controller: passController, 
          obscureText: true, 
          style: const TextStyle(color: Colors.white, letterSpacing: 2.0), 
          decoration: InputDecoration(
            hintText: 'Enter Admin Passcode', 
            hintStyle: const TextStyle(color: Colors.white30, letterSpacing: 0), 
            filled: true, 
            fillColor: Colors.white.withValues(alpha: 0.05), 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
          ),
        ),
        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextButton(
              onPressed: () { 
                _triggerSound();
                _secretTapCount = 0; 
                Navigator.pop(ctx); 
              }, 
              child: const Text('CANCEL', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              onPressed: () {
                _triggerSound();
                if (passController.text == _adminPasscode) {
                  provider.unlockGodMode(); 
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                    content: Text('🚀 SYSTEM OVERRIDE GRANTED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white).copyWith(fontWeight: FontWeight.bold)), 
                    backgroundColor: Colors.green.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                } else {
                  Navigator.pop(ctx);
                  if (AppTheme.enableSoundEffects) HapticFeedback.vibrate(); 
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                    content: Text('❌ ACCESS DENIED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white).copyWith(fontWeight: FontWeight.bold)), 
                    backgroundColor: Colors.redAccent.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                  _secretTapCount = 0; 
                }
              },
              child: Text('OVERRIDE', style: TextStyle(color: AppTheme.bg, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
            ),
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
            scheme: currentScheme, 
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface, 
            blendLevel: 10, 
            appBarStyle: FlexAppBarStyle.background, 
            useMaterial3: true, 
            fontFamily: currentFontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: currentScheme, 
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface, 
            blendLevel: 13, 
            useMaterial3: true, 
            fontFamily: currentFontFamily,
          ),
          themeMode: currentMode, 
          routerConfig: appRouter,

          builder: (context, routerChild) {
            return Stack(
              children: [
                routerChild!, 

                // ==========================================
                // 🕵️‍♂️ GLOBAL SECRET TRIGGER (SCREEN KE TOP RIGHT CORNER PE HAI)
                // 5 baar wahan tap/click karne se password screen khulegi
                // ==========================================
                if (!themeProvider.isGodModeUnlocked)
                  Positioned(
                    top: 0, right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.basic, 
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent, 
                        onTap: () {
                          _secretTapCount++;
                          if (_secretTapCount >= 5) {
                            _secretTapCount = 0; 
                            _showGlobalPasscodeDialog(context, themeProvider);
                          }
                        },
                        child: const SizedBox(width: 80, height: 80), // Tap Area (Top Right 80x80 px)
                      ),
                    ),
                  ),

                // 🎛️ GLOBAL ADMIN PANEL (Right se slide hoke aayega)
                if (themeProvider.isGodModeUnlocked)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeOutCubic, 
                    top: 0, bottom: 0,
                    right: _isPanelOpen ? 0 : -380, 
                    width: 380,
                    child: Material(
                      elevation: 30, 
                      color: Colors.black.withValues(alpha: 0.95), 
                      child: _buildGlobalAdminPanel(themeProvider),
                    ),
                  ),

                // 🚀 GLOBAL SETTINGS FAB (Floating Action Button)
                if (themeProvider.isGodModeUnlocked)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    bottom: 80, 
                    right: _isPanelOpen ? 400 : 25, 
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: FloatingActionButton(
                        backgroundColor: AppTheme.accent,
                        elevation: AppTheme.enableShadows ? 15 : 0, 
                        onPressed: () {
                          _triggerSound();
                          setState(() => _isPanelOpen = !_isPanelOpen);
                        },
                        child: Icon(
                          _isPanelOpen ? Icons.close_rounded : Icons.dashboard_customize_rounded, 
                          color: AppTheme.cardBg, 
                          size: 28 
                        ),
                      ).animate().fade().scale(curve: Curves.easeOutBack), 
                    ),
                  ),

                // 🕵️‍♂️ THE GLOBAL GOD BAR (Niche se aayega edit mode on karne ke liye)
                if (themeProvider.isGodModeUnlocked)
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack, 
                        height: themeProvider.isSelectionMode ? 60 : 6, 
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          boxShadow: [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.6), blurRadius: 20, offset: const Offset(0, -2))] 
                        ),
                        child: themeProvider.isSelectionMode
                            ? _buildExpandedGodBar(themeProvider)
                            : MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _triggerSound();
                                    themeProvider.toggleSelectionMode();
                                  }, 
                                  child: Container(color: Colors.transparent), 
                                ),
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
  // Panel ke andar jo Buttons/Pickers hain unki List
  // ==========================================
  Widget _buildGlobalAdminPanel(ThemeProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20), 
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, color: AppTheme.accent, size: 28), 
                const SizedBox(width: 15),
                // 🔴 FIXED: Text(xxx).copyWith() issue resolved here
                Text(
                  "GOD TIER CONTROL", 
                  style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withValues(alpha: 0.1), height: 1, thickness: 1), 
            const SizedBox(height: 25),
            
            _buildSectionTitle("🎨 1. COLORS, THEMES & FILTERS"),
            _buildCustomPicker("Active Theme", AppTheme.activeTheme, ['luxury', 'cyberpunk', 'hacker', 'ocean', 'sunset', 'minimalist', 'dracula', 'light', 'dark', 'neon', 'retro', 'pastel', 'midnight', 'forest', 'galaxy', 'fire', 'ice'], (v) => provider.changeTheme(v)),
            _buildColorPicker("Accent Color", AppTheme.accentColor, ['auto', 'blue', 'purple', 'green', 'red', 'gold', 'pink', 'cyan'], (v) => provider.updateAccentColor(v)),
            _buildCustomPicker("Image Filters", AppTheme.imageFilter, ['none', 'grayscale', 'sepia', 'high-contrast'], (v) => provider.updateImageFilter(v)), 
            const SizedBox(height: 30), 

            _buildSectionTitle("📐 2. UI, LAYOUT & SHAPES"),
            _buildCustomPicker("UI Component Style", AppTheme.globalUIStyle, ['glass', 'solid', 'bordered', 'flat', 'neumorphism', '3d'], (v) => provider.updateUIStyle(v)),
            _buildCustomPicker("Button Style", AppTheme.buttonStyle, ['rounded', 'pill', 'square', 'outline'], (v) => provider.updateButtonStyle(v)),
            _buildCustomPicker("Card Style", AppTheme.cardStyle, ['flat', 'elevated', 'glass', 'outline', 'neumorphic'], (v) => provider.updateCardStyle(v)),
            _buildCustomPicker("Border Radius", AppTheme.borderStyle, ['sharp', 'rounded', 'squircle'], (v) => provider.updateBorderStyle(v)), 
            _buildCustomPicker("Hero Layout", AppTheme.heroStyle, ['centered', 'split', 'fullscreen'], (v) => provider.updateHeroStyle(v)),
            const SizedBox(height: 30),

            _buildSectionTitle("🚀 3. ANIMATIONS & SPEED"),
            _buildCustomPicker("Global Animation", AppTheme.globalAnimation, ['fade', 'slide', 'zoom', 'bounce', 'flip', 'glitch', 'elastic', 'pulse', 'wave'], (v) => provider.updateAnimation(v)), 
            _buildCustomPicker("Transition Speed", AppTheme.transitionSpeed, ['slow', 'normal', 'fast'], (v) => provider.updateTransitionSpeed(v)), 
            const SizedBox(height: 30),

            _buildSectionTitle("🔠 4. TYPOGRAPHY"),
            _buildCustomPicker("Font Style", AppTheme.fontStyle, ['modern', 'tech', 'classic', 'futuristic', 'mono'], (v) => provider.updateFontStyle(v)),
            const SizedBox(height: 30),

            _buildSectionTitle("🧩 5. HEADER, FOOTER & FORMS"), 
            _buildCustomPicker("Navbar Style", AppTheme.navbarStyle, ['sticky', 'floating', 'hidden'], (v) => provider.updateNavbarStyle(v)),
            _buildCustomPicker("Footer Style", AppTheme.footerStyle, ['minimal', 'expanded', 'hidden'], (v) => provider.updateFooterStyle(v)), 
            _buildCustomPicker("Form Input Style", AppTheme.formInputStyle, ['filled', 'outlined', 'underlined'], (v) => provider.updateFormInputStyle(v)),
            const SizedBox(height: 30),

            _buildSectionTitle("🔥 6. SPECIAL EFFECTS & 3D"),
            _buildCustomPicker("3D Parallax Intensity", AppTheme.parallaxIntensity, ['none', 'low', 'high'], (v) => provider.updateParallaxIntensity(v)), 
            _buildToggle("Enable Blur Effects", AppTheme.enableBlur, (v) => provider.toggleBlur(v)),
            _buildToggle("Enable Shadows", AppTheme.enableShadows, (v) => provider.toggleShadows(v)),
            _buildToggle("Enable Glow", AppTheme.enableGlow, (v) => provider.toggleGlow(v)), 
            _buildToggle("Enable Cursor Effect", AppTheme.enableCursorEffect, (v) => provider.toggleCursorEffect(v)), 
            const SizedBox(height: 40),

            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _triggerSound();
                    provider.resetToDefault();
                  },
                  icon: const Icon(Icons.warning_rounded, color: Colors.white, size: 18),
                  label: const Text("MASTER RESET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120), 
          ],
        ),
      ),
    );
  }

  // 🛠️ UI Helpers
  // 🔴 FIXED: copyWith issue resolved in buildSectionTitle
  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 20), 
    child: Text(
      title.toUpperCase(), 
      style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.accent).copyWith(fontWeight: FontWeight.w800, letterSpacing: 2.0),
    )
  );
  
  Widget _buildAdminLabel(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10), 
    child: Text(t, style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white60).copyWith(fontWeight: FontWeight.w600)) 
  );
  
  // 🔥 THE NEW CUSTOM CHIP PICKER
  Widget _buildCustomPicker(String label, String currentValue, List<String> items, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25), 
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
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _triggerSound();
                      onSelect(item);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(right: 12), 
                      padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 15, vertical: 10), 
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(50), 
                        border: Border.all(color: isSelected ? AppTheme.accent : Colors.transparent),
                        boxShadow: isSelected ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))] : [], 
                      ),
                      child: Text(
                        item.toUpperCase(),
                        style: AppTheme.getBodyStyle(
                          fontSize: 11, 
                          color: isSelected ? AppTheme.bg : Colors.white70, 
                        ).copyWith(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, letterSpacing: 1.0),
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
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminLabel(label),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: items.map((item) {
              bool isSelected = currentValue == item;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _triggerSound();
                    onSelect(item);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 42 : 35, 
                    height: isSelected ? 42 : 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColorFromName(item),
                      border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: isSelected ? 2 : 0),
                      boxShadow: isSelected ? [BoxShadow(color: _getColorFromName(item).withValues(alpha: 0.8), blurRadius: 15, spreadRadius: 2)] : [], 
                    ),
                    child: item == 'auto' 
                        ? Icon(Icons.auto_awesome_mosaic_rounded, size: isSelected ? 22 : 18, color: isSelected ? Colors.black : Colors.white) 
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), 
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque, 
          onTap: () {
            _triggerSound();
            onChanged(!value);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text(
                label, 
                style: AppTheme.getBodyStyle(fontSize: 14, color: value ? Colors.white : Colors.white70)
                        .copyWith(fontWeight: value ? FontWeight.bold : FontWeight.w500)
              ), 
              Switch(
                value: value, 
                activeThumbColor: AppTheme.bg, // 🟢 Standard property
                activeTrackColor: AppTheme.accent, 
                inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                inactiveThumbColor: Colors.white54,
                onChanged: (v) {
                  _triggerSound();
                  onChanged(v);
                }
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedGodBar(ThemeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.precision_manufacturing_rounded, color: AppTheme.cardBg, size: 24),
              const SizedBox(width: 15),
              // 🔴 FIXED: copyWith issue resolved here
              Text(
                "GOD MODE ACTIVE: CLICK ANY TEXT OR CARD TO EDIT", 
                style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.cardBg).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.0),
              ),
            ],
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextButton.icon(
              onPressed: () {
                _triggerSound();
                provider.toggleSelectionMode();
              }, 
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.cardBg, size: 24),
              label: Text("HIDE", style: TextStyle(color: AppTheme.cardBg, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ),
          )
        ],
      ),
    );
  }
}