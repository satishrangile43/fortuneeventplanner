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
    if (AppTheme.enableSoundEffects) HapticFeedback.lightImpact();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Gallery',
      // 🚀 ENGINE SYNC: Global Transition Speed se link kar diya!
      transitionDuration: Duration(milliseconds: AppTheme.durationMs),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          // 🚀 ENGINE SYNC: Blur toggle ke hisaab se chalega
          filter: ImageFilter.blur(
            sigmaX: AppTheme.enableBlur ? 15 : 5, 
            sigmaY: AppTheme.enableBlur ? 15 : 5
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              
              // 🚀 ENGINE SYNC: Global UI Style (Glass, Neumorphism, etc.)
              decoration: AppTheme.getCardDecoration(isHovered: false),
              
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
                      IconButton(
                        icon: Icon(Icons.close, color: AppTheme.textMain, size: 30), 
                        onPressed: () {
                          if (AppTheme.enableSoundEffects) HapticFeedback.selectionClick();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Divider(color: AppTheme.accent.withValues(alpha: 0.2)),
                  const SizedBox(height: 20),
                  
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: MediaQuery.of(context).size.width * 0.5,
                          // 🚀 ENGINE SYNC: Border Radius Admin panel se chalega
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()),
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
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
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
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 320,
          height: 350, 
          padding: const EdgeInsets.all(30),
          
          // 🚀 ENGINE SYNC: Hover hone par UI Engine apne aap design badlega
          decoration: AppTheme.getCardDecoration(isHovered: isHovered),
          
          // 🚀 ENGINE SYNC: Admin Panel ka "Hover Effect" aur "Parallax" yahan se trigger hoga!
          transform: AppTheme.getHoverTransform(isHovered),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🚀 ENGINE SYNC: Heading Font
              Text(
                widget.title,
                style: AppTheme.getHeadingStyle(
                  fontSize: 22, 
                  color: isHovered ? AppTheme.bg : AppTheme.textMain
                ),
              ),
              const SizedBox(height: 15),
              // 🚀 ENGINE SYNC: Body Font
              Expanded(
                child: Text(
                  widget.description,
                  style: AppTheme.getBodyStyle(
                    fontSize: 14, 
                    color: isHovered ? AppTheme.bg.withValues(alpha: 0.8) : AppTheme.textSub
                  ).copyWith(height: 1.6),
                ),
              ),
              
              // Explore More Button
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () => _showGallery(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isHovered ? AppTheme.bg : Colors.transparent,
                      border: Border.all(color: isHovered ? AppTheme.bg : AppTheme.accent),
                      // 🚀 ENGINE SYNC: Button ya Border Style par react karega
                      borderRadius: BorderRadius.circular(AppTheme.buttonStyle == 'pill' ? 50 : AppTheme.getGlobalRadius()),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🚀 ENGINE SYNC: Body Font
                        Text(
                          'Explore More',
                          style: AppTheme.getBodyStyle(
                            fontSize: 12, 
                            color: AppTheme.accent, 
                            weight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.image_search,
                          size: 16,
                          color: AppTheme.accent, 
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