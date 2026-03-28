import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../theme/app_theme.dart'; // 🚀 GLOBAL THEME ENGINE IMPORTED

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    // 🚀 ENGINE SYNC: Check Navbar Style (Hidden, Sticky, Floating)
    if (AppTheme.navbarStyle == 'hidden') {
      return const SizedBox.shrink(); // Hide the navbar completely
    }

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile;
        
        // 🚀 ENGINE SYNC: Floating Navbar Logic
        bool isFloating = AppTheme.navbarStyle == 'floating';
        double marginValue = isFloating ? (isMobile ? 15.0 : 30.0) : 0.0;
        double radiusValue = isFloating ? AppTheme.getGlobalRadius() : 0.0;

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
                    horizontal: isMobile ? 20 : (isFloating ? 40 : 60), vertical: isMobile ? 15 : 20),
                decoration: BoxDecoration(
                  // 🚀 ENGINE SYNC: UI Style ke hisab se background transparency
                  color: AppTheme.globalUIStyle == 'solid' 
                      ? AppTheme.bg 
                      : AppTheme.bg.withValues(alpha: 0.85), 
                  border: isFloating 
                    ? Border.all(color: AppTheme.textMain.withValues(alpha: 0.1), width: 1) // Full border for floating
                    : Border(
                        bottom: BorderSide(
                          color: AppTheme.textMain.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                  // 🚀 ENGINE SYNC: Border radius wapas yahan lagana zaroori hai container ki shakal ke liye
                  borderRadius: BorderRadius.circular(radiusValue),
                  // 🚀 ENGINE SYNC: Shadow toggle
                  boxShadow: AppTheme.enableShadows ? [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5))
                  ] : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. BRAND LOGO 
                    InkWell(
                      // 🚀 ENGINE SYNC: Custom Cursor Type
                      mouseCursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                      onTap: () => context.go('/'),
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
                              fontSize: isMobile ? 22 : 28,
                              color: AppTheme.textMain,
                              weight: FontWeight.bold,
                            ).copyWith(letterSpacing: 2.0),
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

                    // 2. NAVIGATION LINKS
                    if (!isMobile)
                      // Desktop
                      Row(
                        children: _getNavItems(context),
                      )
                    else
                      // Mobile Smooth Slide
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _getNavItems(context),
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

  List<Widget> _getNavItems(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return [
      _NavBarItem(title: 'Home', path: '/', currentRoute: currentRoute),
      _NavBarItem(title: 'Services', path: '/services', currentRoute: currentRoute),
      _NavBarItem(title: 'Security', path: '/security', currentRoute: currentRoute),
      _NavBarItem(title: 'Artist', path: '/artist', currentRoute: currentRoute),
      _NavBarItem(title: 'About', path: '/about', currentRoute: currentRoute),
      _NavBarItem(title: 'Clients', path: '/clients', currentRoute: currentRoute),
      _NavBarItem(title: 'Contact', path: '/contact', currentRoute: currentRoute),
    ];
  }
}

// Custom Hover Item Widget
class _NavBarItem extends StatefulWidget {
  final String title;
  final String path;
  final String currentRoute;

  const _NavBarItem({
    required this.title,
    required this.path,
    required this.currentRoute,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.currentRoute == widget.path;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        // 🚀 ENGINE SYNC: Custom Cursor Type
        cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.go(widget.path),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🚀 ENGINE SYNC: Body Font Engine & Dynamic Color
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: AppTheme.durationMs), // 🚀 ENGINE SYNC: Speed control
                style: AppTheme.getBodyStyle(
                  fontSize: 14,
                  color: (isHovered || isActive) ? AppTheme.accent : AppTheme.textSub,
                  weight: (isHovered || isActive) ? FontWeight.bold : FontWeight.w500,
                ).copyWith(letterSpacing: 1.0),
                child: Text(widget.title),
              ),
              const SizedBox(height: 5),
              
              // Hover Underline Indicator
              AnimatedContainer(
                duration: Duration(milliseconds: AppTheme.durationMs), // 🚀 ENGINE SYNC: Speed control
                width: (isHovered || isActive) ? 20 : 0,
                height: 2,
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
    );
  }
}