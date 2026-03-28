import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // ==========================================
  // 🚀 THE NEW REAL ENGINE (GRANULAR CONTROL)
  // ==========================================
  
  // 🔓 God Mode Active Switch (Jab ye true hoga, tabhi screen pe click karke edit hoga)
  bool isSelectionMode = false; 

  // 🎯 Map to store individual object customizations (Ye global theme ko override karega)
  // Example: {'home_hero_title_color': Color(0xFFFF0000), 'service_card_glow': true}
  Map<String, dynamic> elementSettings = {};

  void toggleSelectionMode() {
    isSelectionMode = !isSelectionMode;
    notifyListeners();
  }

  // Kisi bhi specific object ka data update karne ke liye
  void updateElement(String key, dynamic value) {
    elementSettings[key] = value;
    notifyListeners();
  }

  // Agar custom setting hatani ho aur wapas default theme par aana ho
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
  // 🎨 THEMES & COLORS (GLOBAL)
  // ==========================================
  void changeTheme(String newTheme) {
    AppTheme.activeTheme = newTheme;
    notifyListeners();
  }

  void updateAccentColor(String newAccent) {
    AppTheme.accentColor = newAccent;
    notifyListeners();
  }

  // ==========================================
  // ✨ ANIMATIONS
  // ==========================================
  void updateAnimation(String newAnim) {
    AppTheme.globalAnimation = newAnim;
    notifyListeners();
  }

  // ==========================================
  // 🧊 UI & LAYOUT STYLES
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

  // ==========================================
  // 🔠 FONTS & BACKGROUND
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
  // 🌟 EFFECTS & TOGGLES (Boolean Switches)
  // ==========================================
  void updateHoverEffect(String newHover) {
    AppTheme.hoverEffect = newHover;
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

  void toggleCursorEffect(bool value) {
    AppTheme.enableCursorEffect = value;
    notifyListeners();
  }

  // ==========================================
  // ⚡ SCROLL & RESPONSIVE
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
  // 🎯 HERO SECTION
  // ==========================================
  void updateHeroStyle(String newStyle) {
    AppTheme.heroStyle = newStyle;
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
  // 🎬 LOADER & SOUND
  // ==========================================
  void updateLoaderStyle(String newLoader) {
    AppTheme.loaderStyle = newLoader;
    notifyListeners();
  }

  void toggleSoundEffects(bool value) {
    AppTheme.enableSoundEffects = value;
    notifyListeners();
  }

  // ==========================================
  // 🌙 ADVANCED & DARK MODE
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
  // 🛠️ MASTER RESET (Upgraded for Real Engine)
  // ==========================================
  void resetToDefault() {
    isSelectionMode = false;
    elementSettings.clear(); // 🧹 Clear all individual custom edits
    
    AppTheme.activeTheme = 'light';
    AppTheme.accentColor = 'auto';
    AppTheme.globalAnimation = 'zoom';
    AppTheme.globalUIStyle = 'flat';
    AppTheme.layoutStyle = 'modern';
    AppTheme.buttonStyle = 'rounded';
    AppTheme.fontStyle = 'modern';
    AppTheme.backgroundStyle = 'plain';
    AppTheme.cardStyle = 'elevated';
    AppTheme.hoverEffect = 'lift';
    
    AppTheme.enableGlow = false;
    AppTheme.enableBlur = false;
    AppTheme.enableShadows = true;
    AppTheme.enableGradients = true;
    AppTheme.enableParticles = false;
    AppTheme.enableCursorEffect = false;
    
    AppTheme.scrollEffect = 'smooth';
    AppTheme.mobileLayout = 'adaptive';
    AppTheme.heroStyle = 'centered';
    AppTheme.loaderStyle = 'spinner';
    
    AppTheme.enableSoundEffects = false;
    AppTheme.autoDarkMode = true;
    AppTheme.enablePerformanceMode = false;
    
    notifyListeners();
  }
}