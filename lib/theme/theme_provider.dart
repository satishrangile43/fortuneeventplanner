import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // ==========================================
  // 🚀 THE ULTIMATE REAL ENGINE (GOD TIER CONTROL)
  // ==========================================
  
  // 🔓 God Mode Active Switch
  bool isSelectionMode = false; 

  // 🎯 Map to store individual object customizations
  Map<String, dynamic> elementSettings = {};

  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    notifyListeners();
  }

  void updateElement(String key, dynamic value) {
    elementSettings[key] = value;
    notifyListeners();
  }

  void clearElementSetting(String key) {
    elementSettings.remove(key);
    notifyListeners();
  }

  bool isGodModeUnlocked = false; 

  void unlockGodMode() {
    isGodModeUnlocked = true;
    notifyListeners();
  }

  // ==========================================
  // 🎨 1. THEMES, COLORS & FILTERS (GLOBAL)
  // ==========================================
  void changeTheme(String newTheme) {
    AppTheme.activeTheme = newTheme;
    // 🧠 SMART LOGIC: Auto-adjust autoDarkMode toggle if manually forced
    AppTheme.autoDarkMode = false; 
    notifyListeners();
  }

  void updateAccentColor(String newAccent) {
    AppTheme.accentColor = newAccent;
    notifyListeners();
  }
  
  // 🆕 NAYA: Image Filters (Grayscale, Sepia, etc.)
  void updateImageFilter(String newFilter) {
    AppTheme.imageFilter = newFilter;
    notifyListeners();
  }

  // ==========================================
  // ✨ 2. ANIMATIONS & TRANSITIONS
  // ==========================================
  void updateAnimation(String newAnim) {
    AppTheme.globalAnimation = newAnim;
    notifyListeners();
  }

  // 🆕 NAYA: Transition Speed (Slow, Normal, Fast)
  void updateTransitionSpeed(String speed) {
    AppTheme.transitionSpeed = speed;
    notifyListeners();
  }

  // ==========================================
  // 🧊 3. UI, LAYOUT & SHAPES
  // ==========================================
  void updateUIStyle(String newStyle) {
    AppTheme.globalUIStyle = newStyle;
    
    // 🧠 SMART LOGIC: If Glassmorphism is selected, Blur MUST be true for the effect to work
    if (newStyle == 'glass' && !AppTheme.enablePerformanceMode) {
      AppTheme.enableBlur = true;
    }
    // 🧠 SMART LOGIC: If Neumorphism is selected, Shadows MUST be true
    if (newStyle == 'neumorphic') {
      AppTheme.enableShadows = true;
    }
    
    notifyListeners();
  }

  void updateLayoutStyle(String newLayout) {
    AppTheme.layoutStyle = newLayout;
    notifyListeners();
  }

  void updateButtonStyle(String newButtonStyle) {
    AppTheme.buttonStyle = newButtonStyle;
    notifyListeners();
  }

  void updateCardStyle(String newCardStyle) {
    AppTheme.cardStyle = newCardStyle;
    notifyListeners();
  }

  // 🆕 NAYA: Border Radius Styles (Sharp, Squircle, Rounded)
  void updateBorderStyle(String newBorder) {
    AppTheme.borderStyle = newBorder;
    notifyListeners();
  }

  // ==========================================
  // 🔠 4. FONTS & BACKGROUND
  // ==========================================
  void updateFontStyle(String newFont) {
    AppTheme.fontStyle = newFont;
    notifyListeners();
  }

  void updateBackgroundStyle(String newBackground) {
    AppTheme.backgroundStyle = newBackground;
    
    // 🧠 SMART LOGIC: If mesh or gradient background is selected, turn on gradients
    if (newBackground == 'mesh' || newBackground == 'gradient') {
      AppTheme.enableGradients = true;
    }
    
    notifyListeners();
  }

  // ==========================================
  // 🌟 5. EFFECTS, HOVER & 3D PARALLAX
  // ==========================================
  void updateHoverEffect(String newHover) {
    AppTheme.hoverEffect = newHover;
    notifyListeners();
  }

  // 🆕 NAYA: 3D Parallax Intensity
  void updateParallaxIntensity(String intensity) {
    AppTheme.parallaxIntensity = intensity;
    notifyListeners();
  }

  void toggleGlow(bool value) {
    AppTheme.enableGlow = value;
    notifyListeners();
  }

  void toggleBlur(bool value) {
    AppTheme.enableBlur = value;
    notifyListeners();
  }

  void toggleShadows(bool value) {
    AppTheme.enableShadows = value;
    notifyListeners();
  }

  void toggleGradients(bool value) {
    AppTheme.enableGradients = value;
    notifyListeners();
  }

  void toggleParticles(bool value) {
    AppTheme.enableParticles = value;
    notifyListeners();
  }

  // 🆕 NAYA: Custom Cursor Type (Dot, Ring, None)
  void updateCursorType(String cursorType) {
    AppTheme.cursorType = cursorType;
    notifyListeners();
  }

  void toggleCursorEffect(bool value) {
    AppTheme.enableCursorEffect = value;
    notifyListeners();
  }

  // ==========================================
  // ⚡ 6. SCROLL & RESPONSIVE
  // ==========================================
  void updateScrollEffect(String newScroll) {
    AppTheme.scrollEffect = newScroll;
    notifyListeners();
  }

  void updateMobileLayout(String newLayout) {
    AppTheme.mobileLayout = newLayout;
    notifyListeners();
  }

  // ==========================================
  // 🎯 7. HEADER, FOOTER & FORMS
  // ==========================================
  void updateHeroStyle(String newStyle) {
    AppTheme.heroStyle = newStyle;
    notifyListeners();
  }

  // 🆕 NAYA: Navbar Behavior (Sticky, Floating, Hidden)
  void updateNavbarStyle(String style) {
    AppTheme.navbarStyle = style;
    notifyListeners();
  }

  // 🆕 NAYA: Footer Style (Minimal, Expanded)
  void updateFooterStyle(String style) {
    AppTheme.footerStyle = style;
    notifyListeners();
  }

  // 🆕 NAYA: Form Input Styles (Filled, Outlined, Underlined)
  void updateFormInputStyle(String style) {
    AppTheme.formInputStyle = style;
    notifyListeners();
  }

  void updateHeroTitle(String text) {
    AppTheme.heroTitle = text;
    notifyListeners();
  }

  void updateHeroSubtitle(String text) {
    AppTheme.heroSubtitle = text;
    notifyListeners();
  }

  void updateHeroCTA(String text) {
    AppTheme.heroCTA = text;
    notifyListeners();
  }

  // ==========================================
  // 🎬 8. LOADER, SOUND & NOTIFICATIONS
  // ==========================================
  void updateLoaderStyle(String newLoader) {
    AppTheme.loaderStyle = newLoader;
    notifyListeners();
  }

  // 🆕 NAYA: Sound Packs
  void updateSoundPack(String pack) {
    AppTheme.soundPack = pack;
    notifyListeners();
  }

  void toggleSoundEffects(bool value) {
    AppTheme.enableSoundEffects = value;
    notifyListeners();
  }

  // 🆕 NAYA: Toast/Snackbar Style
  void updateToastStyle(String style) {
    AppTheme.toastStyle = style;
    notifyListeners();
  }

  // ==========================================
  // 🌙 9. ADVANCED & PERFORMANCE (SMART ENGINE)
  // ==========================================
  void toggleAutoDarkMode(bool value) {
    AppTheme.autoDarkMode = value;
    notifyListeners();
  }

  void toggleAIThemeSwitch(bool value) {
    AppTheme.enableAIThemeSwitch = value;
    notifyListeners();
  }

  void togglePerformanceMode(bool value) {
    AppTheme.enablePerformanceMode = value;
    
    // 🧠 SMART LOGIC: Auto-disable Heavy Rendering for Max FPS
    if (value) {
      AppTheme.enableBlur = false;
      AppTheme.enableParticles = false;
      AppTheme.enableGlow = false;
      AppTheme.parallaxIntensity = 'none';
      AppTheme.scrollEffect = 'smooth';
      AppTheme.transitionSpeed = 'fast'; // Faster transitions = less frame drops
    }
    
    notifyListeners();
  }

  // ==========================================
  // 🛠️ 10. MASTER RESET (THE GOD TIER PRESET)
  // ==========================================
  void resetToDefault() {
    isSelectionMode = false;
    elementSettings.clear(); 
    
    // 🧠 Core: Dark/Light Adaptive
    AppTheme.activeTheme = 'dark'; // Dark theme defaults look more premium
    AppTheme.accentColor = 'auto';
    AppTheme.imageFilter = 'none';
    
    // 🧠 UI & Motion: Buttery Smooth & Modern
    AppTheme.globalAnimation = 'fade'; // Fade is smoother than zoom out of the box
    AppTheme.transitionSpeed = 'normal';
    AppTheme.globalUIStyle = 'glass'; // Glassmorphism is top-tier trend
    AppTheme.layoutStyle = 'modern';
    AppTheme.buttonStyle = 'pill'; // Pill buttons give a sleek SaaS look
    AppTheme.cardStyle = 'elevated';
    AppTheme.borderStyle = 'squircle'; // Apple-like smooth corners
    AppTheme.fontStyle = 'modern';
    AppTheme.backgroundStyle = 'gradient'; // Richer background
    
    // 🧠 Effects: Balanced Depth
    AppTheme.hoverEffect = 'parallax'; // 3D feel
    AppTheme.parallaxIntensity = 'medium';
    AppTheme.enableGlow = true; // Subtle glowing accents
    AppTheme.enableBlur = true; // Required for glass UI
    AppTheme.enableShadows = true;
    AppTheme.enableGradients = true;
    AppTheme.enableParticles = false; // Off by default to save battery
    AppTheme.enableCursorEffect = true;
    AppTheme.cursorType = 'ring'; // Premium cursor for web
    
    // 🧠 Layout & Components
    AppTheme.scrollEffect = 'bouncy'; // iOS style bounce
    AppTheme.mobileLayout = 'adaptive';
    AppTheme.heroStyle = 'centered';
    AppTheme.navbarStyle = 'floating'; // Floating navbars look luxurious
    AppTheme.footerStyle = 'expanded';
    AppTheme.formInputStyle = 'filled';
    AppTheme.loaderStyle = 'spinner';
    
    // 🧠 Sounds & Alerts
    AppTheme.enableSoundEffects = true; // Micro-interactions feel alive
    AppTheme.soundPack = 'clicky';
    AppTheme.toastStyle = 'glass'; // Matches global UI style
    
    // 🧠 System
    AppTheme.autoDarkMode = true;
    AppTheme.enablePerformanceMode = false;
    
    notifyListeners();
  }
}