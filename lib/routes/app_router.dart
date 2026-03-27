import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart'; // 🚀 GLOBAL THEME ENGINE IMPORTED

import '../pages/home_page.dart';
import '../pages/services_page.dart';
import '../pages/security_page.dart';
import '../pages/artist_page.dart'; 
import '../pages/about_page.dart';   
import '../pages/clients_page.dart'; 
import '../pages/contact_page.dart'; 

// ==========================================
// ✨ GLOBAL PAGE TRANSITION ENGINE (GOD MODE)
// ==========================================
CustomTransitionPage _buildPageWithTransition(Widget page, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: page,
    transitionDuration: const Duration(milliseconds: 600), // 🚀 STANDARD DURATION
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      
      // 🚀 PERFORMANCE MODE Check: Low-end devices ke liye animations band
      if (AppTheme.enablePerformanceMode) {
        return child; 
      }

      // 🚀 MASTER CONTROL PANEL: Check karo konsi animation select hui hai
      switch (AppTheme.globalAnimation) {
        case 'slide':
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: animation, child: child),
          );
          
        case 'zoom':
          return ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
            child: FadeTransition(opacity: animation, child: child),
          );

        case 'bounce':
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
            child: child,
          );

        case 'elastic':
          return ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
            child: FadeTransition(opacity: animation, child: child),
          );

        case 'rotate':
          return RotationTransition(
            turns: Tween<double>(begin: -0.02, end: 0.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: animation, child: child),
          );

        case 'flip':
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // 🚀 3D Y-Axis Flip Effect
              final angle = (1 - animation.value) * math.pi / 2;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: child,
          );

        case 'fade':
        case 'glitch': 
        case 'wave':
        case 'pulse':
        default:
          // Default smooth fade effect
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
            child: child,
          );
      }
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/', 
      pageBuilder: (context, state) => _buildPageWithTransition(const HomePage(), state)
    ),
    GoRoute(
      path: '/services', 
      pageBuilder: (context, state) => _buildPageWithTransition(const ServicesPage(), state)
    ),
    GoRoute(
      path: '/security', 
      pageBuilder: (context, state) => _buildPageWithTransition(const SecurityPage(), state)
    ),
    GoRoute(
      path: '/artist', 
      pageBuilder: (context, state) => _buildPageWithTransition(const ArtistPage(), state)
    ), 
    GoRoute(
      path: '/about', 
      pageBuilder: (context, state) => _buildPageWithTransition(const AboutPage(), state)
    ),
    GoRoute(
      path: '/clients', 
      pageBuilder: (context, state) => _buildPageWithTransition(const ClientsPage(), state)
    ),
    GoRoute(
      path: '/contact', 
      pageBuilder: (context, state) => _buildPageWithTransition(const ContactPage(), state)
    ),
  ],
);