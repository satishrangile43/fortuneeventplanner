import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';

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

class FortuneEventApp extends StatelessWidget {
  const FortuneEventApp({super.key});

  // 🧠 SMART MAPPER: 16+ Themes ko FlexScheme color mein badalta hai
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        
        // 🚀 THEME & COLOR SYNC
        String activeThemeName = AppTheme.activeTheme;
        FlexScheme currentScheme = _getFlexScheme(activeThemeName);

        // 🚀 SMART LIGHT/DARK MODE
        ThemeMode currentMode = (activeThemeName == 'light' || activeThemeName == 'minimalist' || activeThemeName == 'ice') 
            ? ThemeMode.light 
            : ThemeMode.dark;

        // 🚀 DYNAMIC FONT SYNC (AppTheme ke fontStyle se link)
        String? currentFontFamily = AppTheme.getBodyStyle(fontSize: 14).fontFamily;

        return MaterialApp.router(
          title: 'Fortune Event Planner',
          debugShowCheckedModeBanner: false,
          
          // 🎨 DYNAMIC LIGHT THEME
          theme: FlexThemeData.light(
            scheme: currentScheme,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 10,
            appBarStyle: FlexAppBarStyle.background,
            bottomAppBarElevation: 1.0,
            useMaterial3: true,
            fontFamily: currentFontFamily, // 🔥 FONT ENGINE LINKED
          ),
          
          // 🌙 DYNAMIC DARK THEME 
          darkTheme: FlexThemeData.dark(
            scheme: currentScheme,
            surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
            blendLevel: 13,
            useMaterial3: true,
            fontFamily: currentFontFamily, // 🔥 FONT ENGINE LINKED
          ),
          
          themeMode: currentMode, 
          routerConfig: appRouter,

          // ==========================================
          // 🚀 THE GLOBAL GOD BAR (SLIM PATTI) - RULE #4
          // ==========================================
          builder: (context, routerChild) {
            return Stack(
              children: [
                routerChild!, // Actual Website Pages
                
                // 🕵️‍♂️ RULE 5: Hidden from public. Unlock hone par dikhegi!
                if (themeProvider.isGodModeUnlocked)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: themeProvider.isSelectionMode ? 60 : 6, // 6px jab choti ho
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          boxShadow: [
                            BoxShadow(color: AppTheme.accent.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, -2))
                          ]
                        ),
                        child: themeProvider.isSelectionMode
                            ? _buildExpandedGodBar(themeProvider)
                            : GestureDetector(
                                onTap: () => themeProvider.toggleSelectionMode(), // Expand on Tap
                                child: Container(color: Colors.transparent), // Clickable area
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

  // 🎛️ EXPANDED GOD BAR UI
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
              Text(
                "GOD MODE ACTIVE: CLICK ANY TEXT/BUTTON TO EDIT", 
                style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.black, weight: FontWeight.bold)
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () => provider.toggleSelectionMode(), // Wapas slim
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            label: const Text("HIDE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}