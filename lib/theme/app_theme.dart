import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ==========================================
  // 🧠 GLOBAL DESIGN SYSTEM (ULTRA CONTROL)
  // ==========================================

  // 🎨 THEMES (Visual Personality)
  // Options: 'luxury', 'cyberpunk', 'hacker', 'ocean', 'sunset', 'minimalist', 'dracula', 'light', 'dark', 'neon', 'retro', 'pastel', 'midnight', 'forest', 'galaxy', 'fire', 'ice'
  static String activeTheme = 'light'; 

  // 🌈 ACCENT COLOR CONTROL
  // Options: 'auto', 'blue', 'purple', 'green', 'red', 'gold', 'pink', 'cyan'
  static String accentColor = 'auto'; 

  // ✨ ANIMATIONS (Global Motion Style)
  // Options: 'fade', 'slide', 'zoom', 'bounce', 'rotate', 'flip', 'glitch', 'wave', 'pulse', 'elastic'
  static String globalAnimation = 'zoom'; 

  // 🧊 UI STYLE (Component Feel)
  // Options: 'glass', 'solid', 'bordered', 'flat', 'neumorphism', 'softUI', '3d', 'gradient'
  static String globalUIStyle = 'flat'; 

  // 📐 LAYOUT STYLE
  // Options: 'modern', 'classic', 'compact', 'spacious', 'grid', 'asymmetric'
  static String layoutStyle = 'modern';

  // 🔘 BUTTON STYLE
  // Options: 'rounded', 'pill', 'square', 'ghost', 'gradient', 'outline'
  static String buttonStyle = 'rounded';

  // 🔠 FONT STYLE
  // Options: 'modern', 'tech', 'classic', 'futuristic', 'handwritten', 'mono'
  static String fontStyle = 'modern';

  // 🌌 BACKGROUND STYLE
  // Options: 'plain', 'gradient', 'mesh', 'animated', 'particles', 'stars', 'waves', 'noise'
  static String backgroundStyle = 'plain';

  // 🧩 CARD STYLE
  // Options: 'flat', 'elevated', 'glass', 'outline', 'neumorphic'
  static String cardStyle = 'elevated';

  // 🌟 HOVER EFFECT
  // Options: 'none', 'lift', 'glow', 'scale', 'tilt', 'shadow'
  static String hoverEffect = 'lift';

  // 🔥 SPECIAL EFFECTS (WOW FACTOR)
  static bool enableGlow = false;
  static bool enableBlur = false;
  static bool enableShadows = true;
  static bool enableGradients = true;
  static bool enableParticles = false;
  static bool enableCursorEffect = false;

  // ⚡ SCROLL EFFECTS
  // Options: 'smooth', 'snap', 'parallax', 'reveal', 'none'
  static String scrollEffect = 'smooth';

  // 📱 RESPONSIVE BEHAVIOR
  // Options: 'adaptive', 'stacked', 'compact', 'minimal'
  static String mobileLayout = 'adaptive';

  // 🎯 HERO SECTION CONTROL
  // Options: 'centered', 'split', 'fullscreen', 'minimal', 'video'
  static String heroStyle = 'centered';
  static String heroTitle = "Simplifying Event\nExecution With Precision";
  static String heroSubtitle = "Plan smarter. Execute faster. Impress everyone.";
  static String heroCTA = "Get Started";

  // 🎬 LOADER STYLE
  // Options: 'spinner', 'dots', 'pulse', 'bars', 'custom'
  static String loaderStyle = 'spinner';

  // 🔊 SOUND EFFECTS
  static bool enableSoundEffects = false;

  // 🌙 DARK MODE AUTO SWITCH
  static bool autoDarkMode = true;

  // 🔐 ADVANCED SETTINGS
  static bool enableAIThemeSwitch = false; 
  static bool enablePerformanceMode = false; 

  // ==========================================
  // ✨ 1. GLOBAL ANIMATION ENGINE
  // ==========================================
  static Widget applyAnim(Widget child, int delayMs) {
    if (enablePerformanceMode) return child; // Optimization

    var anim = child.animate(delay: delayMs.ms).fade(duration: 600.ms);
    
    switch (globalAnimation) {
      case 'slide': return anim.slideY(begin: 0.3, end: 0, curve: Curves.easeOut);
      case 'zoom': return anim.scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
      case 'glitch': return anim.shakeX(amount: 3).then().shimmer(); 
      case 'bounce': return anim.slideY(begin: 0.5, end: 0, curve: Curves.bounceOut);
      case 'elastic': return anim.scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut, duration: 1000.ms);
      case 'flip': return anim.custom(builder: (c, v, child) => Transform(transform: Matrix4.identity()..rotateY(v), child: child));
      case 'fade': default: return anim;
    }
  }

  // ==========================================
  // 📐 2. GLOBAL UI STYLE ENGINE (Component Layout)
  // ==========================================
  static BoxDecoration getCardDecoration({bool isHovered = false}) {
    double radius = (buttonStyle == 'pill') ? 50 : ((buttonStyle == 'square') ? 0 : 20);

    // Neumorphism specific styling
    if (globalUIStyle == 'neumorphism' || cardStyle == 'neumorphic') {
        return BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), offset: const Offset(5, 5), blurRadius: 10),
            BoxShadow(color: Colors.white.withValues(alpha: 0.05), offset: const Offset(-5, -5), blurRadius: 10),
          ],
        );
    }

    switch (globalUIStyle) {
      case 'solid':
        return BoxDecoration(
          color: isHovered && hoverEffect != 'none' ? accent : cardBg.withValues(alpha: 1.0),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: isHovered && enableShadows ? [BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10))] : [],
        );
      case 'bordered':
        return BoxDecoration(
          color: isHovered ? accent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: isHovered ? accent : accent.withValues(alpha: 0.3), width: 2),
        );
      case 'flat':
        return BoxDecoration(
          color: isHovered ? accent : cardBg,
          borderRadius: BorderRadius.circular(0), 
          border: Border.all(color: isHovered ? accent : Colors.white24, width: 1),
        );
      case 'glass':
      default:
        return BoxDecoration(
          color: isHovered ? accent.withValues(alpha: 0.2) : cardBg.withValues(alpha: enableBlur ? 0.6 : 0.9),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: isHovered ? accent : Colors.white10, width: isHovered ? 2 : 1),
          boxShadow: isHovered && enableShadows ? [BoxShadow(color: accent.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10))] : [],
        );
    }
  }

  // ==========================================
  // 🔠 3. FONT ENGINE
  // ==========================================
  static TextStyle getHeadingStyle({required double fontSize, Color? color, FontWeight? weight}) {
    Color finalColor = color ?? textMain;
    switch (fontStyle) {
      case 'futuristic': return GoogleFonts.orbitron(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.bold);
      case 'classic': return GoogleFonts.playfairDisplay(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.bold);
      case 'mono': return GoogleFonts.spaceMono(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.bold);
      case 'tech': return GoogleFonts.titilliumWeb(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.bold);
      default: return GoogleFonts.poppins(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.bold);
    }
  }

  static TextStyle getBodyStyle({required double fontSize, Color? color, FontWeight? weight}) {
     Color finalColor = color ?? textSub;
     if(fontStyle == 'mono') return GoogleFonts.spaceMono(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.normal);
     return GoogleFonts.poppins(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.normal);
  }

  // ==========================================
  // 🎨 4. COLOR PALETTE ENGINE
  // ==========================================
  static Color get bg {
    switch (activeTheme) {
      case 'light': return const Color(0xFFF5F5F7);
      case 'dark': return const Color(0xFF0A0A0C);
      case 'ocean': return const Color(0xFF0F172A);
      case 'sunset': return const Color(0xFF2D130A);
      case 'hacker': return const Color(0xFF000000);
      case 'cyberpunk': return const Color(0xFF0F0728);
      case 'dracula': return const Color(0xFF282A36);
      case 'minimalist': return const Color(0xFFFAFAFA);
      case 'midnight': return const Color(0xFF020617);
      case 'forest': return const Color(0xFF061A14);
      case 'galaxy': return const Color(0xFF0B0118);
      case 'fire': return const Color(0xFF1A0500);
      case 'ice': return const Color(0xFFF0F9FF);
      case 'luxury': 
      default: return Colors.black;
    }
  }

  static Color get accent {
    if (accentColor != 'auto') {
      switch (accentColor) {
        case 'blue': return Colors.blueAccent;
        case 'purple': return Colors.purpleAccent;
        case 'green': return Colors.greenAccent;
        case 'red': return Colors.redAccent;
        case 'gold': return const Color(0xFFD6A762);
        case 'pink': return Colors.pinkAccent;
        case 'cyan': return Colors.cyanAccent;
      }
    }

    switch (activeTheme) {
      case 'light': return const Color(0xFF007AFF);
      case 'dark': return const Color(0xFF22C55E);
      case 'ocean': return const Color(0xFF0EA5E9);
      case 'sunset': return const Color(0xFFF97316);
      case 'hacker': return const Color(0xFF4ADE80);
      case 'cyberpunk': return const Color(0xFF06B6D4);
      case 'dracula': return const Color(0xFFFF79C6);
      case 'minimalist': return const Color(0xFF111111);
      case 'fire': return const Color(0xFFFF4500);
      case 'ice': return const Color(0xFF00D4FF);
      case 'neon': return const Color(0xFFF0ABFC);
      case 'luxury': 
      default: return const Color(0xFFD6A762); // Gold
    }
  }

  static Color get textMain {
    switch (activeTheme) {
      case 'light': case 'minimalist': case 'ice': return const Color(0xFF1D1D1F);
      case 'hacker': return const Color(0xFF4ADE80);
      default: return Colors.white; 
    }
  }

  static Color get textSub {
    switch (activeTheme) {
      case 'light': case 'minimalist': case 'ice': return const Color(0xFF6E6E73);
      case 'hacker': return const Color(0xFF22C55E);
      default: return Colors.white54;
    }
  }

  static Color get cardBg {
    switch (activeTheme) {
      case 'light': case 'minimalist': case 'ice': return Colors.white;
      case 'dracula': return const Color(0xFF44475A);
      case 'luxury':
      default: return const Color(0xFF111111);
    }
  }

  // ==========================================
  // 💼 5. GLOBAL SERVICES DATA (ALL 8 SERVICES)
  // ==========================================
  static List<Map<String, dynamic>> servicesData = [
    {
      'title': 'Hospitality Management',
      'description': 'Providing guest assistance, VIP handling, front desk operations, and hosting services to ensure every attendee feels welcomed.',
      'delay': 100,
      'images': [
        'https://images.unsplash.com/photo-1551818255-e6e10975bc17?q=80&w=2000',
        'https://images.unsplash.com/photo-1560179707-f14e90ef3623?q=80&w=2000',
        'https://images.unsplash.com/photo-1530103862676-de8892bc952f?q=80&w=2000',
      ]
    },
    {
      'title': 'Logistics Management',
      'description': 'Managing material movement, backstage coordination, and vendor communication to maintain an organized environment.',
      'delay': 200,
      'images': [
        'https://images.unsplash.com/photo-1586528116311-ad8ed7c1590a?q=80&w=2000',
        'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?q=80&w=2000',
      ]
    },
    {
      'title': 'Shadow Management',
      'description': 'Dedicated personnel providing personalized support for artists, speakers, VIPs, and special guests ensuring their comfort.',
      'delay': 300,
      'images': [
        'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2000',
        'https://images.unsplash.com/photo-1511765224389-37f0e77cf0eb?q=80&w=2000',
      ]
    },
    {
      'title': 'F&B Management',
      'description': 'Efficient supervision of food and beverage operations, including service monitoring, counter assistance, and staff coordination.',
      'delay': 400,
      'images': [
        'https://images.unsplash.com/photo-1555244162-803834f70033?q=80&w=2000',
        'https://images.unsplash.com/photo-1414235077428-3389886e5643?q=80&w=2000',
        'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?q=80&w=2000',
      ]
    },
    {
      'title': 'Production Management',
      'description': 'Professional on-ground support for stage setup, lighting and sound coordination, and backstage operations.',
      'delay': 500,
      'images': [
        'https://images.unsplash.com/photo-1478146896981-b80fe463b330?q=80&w=2000',
        'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=2000',
      ]
    },
    {
      'title': 'Outsourcing Management',
      'description': 'Efficient management of outsourced vendors and temporary staff, ensuring seamless coordination and clear communication.',
      'delay': 600,
      'images': [
        'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2000',
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?q=80&w=2000',
      ]
    },
    {
      'title': 'Bell Boy Management',
      'description': 'Professional support for hotel and hospitality services including guest assistance, luggage handling, and coordination.',
      'delay': 700,
      'images': [
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=2000',
        'https://images.unsplash.com/photo-1564501049412-61c2a3083791?q=80&w=2000',
      ]
    },
    {
      'title': 'Coordinator Management',
      'description': 'Experienced coordinators responsible for supervising teams, assigning tasks, and monitoring event flow.',
      'delay': 800,
      'images': [
        'https://images.unsplash.com/photo-1515187029135-18ee286d815b?q=80&w=2000',
        'https://images.unsplash.com/photo-1528605248644-14dd04022da1?q=80&w=2000',
      ]
    }, 
  ];
}