import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class AppTheme {
  // ==========================================
  // 🧠 GLOBAL DESIGN SYSTEM (ULTRA GOD CONTROL)
  // 👇 YAHAN SE TUM APP KA DEFAULT LOOK SET KAR SAKTE HO 👇
  // ==========================================
  
  // 🎨 1. THEMES & COLORS (Default theme kya rakhni hai yahan likho)
  // Options: 'light', 'dark', 'ocean', 'sunset', 'hacker', 'cyberpunk', 'dracula', 'minimalist', 'midnight', 'forest', 'galaxy', 'fire', 'ice', 'luxury'
  static String activeTheme = 'minimalist'; 
  
  // Options: 'auto', 'blue', 'purple', 'green', 'red', 'gold', 'pink', 'cyan'
  static String accentColor = 'cyan'; 
  
  // Options: 'none', 'grayscale', 'sepia', 'high-contrast'
  static String imageFilter = 'none'; 

  // ✨ 2. ANIMATIONS (App me kis tarah ke effects aayenge)
  // Options: 'fade', 'slide', 'zoom', 'glitch', 'bounce', 'elastic', 'flip'
  static String globalAnimation = 'fade'; 
  
  // Options: 'slow' (800ms), 'normal' (450ms), 'fast' (200ms)
  static String transitionSpeed = 'normal'; 

  // 🧊 3. UI STYLE & SHAPES (Card aur button kaise dikhenge)
  // Options: 'glass', 'solid', 'bordered', 'flat', 'neumorphism'
  static String globalUIStyle = 'glass'; 
  static String layoutStyle = 'modern';
  
  // Options: 'pill' (gol), 'rounded' (halke gol), 'square' (chakor)
  static String buttonStyle = 'pill';
  static String cardStyle = 'elevated';
  
  // Options: 'sharp', 'rounded', 'squircle' (Apple jaisa smooth)
  static String borderStyle = 'squircle'; 

  // 🔠 4. FONTS & BACKGROUND
  // Options: 'modern', 'tech', 'classic', 'futuristic', 'mono'
  static String fontStyle = 'modern';
  
  // Options: 'gradient', 'mesh', 'solid'
  static String backgroundStyle = 'gradient';

  // 🌟 5. EFFECTS & 3D (ON/OFF karne wale features - true/false likho)
  // Options for hover: 'lift', 'scale', 'tilt', 'glow', 'none'
  static String hoverEffect = 'scale';
  
  // Options for parallax: 'off', 'low', 'high'
  static String parallaxIntensity = 'low'; 
  
  static bool enableGlow = true;       // True matab chamak aayegi
  static bool enableBlur = true;       // Glass effect ke liye true zaroori hai
  static bool enableShadows = true;    // Cards ke piche shadow
  static bool enableGradients = true;
  static bool enableParticles = false; // Background me udte hue particles
  
  // 🖱️ 6. CURSOR (Web/Desktop ke liye)
  // Options: 'Dot', 'Ring', 'None'
  static String cursorType = 'Dot'; 
  static bool enableCursorEffect = true;

  // ⚡ 7. SCROLL & RESPONSIVE
  static String scrollEffect = 'bouncy';
  static String mobileLayout = 'adaptive';

  // 🎯 8. HEADER, FOOTER & FORMS 
  static String heroStyle = 'centered';
  
  // Options: 'sticky', 'floating', 'hidden'
  static String navbarStyle = 'floating'; 
  static String footerStyle = 'expanded'; 
  
  // Options: 'filled', 'outlined', 'underlined'
  static String formInputStyle = 'filled'; 
  
  // 👇 MAIN WEBSITE TEXTS - Yahan se website ka main text direct change karo 👇
  static String heroTitle = "Simplifying Event\nExecution With Precision";
  static String heroSubtitle = "Plan smarter. Execute faster. Impress everyone.";
  static String heroCTA = "Get Started";

  // 🎬 9. LOADER, SOUND & ALERTS 
  static String loaderStyle = 'spinner';
  
  // Options: 'clicky', 'heavy', 'light'
  static String soundPack = 'clicky'; 
  static bool enableSoundEffects = true;
  
  // Options: 'floating', 'glass', 'banner'
  static String toastStyle = 'glass'; 

  // 🌙 10. ADVANCED SETTINGS
  static bool autoDarkMode = true;
  static bool enableAIThemeSwitch = false; 
  static bool enablePerformanceMode = false; // Slow phone/PC me true kar do, animations band ho jayengi

  // ==========================================
  // 🧠 SMART HELPER: Theme Detectors
  // ==========================================
  static bool get isDarkTheme => 
      activeTheme != 'light' && activeTheme != 'minimalist' && activeTheme != 'ice';

  // ==========================================
  // ⏳ 1. GLOBAL TRANSITION SPEED LOGIC
  // Edit yahan tab karna jab tumhe custom milliseconds daalne ho
  // ==========================================
  static int get durationMs {
    if (enablePerformanceMode) return 0; // Instant for slow devices
    switch (transitionSpeed) {
      case 'fast': return 200; // Snappy
      case 'slow': return 800; // Cinematic
      case 'normal': default: return 450; // Perfect balance
    }
  }

  // ==========================================
  // ✨ 2. GLOBAL ANIMATION ENGINE (BUTTER SMOOTH CURVES)
  // Yahan naye effects bana sakte ho ya speed/curve modify kar sakte ho
  // ==========================================
  static Widget applyAnim(Widget child, int delayMs) {
    if (enablePerformanceMode) return child; 

    // 🚀 ENGINE SYNC: EaseOutCubic gives that premium Apple-like deceleration
    var anim = child.animate(delay: delayMs.ms).fade(duration: durationMs.ms, curve: Curves.easeOutCubic);
    
    switch (globalAnimation) {
      case 'slide': return anim.slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic); 
      case 'zoom': return anim.scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack); 
      case 'glitch': return anim.shakeX(amount: 2).then().shimmer(duration: 800.ms); 
      case 'bounce': return anim.slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack);
      case 'elastic': return anim.scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut, duration: (durationMs * 1.5).ms);
      case 'flip': return anim.custom(builder: (c, v, child) => Transform(transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(v * math.pi / 2), alignment: Alignment.center, child: child));
      case 'fade': default: return anim;
    }
  }

  // ==========================================
  // 🖼️ 3. IMAGE FILTERS ENGINE
  // ==========================================
  static Widget applyImageFilter(Widget child) {
    if (imageFilter == 'none' || enablePerformanceMode) return child;

    ColorFilter filter;
    switch (imageFilter) {
      case 'grayscale':
        filter = const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]);
        break;
      case 'sepia':
        filter = const ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0, 0, 0, 1, 0,
        ]);
        break;
      case 'high-contrast':
        filter = const ColorFilter.matrix([
          1.5, 0, 0, 0, -20.0,
          0, 1.5, 0, 0, -20.0,
          0, 0, 1.5, 0, -20.0,
          0, 0, 0, 1, 0,
        ]);
        break;
      default:
        return child;
    }
    return ColorFiltered(colorFilter: filter, child: child);
  }

  // ==========================================
  // 📏 4. GLOBAL RADIUS & BORDER ENGINE
  // Yahan radius ki value manually adjust kar sakte ho
  // ==========================================
  static double getGlobalRadius() {
    switch (borderStyle) {
      case 'sharp': return 0.0;
      case 'squircle': return 24.0; // Isko 30.0 karoge toh zyada gol hoga
      case 'rounded': default: return 12.0; // Normal thoda sa gol
    }
  }

  // ==========================================
  // 📐 5. GLOBAL UI STYLE & CARD ENGINE (ADAPTIVE)
  // Cards ka design, shadow aur border yahan se handle hota hai
  // ==========================================
  static BoxDecoration getCardDecoration({bool isHovered = false}) {
    double radius = getGlobalRadius(); 
    
    if (buttonStyle == 'pill') radius = 50;
    if (buttonStyle == 'square') radius = 0;

    // 🟢 FIX: Adaptive borders
    Color adaptiveBorderColor = isDarkTheme ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05);

    // 🔥 PREMIUM SHADOWS & GLOW
    List<BoxShadow> currentShadows = [];
    if (isHovered && enableGlow) {
      currentShadows.add(BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 0)); // Sleek glow
    } else if (enableShadows) {
      currentShadows.add(BoxShadow(
        color: Colors.black.withValues(alpha: isDarkTheme ? 0.4 : 0.08), 
        blurRadius: isHovered ? 25 : 15, 
        offset: Offset(0, isHovered ? 12 : 6),
        spreadRadius: isHovered ? -2 : -4, // Negative spread = premium floating effect
      ));
    }

    if (globalUIStyle == 'neumorphism' || cardStyle == 'neumorphic') {
        return BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(color: isDarkTheme ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.1), offset: const Offset(6, 6), blurRadius: 12),
            BoxShadow(color: isDarkTheme ? Colors.white.withValues(alpha: 0.05) : Colors.white, offset: const Offset(-6, -6), blurRadius: 12),
            ...currentShadows,
          ],
        );
    }

    switch (globalUIStyle) {
      case 'solid':
        return BoxDecoration(
          color: isHovered && hoverEffect != 'none' ? cardBg.withValues(alpha: 0.9) : cardBg,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: currentShadows,
        );
      case 'bordered':
        return BoxDecoration(
          color: isHovered ? accent.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: isHovered ? accent : adaptiveBorderColor, width: 1.5),
          boxShadow: currentShadows,
        );
      case 'flat':
        return BoxDecoration(
          color: isHovered ? accent.withValues(alpha: 0.1) : cardBg,
          borderRadius: BorderRadius.circular(0), 
          border: Border.all(color: adaptiveBorderColor, width: 1),
        );
      case 'glass':
      default:
        return BoxDecoration(
          color: isHovered ? accent.withValues(alpha: 0.15) : cardBg.withValues(alpha: enableBlur ? (isDarkTheme ? 0.4 : 0.7) : 0.9),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: isHovered ? accent.withValues(alpha: 0.5) : adaptiveBorderColor, width: 1.5),
          boxShadow: currentShadows,
        );
    }
  }

  // ==========================================
  // 🌟 6. HOVER TRANSFORM ENGINE (PHYSICS UPGRADED)
  // Values change karke tum tilt ya zoom ka effect kam-zyada kar sakte ho
  // ==========================================
  static Matrix4 getHoverTransform(bool isHovered) {
    if (!isHovered || hoverEffect == 'none' || enablePerformanceMode) return Matrix4.identity();
    
    switch (hoverEffect) {
      case 'lift': 
        return Matrix4.translationValues(0, -6, 0); // Upar uthne ki height (-6 ko -10 karoge toh zyada uthega)
      case 'scale': 
        return Matrix4.diagonal3Values(1.03, 1.03, 1.0); // 1.03 ko 1.10 karoge toh zyada zoom hoga
      case 'tilt': 
        return Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(-0.02)
          ..rotateY(0.02)
          ..multiply(Matrix4.diagonal3Values(1.02, 1.02, 1.0));
      case 'glow': 
        return Matrix4.identity(); 
      default: 
        return Matrix4.identity();
    }
  }

  // ==========================================
  // 📝 7. FORM INPUT ENGINE (PREMIUM FOCUS)
  // Forms ke textbox yahan se design hote hain
  // ==========================================
  static InputDecoration getFormInputDecoration(String hint) {
    double radius = getGlobalRadius();
    Color adaptiveBorder = isDarkTheme ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1);
    
    switch (formInputStyle) {
      case 'outlined':
        return InputDecoration(
          hintText: hint,
          hintStyle: getBodyStyle(fontSize: 14, color: textSub.withValues(alpha: 0.6)),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: adaptiveBorder)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: accent, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.redAccent.shade400, width: 1)),
        );
      case 'underlined':
        return InputDecoration(
          hintText: hint,
          hintStyle: getBodyStyle(fontSize: 14, color: textSub.withValues(alpha: 0.6)),
          filled: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: adaptiveBorder)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accent, width: 2)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.shade400, width: 1)),
        );
      case 'filled':
      default:
        return InputDecoration(
          hintText: hint,
          hintStyle: getBodyStyle(fontSize: 14, color: textSub.withValues(alpha: 0.6)),
          filled: true,
          fillColor: isDarkTheme ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03), 
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: adaptiveBorder, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: accent, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: Colors.redAccent.shade400, width: 1)),
        );
    }
  }

  // ==========================================
  // 🌌 8. BACKGROUND ENGINE
  // ==========================================
  static BoxDecoration getBackgroundDecoration() {
    if (enablePerformanceMode || !enableGradients) return BoxDecoration(color: bg);

    if (backgroundStyle == 'gradient') {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg, cardBg.withValues(alpha: 0.5), bg.withValues(alpha: 0.8)], 
        ),
      );
    } else if (backgroundStyle == 'mesh') {
      return BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 2.0,
          colors: [cardBg, bg],
        ),
      );
    }
    return BoxDecoration(color: bg); 
  }

  // ==========================================
  // 🔠 9. FONT ENGINE
  // Heading aur Normal text ke fonts yahan set kiye hain
  // Agar Custom fonts chahiye toh pubspec me add karke yahan naam daal do
  // ==========================================
  static TextStyle getHeadingStyle({required double fontSize, Color? color, FontWeight? weight}) {
    Color finalColor = color ?? textMain;
    switch (fontStyle) {
      case 'futuristic': return GoogleFonts.orbitron(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.w800);
      case 'classic': return GoogleFonts.playfairDisplay(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.w700);
      case 'mono': return GoogleFonts.spaceMono(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.w700);
      case 'tech': return GoogleFonts.titilliumWeb(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.w700);
      default: return GoogleFonts.inter(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.w800); 
    }
  }

  static TextStyle getBodyStyle({required double fontSize, Color? color, FontWeight? weight}) {
     Color finalColor = color ?? textSub;
     if(fontStyle == 'mono') return GoogleFonts.spaceMono(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.normal);
     return GoogleFonts.inter(fontSize: fontSize, color: finalColor, fontWeight: weight ?? FontWeight.w500);
  }

  // ==========================================
  // 🎨 10. COLOR PALETTE ENGINE (HARMONIZED)
  // Tum apne specific hex codes "0xFF[HEXCODE]" ke format me daal sakte ho
  // ==========================================
  static Color get bg {
    switch (activeTheme) {
      case 'light': return const Color(0xFFF9FAFB); 
      case 'dark': return const Color(0xFF09090B); 
      case 'ocean': return const Color(0xFF020617);
      case 'sunset': return const Color(0xFF1E0E08);
      case 'hacker': return const Color(0xFF000000);
      case 'cyberpunk': return const Color(0xFF0D031D);
      case 'dracula': return const Color(0xFF282A36);
      case 'minimalist': return const Color(0xFFFFFFFF);
      case 'midnight': return const Color(0xFF000000);
      case 'forest': return const Color(0xFF02120A);
      case 'galaxy': return const Color(0xFF04010A);
      case 'fire': return const Color(0xFF140200);
      case 'ice': return const Color(0xFFF0F9FF);
      case 'luxury': default: return const Color(0xFF0A0A0A);
    }
  }

  static Color get cardBg {
    switch (activeTheme) {
      case 'light': return const Color(0xFFFFFFFF);
      case 'dark': return const Color(0xFF18181B); 
      case 'ocean': return const Color(0xFF0F172A);
      case 'sunset': return const Color(0xFF2E150C);
      case 'hacker': return const Color(0xFF051008);
      case 'cyberpunk': return const Color(0xFF1B0B3B);
      case 'dracula': return const Color(0xFF44475A);
      case 'minimalist': return const Color(0xFFF4F4F5);
      case 'midnight': return const Color(0xFF0F0F11);
      case 'forest': return const Color(0xFF062416);
      case 'galaxy': return const Color(0xFF0E0324);
      case 'fire': return const Color(0xFF2B0700);
      case 'ice': return const Color(0xFFFFFFFF);
      case 'luxury': default: return const Color(0xFF141414);
    }
  }

  static Color get accent {
    if (accentColor != 'auto') {
      switch (accentColor) {
        case 'blue': return const Color(0xFF3B82F6);
        case 'purple': return const Color(0xFFA855F7);
        case 'green': return const Color(0xFF22C55E);
        case 'red': return const Color(0xFFEF4444);
        case 'gold': return const Color(0xFFEAB308);
        case 'pink': return const Color(0xFFEC4899);
        case 'cyan': return const Color(0xFF06B6D4);
      }
    }

    switch (activeTheme) {
      case 'light': return const Color(0xFF2563EB);
      case 'dark': return const Color(0xFF3B82F6); 
      case 'ocean': return const Color(0xFF0EA5E9);
      case 'sunset': return const Color(0xFFF97316);
      case 'hacker': return const Color(0xFF22C55E);
      case 'cyberpunk': return const Color(0xFFD946EF); 
      case 'dracula': return const Color(0xFFFF79C6);
      case 'minimalist': return const Color(0xFF18181B);
      case 'fire': return const Color(0xFFFF4500);
      case 'ice': return const Color(0xFF00B4D8);
      case 'luxury': default: return const Color(0xFFD4AF37); 
    }
  }

  static Color get textMain {
    if (isDarkTheme) {
      if (activeTheme == 'hacker') return const Color(0xFF4ADE80);
      return const Color(0xFFFAFAFA); 
    } else {
      return const Color(0xFF09090B); 
    }
  }

  static Color get textSub {
    if (isDarkTheme) {
      if (activeTheme == 'hacker') return const Color(0xFF22C55E);
      return const Color(0xFFA1A1AA); 
    } else {
      return const Color(0xFF71717A); 
    }
  }

  // ==========================================
  // 💼 11. GLOBAL SERVICES DATA
  // Tum apne naye services yahan JSON format me add kar sakte ho!
  // Images ki links direct change kar lena apne hisaab se.
  // ==========================================
  static List<Map<String, dynamic>> servicesData = [
    {
      'title': 'Hospitality Management',
      'description': 'Providing guest assistance, VIP handling, front desk operations, and hosting services to ensure every attendee feels welcomed.',
      'delay': 100, // Card kab aayega uska time (milliseconds)
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/hospi.jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/hospi1.jpg',
      ]
    },
    {
      'title': 'Logistics Management',
      'description': 'Managing material movement, backstage coordination, and vendor communication to maintain an organized environment.',
      'delay': 200,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/logistic.jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/logistic1.jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/logistic2.jpg',
      ]
    },
    {
      'title': 'Shadow Management',
      'description': 'Dedicated personnel providing personalized support for artists, speakers, VIPs, and special guests ensuring their comfort.',
      'delay': 300,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/shardow%20(1).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/shardow%20(2).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/shardow%20(3).jpg',
      ]
    },
    {
      'title': 'F&B Management',
      'description': 'Efficient supervision of food and beverage operations, including service monitoring, counter assistance, and staff coordination.',
      'delay': 400,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/f%26b%20(1).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/f%26b%20(2).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/f%26b%20(3).jpg',
      ]
    },
    {
      'title': 'Production Management',
      'description': 'Professional on-ground support for stage setup, lighting and sound coordination, and backstage operations.',
      'delay': 500,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/production%20(1).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/production%20(2).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/production%20(3).jpg',
      ]
    },
    {
      'title': 'Outsourcing Management',
      'description': 'Efficient management of outsourced vendors and temporary staff, ensuring seamless coordination and clear communication.',
      'delay': 600,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/outsourching%20(1).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/outsourching%20(2).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/outsourching%20(3).jpg',
      ]
    },
    {
      'title': 'Bell Boy Management',
      'description': 'Professional support for hotel and hospitality services including guest assistance, luggage handling, and coordination.',
      'delay': 700,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/bellboys%20(1).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/bellboys%20(2).jpg',
      ]
    },
    {
      'title': 'Coordinator Management',
      'description': 'Experienced coordinators responsible for supervising teams, assigning tasks, and monitoring event flow.',
      'delay': 800,
      'images': [
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/coordinator%20(1).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/coordinator%20(2).jpg',
        'https://cdn.jsdelivr.net/gh/satishrangile43/gurudairy@main/PAPA/coordinator%20(3).jpg',
      ]
    }, 
  ];
}