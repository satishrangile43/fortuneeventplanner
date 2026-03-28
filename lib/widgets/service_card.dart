import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart'; // 🎨 Global Theme Engine Linked

class ServiceCard extends StatefulWidget {
  final String title;
  final String description;
  final int delay;
  final List<String> images; 

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.delay,
    required this.images,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isHovered = false;

  void _showGallery(BuildContext context) {
    // 🔊 ENGINE SYNC: Sound/Haptic feedback trigger
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Gallery',
      // 🚀 ENGINE SYNC: Global Transition Speed se link kar diya!
      transitionDuration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 200 : (AppTheme.transitionSpeed == 'slow' ? 600 : 400)),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          // 🚀 ENGINE SYNC: Blur toggle ke hisaab se chalega
          filter: ImageFilter.blur(
            sigmaX: AppTheme.enableBlur ? 15 : 5, 
            sigmaY: AppTheme.enableBlur ? 15 : 5
          ),
          child: Center(
            child: Material( // 🟢 FIX: Material wrapper added for clean text rendering in Dialogs
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.9, // 🟢 FIX: Responsive Width
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(30),
                
                // 🚀 ENGINE SYNC & 🟢 COLOR FIX: Base color solid kiya taaki blur pe text padhne mein aaye
                decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
                  color: AppTheme.bg.withValues(alpha: 0.9), // Ensures readability over background images
                  border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5)],
                ),
                
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🚀 ENGINE SYNC: Dynamic Font Engine
                        Text(
                          widget.title,
                          style: AppTheme.getHeadingStyle(
                            fontSize: 28, 
                            color: AppTheme.textMain
                          ).copyWith(decoration: TextDecoration.none),
                        ),
                        // 🟢 FIX: Better Close Button with Hover logic via Material/InkWell style
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: AppTheme.textMain, size: 32), 
                          splashRadius: 24,
                          hoverColor: Colors.redAccent.withValues(alpha: 0.2),
                          onPressed: () {
                            if (AppTheme.enableSoundEffects) HapticFeedback.lightImpact();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(color: AppTheme.accent.withValues(alpha: 0.2), thickness: 2),
                    const SizedBox(height: 20),
                    
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 25, bottom: 10, top: 10), // 🟢 FIX: Proper padding for shadow spread
                            width: MediaQuery.of(context).size.width > 800 ? 400 : MediaQuery.of(context).size.width * 0.7,
                            // 🚀 ENGINE SYNC: Border Radius Admin panel se chalega
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()),
                              // 🟢 FIX: Gallery Images ko Premium BoxShadow diya
                              boxShadow: AppTheme.enableShadows ? [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 10))] : [],
                            ),
                            // 🚀 ENGINE SYNC: Image Filters (Grayscale, Sepia) yahan apply honge!
                            child: AppTheme.applyImageFilter(
                              ClipRRect(
                                borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()),
                                child: Image.network(
                                  widget.images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate( // 🟢 FIX: Softer scale transition (0.95 to 1.0)
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ENGINE SYNC: Global Animation Engine Apply Kiya
    return AppTheme.applyAnim(
      MouseRegion(
        // 🚀 ENGINE SYNC: Custom Cursor Type
        cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => isHovered = true);
          if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky') HapticFeedback.selectionClick();
        },
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300),
          width: 320,
          height: 350, 
          padding: const EdgeInsets.all(30),
          
          // 🚀 ENGINE SYNC & 🟢 FIX: Hover hone par UI Engine apne aap design badlega, added premium shadow glow
          decoration: AppTheme.getCardDecoration(isHovered: isHovered).copyWith(
            borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
            boxShadow: AppTheme.enableShadows && isHovered ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.3), blurRadius: 25, spreadRadius: 2)] : [],
          ),
          
          // 🚀 ENGINE SYNC: Admin Panel ka "Hover Effect" aur "Parallax" yahan se trigger hoga!
          transform: AppTheme.getHoverTransform(isHovered),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🚀 ENGINE SYNC & 🟢 COLOR FIX: Heading Font
              Text(
                widget.title,
                style: AppTheme.getHeadingStyle(
                  fontSize: 24, 
                  // 🟢 FIX: Hover par text invisible na ho, balki theme ke according glow/pop kare
                  color: isHovered ? (AppTheme.enableGlow ? AppTheme.accent : AppTheme.textMain) : AppTheme.textMain
                ),
              ),
              const SizedBox(height: 15),
              // 🚀 ENGINE SYNC & 🟢 COLOR FIX: Body Font
              Expanded(
                child: Text(
                  widget.description,
                  style: AppTheme.getBodyStyle(
                    fontSize: 14, 
                    // 🟢 FIX: Hover par background color ke hisaab se readability break na ho
                    color: isHovered ? AppTheme.textMain.withValues(alpha: 0.9) : AppTheme.textSub
                  ).copyWith(height: 1.6),
                ),
              ),
              
              // 🟢 FIX: Explore More Button - Ultimate Contrast Edition
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () => _showGallery(context),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isHovered ? AppTheme.accent : Colors.transparent, // Solid fill on hover
                      border: Border.all(color: AppTheme.accent, width: 1.5), // Fixed visible border
                      // 🚀 ENGINE SYNC: Button ya Border Style par react karega
                      borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'sharp' ? 0 : (AppTheme.buttonStyle == 'pill' ? 50 : AppTheme.getGlobalRadius())),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🚀 ENGINE SYNC: Body Font
                        Text(
                          'Explore More',
                          style: AppTheme.getBodyStyle(
                            fontSize: 13, 
                            // 🟢 FIX: Solid contrast color on hover (e.g. black text on colored accent background)
                            color: isHovered ? Colors.black : AppTheme.accent, 
                            weight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.image_search_rounded, // Smooth icon
                          size: 18,
                          color: isHovered ? Colors.black : AppTheme.accent, 
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      widget.delay, 
    );
  }
}