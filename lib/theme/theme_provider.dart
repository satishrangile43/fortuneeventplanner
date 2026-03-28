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
  // 🌙 9. ADVANCED & PERFORMANCE
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
    notifyListeners();
  }

  // ==========================================
  // 🛠️ 10. MASTER RESET (Clears Everything)
  // ==========================================
  void resetToDefault() {
    isSelectionMode = false;
    elementSettings.clear(); 
    
    // Core
    AppTheme.activeTheme = 'light';
    AppTheme.accentColor = 'auto';
    AppTheme.imageFilter = 'none';
    
    // UI & Motion
    AppTheme.globalAnimation = 'zoom';
    AppTheme.transitionSpeed = 'normal';
    AppTheme.globalUIStyle = 'flat';
    AppTheme.layoutStyle = 'modern';
    AppTheme.buttonStyle = 'rounded';
    AppTheme.cardStyle = 'elevated';
    AppTheme.borderStyle = 'rounded';
    AppTheme.fontStyle = 'modern';
    AppTheme.backgroundStyle = 'plain';
    
    // Effects
    AppTheme.hoverEffect = 'lift';
    AppTheme.parallaxIntensity = 'low';
    AppTheme.enableGlow = false;
    AppTheme.enableBlur = false;
    AppTheme.enableShadows = true;
    AppTheme.enableGradients = true;
    AppTheme.enableParticles = false;
    AppTheme.enableCursorEffect = false;
    AppTheme.cursorType = 'dot';
    
    // Layout & Components
    AppTheme.scrollEffect = 'smooth';
    AppTheme.mobileLayout = 'adaptive';
    AppTheme.heroStyle = 'centered';
    AppTheme.navbarStyle = 'sticky';
    AppTheme.footerStyle = 'expanded';
    AppTheme.formInputStyle = 'filled';
    AppTheme.loaderStyle = 'spinner';
    
    // Sounds & Alerts
    AppTheme.enableSoundEffects = false;
    AppTheme.soundPack = 'clicky';
    AppTheme.toastStyle = 'floating';
    
    // System
    AppTheme.autoDarkMode = true;
    AppTheme.enablePerformanceMode = false;
    
    notifyListeners();
  }
}