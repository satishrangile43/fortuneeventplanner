import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../theme/app_theme.dart'; // 🚀 GLOBAL THEME ENGINE IMPORTED

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

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
    // 🚀 ENGINE SYNC: Check Navbar Style (Hidden, Sticky, Floating)
    if (AppTheme.navbarStyle == 'hidden') {
      return const SizedBox.shrink(); // Hide the navbar completely
    }

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile || MediaQuery.of(context).size.width < 800;
        
        // 🚀 ENGINE SYNC: Floating Navbar Logic
        bool isFloating = AppTheme.navbarStyle == 'floating';
        double marginValue = isFloating ? (isMobile ? 15.0 : 30.0) : 0.0;
        
        // 🟢 FIX: Border Style Sync (Sharp overrides radius)
        double radiusValue = AppTheme.borderStyle == 'sharp' ? 0.0 : (isFloating ? AppTheme.getGlobalRadius() : 0.0);

        return Container(
          // Floating margin apply karna hai ya nahi
          margin: EdgeInsets.only(top: marginValue, left: marginValue, right: marginValue),
          child: ClipRRect( 
            borderRadius: BorderRadius.circular(radiusValue), // 🚀 ENGINE SYNC: Border Radius apply
            child: BackdropFilter(
              // 🚀 ENGINE SYNC: Blur effect Admin Panel se toggle hoga
              filter: ImageFilter.blur(
                sigmaX: AppTheme.enableBlur ? 20 : 0.001, 
                sigmaY: AppTheme.enableBlur ? 20 : 0.001
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : (isFloating ? 40 : 60), 
                    vertical: isMobile ? 15 : 20
                ),
                decoration: BoxDecoration(
                  // 🚀 ENGINE SYNC & 🟢 COLOR FIX: Dynamic contrast engine. Blur off hone par background dark/solid rahega taaki text visible rahe.
                  color: (AppTheme.globalUIStyle == 'solid' || !AppTheme.enableBlur)
                      ? AppTheme.bg 
                      : AppTheme.bg.withValues(alpha: 0.85), 
                  border: isFloating 
                    ? Border.all(color: AppTheme.accent.withValues(alpha: 0.2), width: 1.5) // 🟢 FIX: Colored floating border
                    : Border(
                        bottom: BorderSide(
                          color: AppTheme.accent.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                  borderRadius: BorderRadius.circular(radiusValue),
                  // 🚀 ENGINE SYNC: Shadow toggle
                  boxShadow: AppTheme.enableShadows ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isFloating ? 0.3 : 0.15), 
                      blurRadius: isFloating ? 20 : 10, 
                      offset: Offset(0, isFloating ? 10 : 5)
                    )
                  ] : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ==========================================
                    // 1. BRAND LOGO (Upgraded visibility)
                    // ==========================================
                    InkWell(
                      // 🚀 ENGINE SYNC: Custom Cursor Type
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🚀 ENGINE SYNC: Heading Font Engine
                          Text(
                            'FORTUNE',
                            style: AppTheme.getHeadingStyle(
                              fontSize: isMobile ? 20 : 28,
                              color: AppTheme.textMain,
                              weight: FontWeight.bold,
                            ).copyWith(
                              letterSpacing: 2.0,
                              // 🟢 FIX: Text shadow for premium punch
                              shadows: [Shadow(color: AppTheme.textMain.withValues(alpha: 0.2), offset: const Offset(0, 2), blurRadius: 4)]
                            ),
                          ),
                          // 🚀 ENGINE SYNC: Body Font Engine
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

                    if (isMobile) const SizedBox(width: 15),

                    // ==========================================
                    // 2. NAVIGATION LINKS (Web & Mobile Split)
                    // ==========================================
                    if (!isMobile)
                      // 🖥️ Desktop UI: Clean Row
                      Row(
                        children: _getNavItems(context, isMobile: false),
                      )
                    else
                      // 📱 Mobile UI: Smooth Scrollable Row with Soft Edges
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), // 🟢 FIX: Ultra smooth bouncing for iOS/Android
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
// 🎯 CUSTOM HOVER ITEM WIDGET
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
    // Exact match or sub-route match logic
    bool isActive = widget.currentRoute == widget.path || (widget.path != '/' && widget.currentRoute.startsWith(widget.path));

    // 🚀 ENGINE SYNC: Dynamic transition speed sync
    int animMs = AppTheme.transitionSpeed == 'fast' ? 150 : (AppTheme.transitionSpeed == 'slow' ? 400 : 250);

    return Padding(
      // 🟢 FIX: Mobile pe spacing kam kar di taaki zyada items ek screen par fit aayein
      padding: EdgeInsets.symmetric(horizontal: widget.isMobile ? 12.0 : 18.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => isHovered = true);
          if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky' && !widget.isMobile) HapticFeedback.selectionClick(); // Soft hover click for web
        },
        onExit: (_) => setState(() => isHovered = false),
        // 🚀 ENGINE SYNC: Custom Cursor Type
        cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
        
        child: GestureDetector(
          onTap: () {
            _triggerSound();
            context.go(widget.path);
          },
          child: Container(
            color: Colors.transparent, // Ensures the whole area is clickable on mobile
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🚀 ENGINE SYNC: Body Font Engine & Dynamic Color
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: animMs), 
                  curve: Curves.easeOutCubic,
                  style: AppTheme.getBodyStyle(
                    // 🟢 FIX: Slightly larger font for better touch targets on mobile
                    fontSize: widget.isMobile ? 15 : 14,
                    color: (isHovered || isActive) ? AppTheme.accent : AppTheme.textSub,
                    weight: (isHovered || isActive) ? FontWeight.bold : FontWeight.w500,
                  ).copyWith(letterSpacing: 1.0),
                  child: Text(widget.title),
                ),
                const SizedBox(height: 6),
                
                // 🚀 Hover Underline Indicator
                AnimatedContainer(
                  duration: Duration(milliseconds: animMs), 
                  curve: Curves.easeOutCubic,
                  width: (isHovered || isActive) ? (widget.isMobile ? 15 : 24) : 0, // 🟢 FIX: Adaptive underline width
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: AppTheme.accent, // 🚀 Dynamic Line Color
                    borderRadius: BorderRadius.circular(10),
                    // 🚀 ENGINE SYNC: Glow toggle pe react karega
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