import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart'; // 🚀 Haptics support
import 'dart:convert'; // 🚀 JSON encode/decode ke liye
import 'package:http/http.dart' as http; // 🚀 GitHub API call ke liye

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
  // 🤫 GLOBAL SECRET VARIABLES
  // ==========================================
  int _secretTapCount = 0;
  final String _adminPasscode = "LOVEDAYBITTU"; 
  bool _isPanelOpen = false; 

  // 🚀 VARIABLES FOR DRAGGABLE PORTABLE GOD MODE
  double? _fabX; 
  double? _fabY;
  bool _isDragging = false; 

  // 🚀 VARIABLES FOR RESIZE & TRANSPARENCY
  double _panelWidth = 380.0; 
  double _panelOpacity = 0.95; 
  bool _isResizing = false; 

  // 🚀 PUBLISH LIVE STATE
  bool _isPublishing = false;

  // ==========================================
  // 🔐 GITHUB CREDENTIALS (UPGRADED FOR SECURITY)
  // ==========================================
  // ⚠️ Ab token hardcode nahi hai! Yeh TextField se aayega.
  final TextEditingController _tokenController = TextEditingController(); 
  
  final String _githubUsername = 'satishrangile43';
  final String _githubRepo = 'fortuneeventplanner';
  final String _filePath = 'lib/theme/app_theme.dart'; // File ka exact rasta

  @override
  void dispose() {
    _tokenController.dispose(); // Memory leak se bachne ke liye
    super.dispose();
  }

  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }
  }

  // ==========================================
  // 🚀 FULL GOD MODE PUBLISH (ALL SETTINGS SYNCED)
  // ==========================================
  Future<void> _publishToGitHub(BuildContext context) async {
    final String secureToken = _tokenController.text.trim();

    // 🛑 Security Check: Agar token khali hai toh rok do
    if (secureToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('❌ Please enter your GitHub Token below first!', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white).copyWith(fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() => _isPublishing = true);
    final String url = 'https://api.github.com/repos/$_githubUsername/$_githubRepo/contents/$_filePath';

    try {
      // 🕵️‍♂️ STEP 1: Fetch current file data
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $secureToken', 'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String sha = data['sha'];
        final String contentBase64 = data['content'].replaceAll('\n', '');
        final String currentContent = utf8.decode(base64Decode(contentBase64));

        // ✂️ STEP 2: Find & Replace EVERYTHING using Regex
        String newContent = currentContent;
        
        // 🔹 1. STRINGS REPLACEMENT (Theme, Colors, Styles, Fonts, etc.)
        newContent = newContent.replaceAll(RegExp(r"static String activeTheme = '.*?';"), "static String activeTheme = '${AppTheme.activeTheme}';");
        newContent = newContent.replaceAll(RegExp(r"static String accentColor = '.*?';"), "static String accentColor = '${AppTheme.accentColor}';");
        newContent = newContent.replaceAll(RegExp(r"static String imageFilter = '.*?';"), "static String imageFilter = '${AppTheme.imageFilter}';");
        newContent = newContent.replaceAll(RegExp(r"static String globalAnimation = '.*?';"), "static String globalAnimation = '${AppTheme.globalAnimation}';");
        newContent = newContent.replaceAll(RegExp(r"static String transitionSpeed = '.*?';"), "static String transitionSpeed = '${AppTheme.transitionSpeed}';");
        newContent = newContent.replaceAll(RegExp(r"static String globalUIStyle = '.*?';"), "static String globalUIStyle = '${AppTheme.globalUIStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String buttonStyle = '.*?';"), "static String buttonStyle = '${AppTheme.buttonStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String cardStyle = '.*?';"), "static String cardStyle = '${AppTheme.cardStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String borderStyle = '.*?';"), "static String borderStyle = '${AppTheme.borderStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String fontStyle = '.*?';"), "static String fontStyle = '${AppTheme.fontStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String backgroundStyle = '.*?';"), "static String backgroundStyle = '${AppTheme.backgroundStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String parallaxIntensity = '.*?';"), "static String parallaxIntensity = '${AppTheme.parallaxIntensity}';");
        newContent = newContent.replaceAll(RegExp(r"static String hoverEffect = '.*?';"), "static String hoverEffect = '${AppTheme.hoverEffect}';");
        newContent = newContent.replaceAll(RegExp(r"static String cursorType = '.*?';"), "static String cursorType = '${AppTheme.cursorType}';");
        newContent = newContent.replaceAll(RegExp(r"static String heroStyle = '.*?';"), "static String heroStyle = '${AppTheme.heroStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String navbarStyle = '.*?';"), "static String navbarStyle = '${AppTheme.navbarStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String footerStyle = '.*?';"), "static String footerStyle = '${AppTheme.footerStyle}';");
        newContent = newContent.replaceAll(RegExp(r"static String formInputStyle = '.*?';"), "static String formInputStyle = '${AppTheme.formInputStyle}';");

        // 🔹 2. BOOLEANS REPLACEMENT (True/False Toggles)
        newContent = newContent.replaceAll(RegExp(r"static bool enableGlow = .*?;"), "static bool enableGlow = ${AppTheme.enableGlow};");
        newContent = newContent.replaceAll(RegExp(r"static bool enableBlur = .*?;"), "static bool enableBlur = ${AppTheme.enableBlur};");
        newContent = newContent.replaceAll(RegExp(r"static bool enableShadows = .*?;"), "static bool enableShadows = ${AppTheme.enableShadows};");
        newContent = newContent.replaceAll(RegExp(r"static bool enableGradients = .*?;"), "static bool enableGradients = ${AppTheme.enableGradients};");
        newContent = newContent.replaceAll(RegExp(r"static bool enableCursorEffect = .*?;"), "static bool enableCursorEffect = ${AppTheme.enableCursorEffect};");

        // 🚀 STEP 3: Push ALL changes back to GitHub
        final String newContentBase64 = base64Encode(utf8.encode(newContent));

        final putResponse = await http.put(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $secureToken', 'Accept': 'application/vnd.github.v3+json'},
          body: jsonEncode({
            'message': '🚀 ADMIN SYNC: Published 100% of Theme Settings Live!',
            'content': newContentBase64,
            'sha': sha,
          }),
        );

        if (putResponse.statusCode == 200 || putResponse.statusCode == 201) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('✅ FULL SYSTEM SYNCED! Code pushed to GitHub. Live in 90 seconds.', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white).copyWith(fontWeight: FontWeight.bold)), 
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ));
          }
        } else {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Publish Failed: ${putResponse.body}'), backgroundColor: Colors.redAccent));
        }
      } else {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Cannot fetch code (Error ${response.statusCode}). Check Token validity.'), backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.redAccent));
    }
    
    if (mounted) {
      setState(() => _isPublishing = false);
    }
  }

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
  void _showGlobalPasscodeDialog(BuildContext navContext, ThemeProvider provider) {
    _triggerSound();
    final TextEditingController passController = TextEditingController();
    
    showDialog(
      context: navContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.95), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: AppTheme.accent, width: 1.5)), 
        title: Text('RESTRICTED AREA', style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.redAccent)),
        
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: TextField(
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
                  ScaffoldMessenger.of(navContext).showSnackBar(SnackBar(
                    content: Text('🚀 SYSTEM OVERRIDE GRANTED', style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white).copyWith(fontWeight: FontWeight.bold)), 
                    backgroundColor: Colors.green.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                } else {
                  Navigator.pop(ctx);
                  if (AppTheme.enableSoundEffects) HapticFeedback.vibrate(); 
                  ScaffoldMessenger.of(navContext).showSnackBar(SnackBar(
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
            return Navigator(
              pages: [
                MaterialPage(
                  child: ScaffoldMessenger(
                    child: Scaffold(
                      resizeToAvoidBottomInset: false, 
                      backgroundColor: Colors.transparent,
                      body: Builder(
                        builder: (navContext) {
                          
                          // 📱 RESPONSIVE LOGIC
                          double screenWidth = MediaQuery.of(navContext).size.width;
                          double screenHeight = MediaQuery.of(navContext).size.height;
                          bool isMobile = screenWidth < 600; 
                          
                          double maxSafeWidth = screenWidth * 0.85; 
                          double safePanelWidth = isMobile ? screenWidth : _panelWidth.clamp(280.0, maxSafeWidth);

                          double maxFabX = screenWidth > 60.0 ? screenWidth - 60.0 : 0.0;
                          double maxFabY = screenHeight > 80.0 ? screenHeight - 80.0 : 0.0;

                          double currentFabX = _fabX ?? maxFabX;
                          double currentFabY = _fabY ?? (screenHeight > 100 ? screenHeight - 100.0 : 0.0);
                          
                          currentFabX = currentFabX.clamp(0.0, maxFabX); 
                          currentFabY = currentFabY.clamp(0.0, maxFabY);

                          bool isLeftHalf = currentFabX < (screenWidth / 2);

                          return Stack(
                            children: [
                              routerChild!, 

                              // ==========================================
                              // 🕵️‍♂️ GLOBAL SECRET TRIGGER
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
                                          _showGlobalPasscodeDialog(navContext, themeProvider); 
                                        }
                                      },
                                      child: const SizedBox(width: 80, height: 80), 
                                    ),
                                  ),
                                ),

                              // ==========================================
                              // 🎛️ PORTABLE GOD MODE PANEL
                              // ==========================================
                              if (themeProvider.isGodModeUnlocked)
                                Positioned(
                                  top: 0, bottom: 0,
                                  left: isLeftHalf ? 0 : null,
                                  right: !isLeftHalf ? 0 : null,
                                  child: AnimatedContainer(
                                    duration: _isResizing ? Duration.zero : const Duration(milliseconds: 500),
                                    curve: Curves.easeOutCubic,
                                    width: safePanelWidth,
                                    transform: Matrix4.translationValues(
                                      _isPanelOpen ? 0 : (isLeftHalf ? -safePanelWidth : safePanelWidth), 0, 0
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: safePanelWidth,
                                          height: double.infinity,
                                          child: Material(
                                            elevation: 30, 
                                            color: Colors.black.withValues(alpha: _panelOpacity), 
                                            child: _buildGlobalAdminPanel(themeProvider),
                                          ),
                                        ),
                                        
                                        if (!isMobile && _isPanelOpen)
                                          Positioned(
                                            right: isLeftHalf ? 0 : null, 
                                            left: !isLeftHalf ? 0 : null,
                                            top: 0, bottom: 0,
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.resizeLeftRight,
                                              child: GestureDetector(
                                                onPanStart: (_) => setState(() => _isResizing = true),
                                                onPanUpdate: (details) {
                                                  setState(() {
                                                    double delta = isLeftHalf ? details.delta.dx : -details.delta.dx;
                                                    _panelWidth += delta;
                                                    _panelWidth = _panelWidth.clamp(280.0, maxSafeWidth); 
                                                  });
                                                },
                                                onPanEnd: (_) => setState(() => _isResizing = false),
                                                child: Container(
                                                  width: 12, 
                                                  color: Colors.transparent, 
                                                  child: Center(
                                                    child: Container(
                                                      height: 50, width: 4,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.accent.withValues(alpha: 0.5), 
                                                        borderRadius: BorderRadius.circular(5)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                              // ==========================================
                              // 🚀 GLOBAL SETTINGS FAB (DRAGGABLE)
                              // ==========================================
                              if (themeProvider.isGodModeUnlocked)
                                AnimatedPositioned(
                                  duration: _isDragging ? Duration.zero : const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                  top: currentFabY, 
                                  left: _isPanelOpen 
                                      ? (isLeftHalf 
                                          ? (isMobile ? maxFabX : safePanelWidth + 20) 
                                          : (isMobile ? 25 : screenWidth - safePanelWidth - 85)) 
                                      : currentFabX,

                                  child: GestureDetector(
                                    onPanStart: (_) => setState(() => _isDragging = true),
                                    onPanUpdate: (details) {
                                      if (_isPanelOpen) return; 
                                      setState(() {
                                        _fabX = (_fabX ?? maxFabX) + details.delta.dx;
                                        _fabY = (_fabY ?? currentFabY) + details.delta.dy;
                                        _fabX = _fabX!.clamp(0.0, maxFabX);
                                        _fabY = _fabY!.clamp(0.0, maxFabY);
                                      });
                                    },
                                    onPanEnd: (_) => setState(() => _isDragging = false),
                                    
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
                                ),

                              // 🕵️‍♂️ THE GLOBAL GOD BAR
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
                        }
                      ),
                    ),
                  ),
                )
              ],
              onDidRemovePage: (page) {}, 
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
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20), 
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, color: AppTheme.accent, size: 28), 
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "GOD TIER CONTROL", 
                    style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🚀 Opacity Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Opacity", style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white54, weight: FontWeight.w600)),
                Expanded(
                  child: Slider(
                    value: _panelOpacity,
                    min: 0.4, 
                    max: 1.0, 
                    activeColor: AppTheme.accent,
                    inactiveColor: Colors.white24,
                    onChanged: (val) => setState(() => _panelOpacity = val),
                  ),
                ),
              ],
            ),
            
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

            // ==========================================
            // 🔐 7. SECURE DEPLOYMENT (NEW UPGRADE)
            // ==========================================
            _buildSectionTitle("🔐 7. SECURE DEPLOYMENT"),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _tokenController,
                obscureText: true, // Password ki tarah hide karega
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Paste GitHub Token (ghp_...)',
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.vpn_key_rounded, color: AppTheme.accent, size: 18),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
                ),
              ),
            ),

            // ==========================================
            // 🚀 BUTTONS SECTION (MASTER RESET & PUBLISH)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 🛑 Master Reset Button
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _triggerSound();
                      provider.resetToDefault();
                      setState(() {
                        _panelWidth = 380.0;
                        _panelOpacity = 0.95;
                      });
                    },
                    icon: const Icon(Icons.warning_rounded, color: Colors.white, size: 16),
                    label: const Text("RESET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                  ),
                ),

                // 🚀 Publish Live Button
                MouseRegion(
                  cursor: _isPublishing ? SystemMouseCursors.wait : SystemMouseCursors.click,
                  child: ElevatedButton.icon(
                    onPressed: _isPublishing ? null : () {
                      _triggerSound();
                      _publishToGitHub(context);
                    },
                    icon: _isPublishing 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 16),
                    label: Text(_isPublishing ? "PUBLISHING..." : "PUBLISH LIVE", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      disabledBackgroundColor: Colors.green.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 120), 
          ],
        ),
      ),
    );
  }

  // 🛠️ UI Helpers
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
                activeThumbColor: AppTheme.bg, 
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
          Expanded(
            child: Row(
              children: [
                Icon(Icons.precision_manufacturing_rounded, color: AppTheme.cardBg, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "GOD MODE ACTIVE: CLICK ANY TEXT OR CARD TO EDIT", 
                    style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.cardBg).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
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