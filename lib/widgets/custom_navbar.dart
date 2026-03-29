import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../theme/app_theme.dart'; // 🚀 GLOBAL THEME ENGINE IMPORTED

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  // ==========================================
  // 🔊 SOUND ENGINE SYNC
  // ==========================================
  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else if (AppTheme.soundPack == 'clicky') {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🧠 SMART LOGIC: Agar admin panel se hidden set hai toh kuch mat dikhao
    if (AppTheme.navbarStyle == 'hidden') {
      return const SizedBox.shrink(); 
    }

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // 📱 RESPONSIVE DETECTION
        bool isMobile = sizingInformation.isMobile || MediaQuery.of(context).size.width < 800;
        
        // 📐 LAYOUT CALCULATION
        bool isFloating = AppTheme.navbarStyle == 'floating';
        double marginValue = isFloating ? (isMobile ? 15.0 : 30.0) : 0.0;
        double radiusValue = AppTheme.borderStyle == 'sharp' ? 0.0 : (isFloating ? AppTheme.getGlobalRadius() : 0.0);

        return Container(
          margin: EdgeInsets.only(top: marginValue, left: marginValue, right: marginValue),
          child: ClipRRect( 
            borderRadius: BorderRadius.circular(radiusValue),
            child: BackdropFilter(
              // 🌫️ BLUR ENGINE
              filter: ImageFilter.blur(
                sigmaX: AppTheme.enableBlur ? 20 : 0.001, 
                sigmaY: AppTheme.enableBlur ? 20 : 0.001
              ),
              child: Container(
                // 🛠️ FIX: Perfect padding arrangement for both Desktop and Mobile
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : (isFloating ? 40 : 60), 
                    vertical: isMobile ? 15 : 20
                ),
                decoration: BoxDecoration(
                  color: (AppTheme.globalUIStyle == 'solid' || !AppTheme.enableBlur)
                      ? AppTheme.bg 
                      : AppTheme.bg.withValues(alpha: 0.85), 
                  
                  // 🎨 BORDER LOGIC: Floating pe pura border, sticky pe sirf niche
                  border: isFloating 
                    ? Border.all(color: AppTheme.accent.withValues(alpha: 0.2), width: 1.5)
                    : Border(
                        bottom: BorderSide(
                          color: AppTheme.accent.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                  borderRadius: BorderRadius.circular(radiusValue),
                  
                  // 🌟 SHADOW ENGINE
                  boxShadow: AppTheme.enableShadows ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isFloating ? 0.3 : 0.15), 
                      blurRadius: isFloating ? 20 : 10, 
                      offset: Offset(0, isFloating ? 10 : 5)
                    )
                  ] : [],
                ),
                
                // ==========================================
                // 🧩 MAIN NAVBAR CONTENT (LOGO + LINKS)
                // ==========================================
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center, // 🛠️ FIX: Center align everything perfectly
                  children: [
                    
                    // ------------------------------------------
                    // 1. BRAND LOGO SECTION
                    // ------------------------------------------
                    InkWell(
                      mouseCursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                      onTap: () {
                        _triggerSound();
                        context.go('/');
                      },
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // 🛠️ FIX: Shrink to fit content
                        children: [
                          Text(
                            'FORTUNE',
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 20 : 28,
                              color: AppTheme.textMain,
                              weight: FontWeight.bold,
                            ).copyWith(
                              letterSpacing: 2.0,
                              shadows: [Shadow(color: AppTheme.textMain.withValues(alpha: 0.2), offset: const Offset(0, 2), blurRadius: 4)]
                            ),
                          ),
                          Text(
                            'EVENT PLANNER',
                            style: AppTheme.getBodyStyle(
                              fontSize: isMobile ? 8 : 10,
                              color: AppTheme.accent,
                              weight: FontWeight.bold,
                            ).copyWith(letterSpacing: 4.0),
                          ),
                        ],
                      ),
                    ),

                    if (isMobile) const SizedBox(width: 15), // Safe spacing for mobile

                    // ------------------------------------------
                    // 2. NAVIGATION LINKS SECTION
                    // ------------------------------------------
                    if (!isMobile)
                      // 🖥️ DESKTOP VIEW
                      Row(
                        mainAxisSize: MainAxisSize.min, // 🛠️ FIX: Use minimum space needed
                        children: _getNavItems(context, isMobile: false),
                      )
                    else
                      // 📱 MOBILE VIEW (Horizontal Scrollable)
                      Expanded( // 🛠️ FIX: Expanded forces the scroll view to take only remaining space, preventing overflow!
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start, // 🛠️ FIX: Start alignment ensures smooth swipe
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _getNavItems(context, isMobile: true),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 📋 LIST OF NAVIGATION ITEMS
  List<Widget> _getNavItems(BuildContext context, {required bool isMobile}) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return [
      _NavBarItem(title: 'Home', path: '/', currentRoute: currentRoute, isMobile: isMobile),
      _NavBarItem(title: 'Services', path: '/services', currentRoute: currentRoute, isMobile: isMobile),
      _NavBarItem(title: 'Security', path: '/security', currentRoute: currentRoute, isMobile: isMobile),
      _NavBarItem(title: 'Artist', path: '/artist', currentRoute: currentRoute, isMobile: isMobile),
      _NavBarItem(title: 'About', path: '/about', currentRoute: currentRoute, isMobile: isMobile),
      _NavBarItem(title: 'Clients', path: '/clients', currentRoute: currentRoute, isMobile: isMobile),
      _NavBarItem(title: 'Contact', path: '/contact', currentRoute: currentRoute, isMobile: isMobile),
    ];
  }
}

// ==========================================
// 🔗 INDIVIDUAL NAVBAR ITEM COMPONENT
// ==========================================
class _NavBarItem extends StatefulWidget {
  final String title;
  final String path;
  final String currentRoute;
  final bool isMobile;

  const _NavBarItem({
    required this.title,
    required this.path,
    required this.currentRoute,
    required this.isMobile,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool isHovered = false;

  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🧠 ACTIVE STATE DETECTOR
    bool isActive = widget.currentRoute == widget.path || (widget.path != '/' && widget.currentRoute.startsWith(widget.path));
    int animMs = AppTheme.transitionSpeed == 'fast' ? 150 : (AppTheme.transitionSpeed == 'slow' ? 400 : 250);

    return Padding(
      // 🛠️ FIX: Proper spacing between links based on device
      padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 12.0 : 18.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => isHovered = true);
          // Only play hover sound on desktop to avoid annoying taps on mobile
          if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky' && !widget.isMobile) {
            HapticFeedback.selectionClick();
          }
        },
        onExit: (_) => setState(() => isHovered = false),
        cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
        
        child: GestureDetector(
          onTap: () {
            _triggerSound();
            context.go(widget.path);
          },
          child: Container(
            color: Colors.transparent, // Ensures the entire area is clickable
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // 🛠️ FIX: Text aur Underline ekdum perfectly center me align honge
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                
                // 📝 MENU TEXT
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: animMs), 
                  curve: Curves.easeOutCubic,
                  style: AppTheme.getBodyStyle(
                    fontSize: widget.isMobile ? 15 : 14,
                    color: (isHovered || isActive) ? AppTheme.accent : AppTheme.textSub,
                    weight: (isHovered || isActive) ? FontWeight.bold : FontWeight.w500,
                  ).copyWith(letterSpacing: 1.0),
                  child: Text(widget.title),
                ),
                
                const SizedBox(height: 6), // 🛠️ FIX: Consistent spacing
                
                // ✨ ANIMATED UNDERLINE INDICATOR
                AnimatedContainer(
                  duration: Duration(milliseconds: animMs), 
                  curve: Curves.easeOutCubic,
                  width: (isHovered || isActive) ? (widget.isMobile ? 15 : 24) : 0, 
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: AppTheme.accent, 
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: (AppTheme.enableGlow && (isHovered || isActive)) 
                        ? [BoxShadow(color: AppTheme.accent, blurRadius: 10, spreadRadius: 1)]
                        : [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}