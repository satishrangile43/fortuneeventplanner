import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // ==========================================
  // 🚀 THE ULTIMATE REAL ENGINE (GOD TIER CONTROL)
  // ==========================================
  bool isSelectionMode = false; 
  Map<String, dynamic> elementSettings = {};
  bool isGodModeUnlocked = false; 

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

  void unlockGodMode() {
    isGodModeUnlocked = true;
    notifyListeners();
  }

  // ==========================================
  // 🎨 1. THEMES, COLORS & FILTERS
  // ==========================================
  void changeTheme(String newTheme) {
    AppTheme.activeTheme = newTheme;
    AppTheme.autoDarkMode = false; 
    notifyListeners();
  }

  void updateAccentColor(String newAccent) {
    AppTheme.accentColor = newAccent;
    notifyListeners();
  }
  
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

  void updateTransitionSpeed(String speed) {
    AppTheme.transitionSpeed = speed;
    notifyListeners();
  }

  // ==========================================
  // 🧊 3. UI, LAYOUT & SHAPES
  // ==========================================
  void updateUIStyle(String newStyle) {
    AppTheme.globalUIStyle = newStyle;
    if (newStyle == 'glass' && !AppTheme.enablePerformanceMode) AppTheme.enableBlur = true;
    if (newStyle == 'neumorphic') AppTheme.enableShadows = true;
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
    if (newBackground == 'mesh' || newBackground == 'gradient') AppTheme.enableGradients = true;
    notifyListeners();
  }

  // ==========================================
  // 🌟 5. EFFECTS, HOVER & 3D PARALLAX
  // ==========================================
  void updateHoverEffect(String newHover) {
    AppTheme.hoverEffect = newHover;
    notifyListeners();
  }

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

  void updateNavbarStyle(String style) {
    AppTheme.navbarStyle = style;
    notifyListeners();
  }

  void updateFooterStyle(String style) {
    AppTheme.footerStyle = style;
    notifyListeners();
  }

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

  void updateSoundPack(String pack) {
    AppTheme.soundPack = pack;
    notifyListeners();
  }

  void toggleSoundEffects(bool value) {
    AppTheme.enableSoundEffects = value;
    notifyListeners();
  }

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
    if (value) {
      AppTheme.enableBlur = false;
      AppTheme.enableParticles = false;
      AppTheme.enableGlow = false;
      AppTheme.parallaxIntensity = 'none';
      AppTheme.scrollEffect = 'smooth';
      AppTheme.transitionSpeed = 'fast'; 
    }
    notifyListeners();
  }

  // ==========================================
  // 🛠️ 10. MASTER RESET
  // ==========================================
  void resetToDefault() {
    isSelectionMode = false;
    elementSettings.clear(); 
    
    AppTheme.activeTheme = 'dark'; 
    AppTheme.accentColor = 'auto';
    AppTheme.imageFilter = 'none';
    AppTheme.globalAnimation = 'fade'; 
    AppTheme.transitionSpeed = 'normal';
    AppTheme.globalUIStyle = 'glass'; 
    AppTheme.layoutStyle = 'modern';
    AppTheme.buttonStyle = 'pill'; 
    AppTheme.cardStyle = 'elevated';
    AppTheme.borderStyle = 'squircle'; 
    AppTheme.fontStyle = 'modern';
    AppTheme.backgroundStyle = 'gradient'; 
    AppTheme.hoverEffect = 'parallax'; 
    AppTheme.parallaxIntensity = 'medium';
    AppTheme.enableGlow = true; 
    AppTheme.enableBlur = true; 
    AppTheme.enableShadows = true;
    AppTheme.enableGradients = true;
    AppTheme.enableParticles = false; 
    AppTheme.enableCursorEffect = true;
    AppTheme.cursorType = 'ring'; 
    AppTheme.scrollEffect = 'bouncy'; 
    AppTheme.mobileLayout = 'adaptive';
    AppTheme.heroStyle = 'centered';
    AppTheme.navbarStyle = 'floating'; 
    AppTheme.footerStyle = 'expanded';
    AppTheme.formInputStyle = 'filled';
    AppTheme.loaderStyle = 'spinner';
    AppTheme.enableSoundEffects = true; 
    AppTheme.soundPack = 'clicky';
    AppTheme.toastStyle = 'glass'; 
    AppTheme.autoDarkMode = true;
    AppTheme.enablePerformanceMode = false;
    
    notifyListeners();
  }

  // ==========================================
  // 🚀 11. THE TRUE CLOUD HYDRATION SYSTEM (FIX 1)
  // ==========================================
  void loadFromCloud(Map<String, dynamic> data) {
    // 1. Core Config (Theme logic)
    if (data.containsKey('app_config')) {
      Map<String, dynamic> config = data['app_config'];
      AppTheme.activeTheme = config['theme'] ?? 'dark';
      AppTheme.accentColor = config['accent'] ?? 'auto';
      AppTheme.imageFilter = config['filter'] ?? 'none';
      AppTheme.globalUIStyle = config['ui_style'] ?? 'glass';
      AppTheme.buttonStyle = config['btn_style'] ?? 'pill';
      AppTheme.cardStyle = config['card_style'] ?? 'elevated';
      AppTheme.borderStyle = config['border_style'] ?? 'squircle';
      AppTheme.heroStyle = config['hero_style'] ?? 'centered';
      AppTheme.globalAnimation = config['animation'] ?? 'fade';
      AppTheme.transitionSpeed = config['speed'] ?? 'normal';
      AppTheme.fontStyle = config['font'] ?? 'modern';
      AppTheme.navbarStyle = config['nav_style'] ?? 'floating';
      AppTheme.footerStyle = config['footer_style'] ?? 'expanded';
      AppTheme.formInputStyle = config['form_style'] ?? 'filled';
      AppTheme.parallaxIntensity = config['parallax'] ?? 'none';
      
      AppTheme.enableBlur = config['blur'] ?? true;
      AppTheme.enableShadows = config['shadows'] ?? true;
      AppTheme.enableGlow = config['glow'] ?? true;
      AppTheme.enableCursorEffect = config['cursor_fx'] ?? true;
    }

    // 2. Element Texts & Colors (The actual Map for individual widgets)
    if (data.containsKey('element_settings')) {
      elementSettings = Map<String, dynamic>.from(data['element_settings']);
    }

    notifyListeners(); // 🔥 COMPLETE UI OVERHAUL
  }

  // 🚀 HELPER TO PACK ALL DATA FOR GITHUB
  Map<String, dynamic> exportToCloud() {
    return {
      'app_config': {
        'theme': AppTheme.activeTheme,
        'accent': AppTheme.accentColor,
        'filter': AppTheme.imageFilter,
        'ui_style': AppTheme.globalUIStyle,
        'btn_style': AppTheme.buttonStyle,
        'card_style': AppTheme.cardStyle,
        'border_style': AppTheme.borderStyle,
        'hero_style': AppTheme.heroStyle,
        'animation': AppTheme.globalAnimation,
        'speed': AppTheme.transitionSpeed,
        'font': AppTheme.fontStyle,
        'nav_style': AppTheme.navbarStyle,
        'footer_style': AppTheme.footerStyle,
        'form_style': AppTheme.formInputStyle,
        'parallax': AppTheme.parallaxIntensity,
        'blur': AppTheme.enableBlur,
        'shadows': AppTheme.enableShadows,
        'glow': AppTheme.enableGlow,
        'cursor_fx': AppTheme.enableCursorEffect,
      },
      'element_settings': elementSettings,
    };
  }
}