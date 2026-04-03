import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart'; // 🚀 Haptics support
import 'dart:convert'; // 🚀 JSON encode/decode
import 'package:http/http.dart' as http; // 🚀 GitHub API call
import 'package:url_launcher/url_launcher.dart'; // 🚀 WhatsApp & Insta link open karne ke liye
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // 🚀 Official WhatsApp/Insta Icons ke liye

// Tumhare custom paths (Agar path error aaye toh inko check kar lena)
import 'routes/app_router.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart'; // 🚀 MASTER ENGINE IMPORTED

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 🟢 Makes system nav bar transparent for a cleaner edge-to-edge look on Android/iOS
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, 
      systemNavigationBarColor: Colors.transparent
    ),
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
  // 🔐 1. GLOBAL SECRETS & STATE
  // ==========================================
  int _secretTapCount = 0;
  final String _adminPasscode = "LOVEDAYBITTU"; 
  bool _isPanelOpen = false; 
  bool _isPublishing = false;
  
  // 🚀 NAYI STATE: Contact page track karne ke liye
  bool _isContactPage = false; 

  // ==========================================
  // 🎛️ 2. DRAGGABLE GOD MODE & UI STATE
  // ==========================================
  double? _fabX; 
  double? _fabY;
  bool _isDragging = false; 
  double _panelWidth = 380.0; 
  double _panelOpacity = 0.95; 
  bool _isResizing = false; 

  // ==========================================
  // 🌐 3. GITHUB CREDENTIALS & CONTROLLERS
  // ==========================================
  final TextEditingController _tokenController = TextEditingController(); 
  final String _githubUsername = 'satishrangile43';
  final String _githubRepo = 'fortuneeventplanner';
  final String _filePath = 'lib/theme/app_theme.dart';

  @override
  void initState() {
    super.initState();
    // 🚀 ROUTE LISTENER: Check karne ke liye ki hum Contact page par hain ya nahi
    appRouter.routerDelegate.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    final String location = appRouter.routerDelegate.currentConfiguration.uri.toString();
    bool currentlyContact = location.contains('/contact');
    if (_isContactPage != currentlyContact) {
      if (mounted) {
        setState(() {
          _isContactPage = currentlyContact;
        });
      }
    }
  }

  @override
  void dispose() {
    appRouter.routerDelegate.removeListener(_onRouteChanged); // Memory leak se bachne ke liye
    _tokenController.dispose(); 
    super.dispose();
  }

  // ==========================================
  // ⚙️ 4. CORE LOGIC & METHODS
  // ==========================================
  
  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }
  }

  Future<void> _publishToGitHub(BuildContext context) async {
    final String secureToken = _tokenController.text.trim();

    if (secureToken.isEmpty) {
      _showSnackBar(context, '❌ Please enter your GitHub Token below first!', Colors.redAccent.shade700);
      return;
    }

    setState(() => _isPublishing = true);
    final String url = 'https://api.github.com/repos/$_githubUsername/$_githubRepo/contents/$_filePath';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $secureToken', 'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String sha = data['sha'];
        final String contentBase64 = data['content'].replaceAll('\n', '');
        final String currentContent = utf8.decode(base64Decode(contentBase64));

        String newContent = currentContent;
        
        // 🔹 STRINGS REPLACEMENT
        final Map<String, String> stringReplacements = {
          "activeTheme": AppTheme.activeTheme,
          "accentColor": AppTheme.accentColor,
          "imageFilter": AppTheme.imageFilter,
          "globalAnimation": AppTheme.globalAnimation,
          "transitionSpeed": AppTheme.transitionSpeed,
          "globalUIStyle": AppTheme.globalUIStyle,
          "buttonStyle": AppTheme.buttonStyle,
          "cardStyle": AppTheme.cardStyle,
          "borderStyle": AppTheme.borderStyle,
          "fontStyle": AppTheme.fontStyle,
          "backgroundStyle": AppTheme.backgroundStyle,
          "parallaxIntensity": AppTheme.parallaxIntensity,
          "hoverEffect": AppTheme.hoverEffect,
          "cursorType": AppTheme.cursorType,
          "heroStyle": AppTheme.heroStyle,
          "navbarStyle": AppTheme.navbarStyle,
          "footerStyle": AppTheme.footerStyle,
          "formInputStyle": AppTheme.formInputStyle,
        };

        stringReplacements.forEach((key, value) {
          newContent = newContent.replaceAll(RegExp(r"static String " + key + r" = '.*?';"), "static String $key = '$value';");
        });

        // 🔹 BOOLEANS REPLACEMENT
        final Map<String, bool> boolReplacements = {
          "enableGlow": AppTheme.enableGlow,
          "enableBlur": AppTheme.enableBlur,
          "enableShadows": AppTheme.enableShadows,
          "enableGradients": AppTheme.enableGradients,
          "enableCursorEffect": AppTheme.enableCursorEffect,
        };

        boolReplacements.forEach((key, value) {
          newContent = newContent.replaceAll(RegExp(r"static bool " + key + r" = .*?;"), "static bool $key = $value;");
        });

        // 🚀 PUSH TO GITHUB
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
          if (context.mounted) _showSnackBar(context, '✅ FULL SYSTEM SYNCED! Live in 90 seconds.', Colors.green.shade700);
        } else {
          if (context.mounted) _showSnackBar(context, '❌ Publish Failed: ${putResponse.body}', Colors.redAccent);
        }
      } else {
        if (context.mounted) _showSnackBar(context, '❌ Cannot fetch code. Check Token validity.', Colors.redAccent);
      }
    } catch (e) {
      if (context.mounted) _showSnackBar(context, '❌ Error: $e', Colors.redAccent);
    }
    
    if (mounted) setState(() => _isPublishing = false);
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white).copyWith(fontWeight: FontWeight.bold)), 
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _openWhatsApp() async {
    _triggerSound();
    
    const String phoneNumber = "918889155593"; 
    const String message = "Hello! I want to plan an event."; 
    
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication); 
      } else {
        if (mounted) {
          _showSnackBar(context, '❌ Could not open WhatsApp. Is it installed?', Colors.redAccent);
        }
      }
    } catch (e) {
      if (mounted) {
         _showSnackBar(context, '❌ Error opening WhatsApp', Colors.redAccent);
      }
    }
  }

  // 🚀 NAYA INSTAGRAM FUNCTION
  Future<void> _openInstagram() async {
    _triggerSound();
    final Uri instaUri = Uri.parse("https://www.instagram.com/fortuneeventplanner1?igsh=MWgwOWNmb2c0cnkydw%3D%3D&utm_source=qr");

    try {
      if (await canLaunchUrl(instaUri)) {
        await launchUrl(instaUri, mode: LaunchMode.externalApplication); 
      } else {
        if (mounted) {
          _showSnackBar(context, '❌ Could not open Instagram.', Colors.redAccent);
        }
      }
    } catch (e) {
      if (mounted) {
         _showSnackBar(context, '❌ Error opening Instagram', Colors.redAccent);
      }
    }
  }

  FlexScheme _getFlexScheme(String themeName) {
    const Map<String, FlexScheme> schemes = {
      'luxury': FlexScheme.gold, 'cyberpunk': FlexScheme.cyanM3, 'hacker': FlexScheme.green,
      'ocean': FlexScheme.aquaBlue, 'dracula': FlexScheme.deepPurple, 'sunset': FlexScheme.orangeM3,
      'minimalist': FlexScheme.greyLaw, 'light': FlexScheme.blue, 'dark': FlexScheme.greyLaw,
      'neon': FlexScheme.mandyRed, 'retro': FlexScheme.vesuviusBurn, 'pastel': FlexScheme.sakura,
      'midnight': FlexScheme.indigo, 'forest': FlexScheme.jungle, 'galaxy': FlexScheme.deepBlue,
      'fire': FlexScheme.redWine, 'ice': FlexScheme.cyanM3,
    };
    return schemes[themeName] ?? FlexScheme.gold;
  }

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
        content: TextField(
          controller: passController, 
          obscureText: true, 
          style: const TextStyle(color: Colors.white, letterSpacing: 2.0), 
          decoration: InputDecoration(
            hintText: 'Enter Admin Passcode', 
            hintStyle: const TextStyle(color: Colors.white30), 
            filled: true, 
            fillColor: Colors.white.withValues(alpha: 0.05), 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () { _triggerSound(); _secretTapCount = 0; Navigator.pop(ctx); }, 
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              _triggerSound();
              if (passController.text == _adminPasscode) {
                provider.unlockGodMode(); 
                Navigator.pop(ctx);
                _showSnackBar(navContext, '🚀 SYSTEM OVERRIDE GRANTED', Colors.green.shade700);
              } else {
                Navigator.pop(ctx);
                if (AppTheme.enableSoundEffects) HapticFeedback.vibrate(); 
                _showSnackBar(navContext, '❌ ACCESS DENIED', Colors.redAccent.shade700);
                _secretTapCount = 0; 
              }
            },
            child: Text('OVERRIDE', style: TextStyle(color: AppTheme.bg, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 📱 5. MASTER BUILD METHOD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        String activeThemeName = AppTheme.activeTheme;
        FlexScheme currentScheme = _getFlexScheme(activeThemeName);
        ThemeMode currentMode = (['light', 'minimalist', 'ice'].contains(activeThemeName)) ? ThemeMode.light : ThemeMode.dark;
        String? currentFontFamily = AppTheme.getBodyStyle(fontSize: 14).fontFamily;

        return MaterialApp.router(
          title: 'Fortune Event Planner',
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(scheme: currentScheme, useMaterial3: true, fontFamily: currentFontFamily),
          darkTheme: FlexThemeData.dark(scheme: currentScheme, useMaterial3: true, fontFamily: currentFontFamily),
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
                          double screenWidth = MediaQuery.of(navContext).size.width;
                          double screenHeight = MediaQuery.of(navContext).size.height;
                          bool isMobile = screenWidth < 600; 
                          double maxSafeWidth = screenWidth * 0.85; 
                          double safePanelWidth = isMobile ? screenWidth : _panelWidth.clamp(280.0, maxSafeWidth);

                          double maxFabX = screenWidth > 60.0 ? screenWidth - 60.0 : 0.0;
                          double maxFabY = screenHeight > 80.0 ? screenHeight - 80.0 : 0.0;
                          double currentFabX = (_fabX ?? maxFabX).clamp(0.0, maxFabX);
                          double currentFabY = (_fabY ?? (screenHeight > 100 ? screenHeight - 100.0 : 0.0)).clamp(0.0, maxFabY);
                          bool isLeftHalf = currentFabX < (screenWidth / 2);

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
                                      if (_secretTapCount >= 5) _showGlobalPasscodeDialog(navContext, themeProvider);
                                    },
                                    child: const SizedBox(width: 80, height: 80), 
                                  ),
                                ),

                              // 🎛️ PORTABLE GOD MODE PANEL
                              if (themeProvider.isGodModeUnlocked)
                                _buildSlidingGodPanel(isLeftHalf, safePanelWidth, maxSafeWidth, isMobile, themeProvider),

                              // 🚀 GLOBAL SETTINGS FAB (DRAGGABLE)
                              if (themeProvider.isGodModeUnlocked)
                                _buildDraggableGodFab(currentFabX, currentFabY, maxFabX, maxFabY, isLeftHalf, safePanelWidth, isMobile, screenWidth),

                              // 🕵️‍♂️ THE GLOBAL GOD BAR
                              if (themeProvider.isGodModeUnlocked)
                                _buildGlobalGodBar(themeProvider),

                              // ==========================================
                              // 🟢 UPGRADED: WHATSAPP & INSTA FLOATING ICONS
                              // ==========================================
                              if (!_isContactPage) ...[
                                
                                // 🟣 INSTAGRAM BUTTON
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutBack,
                                  bottom: themeProvider.isSelectionMode ? 145 : 95, // 🚀 Automatically stacks above WhatsApp
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: _openInstagram,
                                    child: Container(
                                      height: 55, width: 55,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFF56040)],
                                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: const Color(0xFFFD1D1D).withValues(alpha: 0.4), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 4))]
                                      ),
                                      child: const Icon(FontAwesomeIcons.instagram, color: Colors.white, size: 28),
                                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2.seconds, color: Colors.white30),
                                  ),
                                ),

                                // 🟢 WHATSAPP BUTTON (Upgraded with Official Icon)
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutBack,
                                  bottom: themeProvider.isSelectionMode ? 80 : 30, // Dynamic height! Avoids God Bar!
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: _openWhatsApp,
                                    child: Container(
                                      height: 55, width: 55,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF25D366), // 🚀 Official WhatsApp Green
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: const Color(0xFF25D366).withValues(alpha: 0.4), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 4))]
                                      ),
                                      child: const Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 28),
                                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 2.seconds, color: Colors.white30),
                                  ),
                                ),
                              ],
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
  // 🧩 6. EXTRACTED UI WIDGET COMPONENTS
  // ==========================================

  Widget _buildSlidingGodPanel(bool isLeftHalf, double safePanelWidth, double maxSafeWidth, bool isMobile, ThemeProvider themeProvider) {
    return Positioned(
      top: 0, bottom: 0, left: isLeftHalf ? 0 : null, right: !isLeftHalf ? 0 : null,
      child: AnimatedContainer(
        duration: _isResizing ? Duration.zero : const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        width: safePanelWidth,
        transform: Matrix4.translationValues(_isPanelOpen ? 0 : (isLeftHalf ? -safePanelWidth : safePanelWidth), 0, 0),
        child: Stack(
          children: [
            SizedBox(
              width: safePanelWidth, height: double.infinity,
              child: Material(elevation: 30, color: Colors.black.withValues(alpha: _panelOpacity), child: _buildGlobalAdminPanel(themeProvider)),
            ),
            if (!isMobile && _isPanelOpen)
              Positioned(
                right: isLeftHalf ? 0 : null, left: !isLeftHalf ? 0 : null, top: 0, bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: GestureDetector(
                    onPanStart: (_) => setState(() => _isResizing = true),
                    onPanUpdate: (details) => setState(() => _panelWidth = (_panelWidth + (isLeftHalf ? details.delta.dx : -details.delta.dx)).clamp(280.0, maxSafeWidth)),
                    onPanEnd: (_) => setState(() => _isResizing = false),
                    child: Container(
                      width: 12, color: Colors.transparent, 
                      child: Center(child: Container(height: 50, width: 4, decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(5)))),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableGodFab(double currentFabX, double currentFabY, double maxFabX, double maxFabY, bool isLeftHalf, double safePanelWidth, bool isMobile, double screenWidth) {
    return AnimatedPositioned(
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      top: currentFabY, 
      left: _isPanelOpen ? (isLeftHalf ? (isMobile ? maxFabX : safePanelWidth + 20) : (isMobile ? 25 : screenWidth - safePanelWidth - 85)) : currentFabX,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          if (_isPanelOpen) return; 
          setState(() {
            _fabX = ((_fabX ?? maxFabX) + details.delta.dx).clamp(0.0, maxFabX);
            _fabY = ((_fabY ?? currentFabY) + details.delta.dy).clamp(0.0, maxFabY);
          });
        },
        onPanEnd: (_) => setState(() => _isDragging = false),
        child: FloatingActionButton(
          backgroundColor: AppTheme.accent,
          elevation: AppTheme.enableShadows ? 15 : 0, 
          onPressed: () { _triggerSound(); setState(() => _isPanelOpen = !_isPanelOpen); },
          child: Icon(_isPanelOpen ? Icons.close_rounded : Icons.dashboard_customize_rounded, color: AppTheme.cardBg, size: 28),
        ).animate().fade().scale(curve: Curves.easeOutBack), 
      ),
    );
  }

  Widget _buildGlobalGodBar(ThemeProvider themeProvider) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack, 
          height: themeProvider.isSelectionMode ? 60 : 6, 
          decoration: BoxDecoration(color: AppTheme.accent, boxShadow: [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.6), blurRadius: 20, offset: const Offset(0, -2))]),
          child: themeProvider.isSelectionMode
            ? _buildExpandedGodBar(themeProvider)
            : GestureDetector(behavior: HitTestBehavior.opaque, onTap: () { _triggerSound(); themeProvider.toggleSelectionMode(); }, child: Container(color: Colors.transparent)),
        ),
      ),
    );
  }

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
                Expanded(child: Text("GOD TIER CONTROL", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Opacity", style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white54, weight: FontWeight.w600)),
                Expanded(child: Slider(value: _panelOpacity, min: 0.4, max: 1.0, activeColor: AppTheme.accent, inactiveColor: Colors.white24, onChanged: (val) => setState(() => _panelOpacity = val))),
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

            _buildSectionTitle("🔐 7. SECURE DEPLOYMENT"),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _tokenController, obscureText: true, style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Paste GitHub Token (ghp_...)', hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: Icon(Icons.vpn_key_rounded, color: AppTheme.accent, size: 18), filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () { _triggerSound(); provider.resetToDefault(); setState(() { _panelWidth = 380.0; _panelOpacity = 0.95; }); },
                  icon: const Icon(Icons.warning_rounded, color: Colors.white, size: 16),
                  label: const Text("RESET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade700, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                ),
                ElevatedButton.icon(
                  onPressed: _isPublishing ? null : () { _triggerSound(); _publishToGitHub(context); },
                  icon: _isPublishing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 16),
                  label: Text(_isPublishing ? "PUBLISHING..." : "PUBLISH LIVE", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                ),
              ],
            ),
            const SizedBox(height: 120), 
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🎨 7. HELPER WIDGETS
  // ==========================================
  
  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Text(title.toUpperCase(), style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.accent).copyWith(fontWeight: FontWeight.w800, letterSpacing: 2.0)));
  
  Widget _buildAdminLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(t, style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white60).copyWith(fontWeight: FontWeight.w600)));
  
  Widget _buildCustomPicker(String label, String currentValue, List<String> items, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminLabel(label),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
            child: Row(
              children: items.map((item) {
                bool isSelected = currentValue == item;
                return GestureDetector(
                  onTap: () { _triggerSound(); onSelect(item); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic, margin: const EdgeInsets.only(right: 12), padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 15, vertical: 10), 
                    decoration: BoxDecoration(color: isSelected ? AppTheme.accent : Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(50), border: Border.all(color: isSelected ? AppTheme.accent : Colors.transparent), boxShadow: isSelected ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))] : []),
                    child: Text(item.toUpperCase(), style: AppTheme.getBodyStyle(fontSize: 11, color: isSelected ? AppTheme.bg : Colors.white70).copyWith(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, letterSpacing: 1.0)),
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
    switch(name) { case 'blue': return Colors.blueAccent; case 'purple': return Colors.purpleAccent; case 'green': return Colors.greenAccent; case 'red': return Colors.redAccent; case 'gold': return const Color(0xFFD6A762); case 'pink': return Colors.pinkAccent; case 'cyan': return Colors.cyanAccent; default: return Colors.white54; }
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
              return GestureDetector(
                onTap: () { _triggerSound(); onSelect(item); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200), width: isSelected ? 42 : 35, height: isSelected ? 42 : 35,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _getColorFromName(item), border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: isSelected ? 2 : 0), boxShadow: isSelected ? [BoxShadow(color: _getColorFromName(item).withValues(alpha: 0.8), blurRadius: 15, spreadRadius: 2)] : []),
                  child: item == 'auto' ? Icon(Icons.auto_awesome_mosaic_rounded, size: isSelected ? 22 : 18, color: isSelected ? Colors.black : Colors.white) : null,
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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, onTap: () { _triggerSound(); onChanged(!value); },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Text(label, style: AppTheme.getBodyStyle(fontSize: 14, color: value ? Colors.white : Colors.white70).copyWith(fontWeight: value ? FontWeight.bold : FontWeight.w500)), 
            Switch(value: value, activeThumbColor: AppTheme.bg, activeTrackColor: AppTheme.accent, inactiveTrackColor: Colors.white.withValues(alpha: 0.1), inactiveThumbColor: Colors.white54, onChanged: (v) { _triggerSound(); onChanged(v); })
          ]
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
          Expanded(child: Row(children: [Icon(Icons.precision_manufacturing_rounded, color: AppTheme.cardBg, size: 24), const SizedBox(width: 15), Expanded(child: Text("GOD MODE ACTIVE: CLICK ANY TEXT OR CARD TO EDIT", style: AppTheme.getBodyStyle(fontSize: 13, color: AppTheme.cardBg).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.0), overflow: TextOverflow.ellipsis))])),
          const SizedBox(width: 10),
          TextButton.icon(onPressed: () { _triggerSound(); provider.toggleSelectionMode(); }, icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.cardBg, size: 24), label: Text("HIDE", style: TextStyle(color: AppTheme.cardBg, fontWeight: FontWeight.w900, letterSpacing: 1.5)))
        ],
      ),
    );
  }
}