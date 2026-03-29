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
    // 🚀 ENGINE SYNC: Dynamic Duration applied from AppTheme
    transitionDuration: Duration(milliseconds: AppTheme.durationMs),
    // 🟢 FIX: Reverse duration bhi same rakhi taaki back aate waqt bhi smooth lage
    reverseTransitionDuration: Duration(milliseconds: AppTheme.durationMs),
    // 🟢 OPTIMIZATION: maintainState true rakha hai taaki back aane par page load na ho, memory me rahe
    maintainState: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      
      // 🚀 PERFORMANCE MODE Check: Low-end devices/Web ke liye animations band
      if (AppTheme.enablePerformanceMode) {
        return child; 
      }

      // 🟢 GOD TIER FIX: Secondary Animation (Jab naya page upar aaye, purana page automatically thoda piche/fade ho jaye)
      // Yeh Apple iOS jaisi premium depth deta hai!
      final fadeOutOldPage = Tween<double>(begin: 1.0, end: 0.0)
          .animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic));

      // 🚀 MASTER CONTROL PANEL: Dynamic Routing Animations
      Widget animatedPage;

      switch (AppTheme.globalAnimation) {
        case 'slide':
          animatedPage = SlideTransition(
            // 🟢 FIX: Start closer (0.05 se) for a subtle, elegant float up
            position: Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic), 
              child: child
            ),
          );
          break;
          
        case 'zoom':
          animatedPage = ScaleTransition(
            // 🟢 FIX: easeOutQuart gives a buttery smooth snap into place without overshooting
            scale: Tween<double>(begin: 0.96, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuart)),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), 
              child: child
            ),
          );
          break;

        case 'bounce':
          animatedPage = SlideTransition(
            // 🟢 FIX: 1.0 se aane par aankho mein chubhta hai, 0.15 is perfectly balanced for a page drop
            position: Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.bounceOut)),
            child: FadeTransition(opacity: animation, child: child), // Added fade so it doesn't pop suddenly
          );
          break;

        case 'elastic':
          animatedPage = ScaleTransition(
            // 🟢 FIX: Scaled up slightly so it doesn't look like a tiny box bouncing
            scale: Tween<double>(begin: 0.90, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.elasticOut)),
            child: FadeTransition(opacity: animation, child: child),
          );
          break;

        case 'rotate':
          animatedPage = RotationTransition(
            // 🟢 FIX: Kept the rotation subtle, applied better easing
            turns: Tween<double>(begin: -0.015, end: 0.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuart)),
            child: ScaleTransition( // 🟢 FIX: Added scale with rotate for a 3D spin effect
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: FadeTransition(opacity: animation, child: child),
            ),
          );
          break;

        case 'flip':
          animatedPage = AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // 🚀 3D Y-Axis Flip Effect (Smoothed out)
              final angle = (1 - CurvedAnimation(parent: animation, curve: Curves.easeOutCubic).value) * math.pi / 2;
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // Perspective depth
                  ..rotateY(angle),
                alignment: Alignment.center,
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn), 
                  child: child
                ),
              );
            },
            child: child,
          );
          break;

        // 🔥 NAYE UPGRADED EFFECTS 🔥
        case 'pulse':
          animatedPage = ScaleTransition(
            // 🟢 FIX: 1.05 is too huge for a screen, 1.02 gives that premium "heartbeat" push
            scale: Tween<double>(begin: 1.02, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
              child: child,
            ),
          );
          break;
          
        case 'wave':
          animatedPage = SlideTransition(
            // 🟢 FIX: Horizontal slide with easeOutCubic looks much cleaner than elasticOut for pages
            position: Tween<Offset>(begin: const Offset(0.05, 0.0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), 
              child: child
            ),
          );
          break;
          
        case 'glitch':
          animatedPage = SlideTransition(
            // 🟢 FIX: Real glitch feel (sharp, fast snap) using easeOutExpo
            position: Tween<Offset>(begin: const Offset(0.02, 0.0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutExpo)),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.linear), // Linear fade for digital feel
              child: child,
            ),
          );
          break;

        case 'fade':
        default:
          // 🟢 FIX: easeOutCubic makes the fade feel instantly responsive instead of slowly creeping in
          animatedPage = FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
          break;
      }

      // 🟢 GOD TIER COMBINATION: Apply the secondary fade-out to whichever animation was chosen
      return FadeTransition(
        opacity: fadeOutOldPage, // Fades out the old page smoothly as the new one animates in
        child: animatedPage,
      );
    },
  );
}

// ==========================================
// 🚀 APP ROUTER CONFIGURATION
// ==========================================
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  
  // 🟢 UPGRADE: Error Builder (Agar Desktop/Web user galat URL type kare, toh crash nahi hoga, seedha Home pe redirect ya error page dikhayega)
  errorPageBuilder: (context, state) => _buildPageWithTransition(
    const HomePage(), // Yahan tum ek alag se `Error404Page()` bhi bana ke daal sakte ho future me
    state,
  ),

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