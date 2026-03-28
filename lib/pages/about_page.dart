import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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

  // ==========================================
  // 🛠️ THE MINI-EDITOR (CLICK-TO-EDIT POPUP)
  // ==========================================
  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    _triggerSound();
    TextEditingController textCtrl = TextEditingController(
      text: provider.elementSettings['${elementKey}_text'] ?? defaultText
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.95), // 🟢 Fixed visibility
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5), 
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()) 
        ),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                labelText: "Text Content",
                labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05), // 🟢 Soft fill
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppTheme.accent, width: 1)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              onChanged: (val) => provider.updateElement('${elementKey}_text', val),
            ),
            const SizedBox(height: 25),
            
            Text("Select Color:", style: AppTheme.getBodyStyle(fontSize: 13, color: Colors.white54, weight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Colors.white, Colors.black, AppTheme.accent, Colors.blueAccent, 
                Colors.redAccent, Colors.greenAccent, Colors.purpleAccent, Colors.orangeAccent
              ].map((c) => 
                MouseRegion(
                  cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      _triggerSound();
                      provider.updateElement('${elementKey}_color', c);
                    },
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        color: c, 
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                        boxShadow: provider.elementSettings['${elementKey}_color'] == c 
                            ? [BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 2)] 
                            : [],
                      ),
                    ),
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 35),

            Center(
              child: MouseRegion(
                cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _triggerSound();
                    provider.clearElementSetting('${elementKey}_text');
                    provider.clearElementSetting('${elementKey}_color');
                    Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                  label: const Text("Reset to Default", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            )
          ],
        ),
        actions: [
          MouseRegion(
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
            child: TextButton(
              onPressed: () {
                _triggerSound();
                Navigator.pop(ctx);
              }, 
              child: Text("DONE", style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 16))
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 🖼️ EDITABLE WRAPPER (HIGHLIGHTS IN GOD MODE)
  // ==========================================
  Widget _buildEditable(BuildContext context, ThemeProvider provider, String key, String defaultText, Widget child) {
    if (!provider.isSelectionMode) return child; 

    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: GestureDetector(
        onTap: () => _showObjectEditor(context, provider, key, defaultText),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent, width: 2, style: BorderStyle.solid), 
            color: Colors.pinkAccent.withValues(alpha: 0.05), // 🟢 Soft Highlight
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // 🟢 Breathing room
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.elementSettings['about_bg_color'] ?? AppTheme.bg,
          body: MouseRegion(
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : 
                    AppTheme.cursorType == 'crosshair' ? SystemMouseCursors.precise : SystemMouseCursors.basic,
            child: Container(
              decoration: AppTheme.getBackgroundDecoration(), // 🌟 Apply Global Background Pattern
              child: Column(
                children: [
                  if (AppTheme.navbarStyle != 'hidden') const CustomNavbar(),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AppTheme.scrollEffect == 'bouncy' 
                          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) 
                          : const ClampingScrollPhysics(), // ⚡ ENGINE SYNC
                      child: Column(
                        children: [
                          // ==========================================
                          // --- PAGE HEADER SECTION ---
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 80,
                              vertical: isMobile ? 60 : 100, // 🟢 Better padding for breathing room
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.enableGradients ? LinearGradient(
                                colors: [
                                  AppTheme.activeTheme == 'luxury' 
                                      ? Colors.deepPurple.shade900.withValues(alpha: 0.6) 
                                      : AppTheme.cardBg.withValues(alpha: 0.6), // 🟢 Smoother base
                                  Colors.transparent // 🟢 Fade out into main body seamlessly
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ) : null,
                            ),
                            child: Column(
                              children: [
                                // 🚀 1. EDITABLE TITLE
                                _buildEditable(
                                  context, provider, 'about_title', 'Our Story', // 🟢 Better Copy
                                  AppTheme.applyAnim(
                                    Text(
                                      provider.elementSettings['about_title_text'] ?? 'Our Story',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.getHeadingStyle(
                                        fontSize: isMobile ? 42 : 72, // 🟢 Massive Desktop Impact
                                        weight: FontWeight.w800,
                                        color: provider.elementSettings['about_title_color'] ?? AppTheme.textMain, 
                                      ).copyWith(
                                        letterSpacing: -2.0, // Modern tight kerning
                                        shadows: AppTheme.enableShadows ? [Shadow(color: AppTheme.textMain.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 15)] : []
                                      ),
                                    ),
                                    0,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // 🚀 2. EDITABLE SUBTITLE
                                _buildEditable(
                                  context, provider, 'about_subtitle', 'We build the backbone of unforgettable experiences through precision, manpower, and dedication.', // 🟢 Compelling Copy
                                  AppTheme.applyAnim(
                                    Container(
                                      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 750), // 🟢 Control wide screens
                                      child: Text(
                                        provider.elementSettings['about_subtitle_text'] ?? 'We build the backbone of unforgettable experiences through precision, manpower, and dedication.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 16 : 20,
                                          weight: FontWeight.w500,
                                          color: provider.elementSettings['about_subtitle_color'] ?? AppTheme.textSub, 
                                        ).copyWith(letterSpacing: 0.5, height: 1.6),
                                      ),
                                    ),
                                    (AppTheme.transitionSpeed == 'fast' ? 50 : 200), // 🚀 Stagger
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ==========================================
                          // --- MAIN CONTENT CARDS SECTION ---
                          // ==========================================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 60,
                              vertical: 40,
                            ),
                            child: Wrap(
                              spacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, // 🟢 Adaptive Spacing
                              runSpacing: AppTheme.layoutStyle == 'dense' ? 30 : 50,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildAboutCard(
                                  context, provider, 'vision',
                                  title: 'Our Vision',
                                  icon: Icons.visibility_outlined,
                                  description: 'To be the most trusted and sought-after event management and staffing partner globally, setting unmatched standards in execution, reliability, and hospitality.',
                                  delay: 200,
                                ),
                                _buildAboutCard(
                                  context, provider, 'mission',
                                  title: 'Our Mission',
                                  icon: Icons.rocket_launch_outlined,
                                  description: 'To seamlessly bridge the gap between grand ideas and flawless execution by providing highly trained professionals, unparalleled logistics, and secure environments for every event.',
                                  delay: 400,
                                ),
                                _buildAboutCard(
                                  context, provider, 'values',
                                  title: 'Core Values',
                                  icon: Icons.diamond_outlined,
                                  description: 'Integrity in every interaction. Precision in every operation. Excellence in every execution. We believe in building lasting partnerships through unwavering dedication.',
                                  delay: 600,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isMobile ? 60 : 100),
                          if (AppTheme.footerStyle != 'hidden') const CustomFooter(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  // ==========================================
  // 🌟 VVIP ABOUT CARD (Hover & Typography Optimized)
  // ==========================================
  Widget _buildAboutCard(BuildContext context, ThemeProvider provider, String id, {
    required String title,
    required IconData icon,
    required String description,
    required int delay,
  }) {
    bool isCardHovered = false; 
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    // 🚀 ENGINE SYNC: Intelligent dynamic staggering based on AppTheme
    int delayMultiplier = AppTheme.transitionSpeed == 'fast' ? 40 : (AppTheme.transitionSpeed == 'slow' ? 150 : 80);
    int dynamicDelay = delay + delayMultiplier;

    return AppTheme.applyAnim(
      StatefulBuilder(
        builder: (context, setCardState) {
          return MouseRegion(
            onEnter: (_) {
              setCardState(() => isCardHovered = true);
              if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky') HapticFeedback.selectionClick();
            },
            onExit: (_) => setCardState(() => isCardHovered = false),
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300), 
              curve: Curves.easeOutCubic,
              width: isMobile ? double.infinity : 380, // 🟢 Perfect reading width (not too wide)
              padding: EdgeInsets.all(isMobile ? 35 : 45), // 🟢 Luxurious padding
              decoration: AppTheme.getCardDecoration(isHovered: isCardHovered).copyWith(
                borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
                // 🟢 Beautiful hover shadow
                boxShadow: AppTheme.enableShadows && isCardHovered ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.25), blurRadius: 30, spreadRadius: 5, offset: const Offset(0, 10))] : [],
              ),
              transform: AppTheme.getHoverTransform(isCardHovered),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Header
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isCardHovered ? AppTheme.accent : AppTheme.accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: (AppTheme.enableGlow && isCardHovered) ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.5), blurRadius: 20)] : []
                    ),
                    child: Icon(icon, size: 35, color: isCardHovered ? Colors.white : AppTheme.accent), // 🟢 Icon inversion on hover
                  ),
                  const SizedBox(height: 35), // 🟢 More breathing room before title
                  
                  // Title
                  _buildEditable(
                    context, provider, 'about_card_${id}_title', title,
                    Text(
                      provider.elementSettings['about_card_${id}_title_text'] ?? title,
                      style: AppTheme.getHeadingStyle(
                        fontSize: isMobile ? 26 : 30,
                        weight: FontWeight.w800,
                        color: provider.elementSettings['about_card_${id}_title_color'] ?? (isCardHovered ? (AppTheme.enableGlow ? AppTheme.accent : AppTheme.textMain) : AppTheme.textMain), // 🟢 Text reacts to hover
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Description
                  _buildEditable(
                    context, provider, 'about_card_${id}_desc', description,
                    Text(
                      provider.elementSettings['about_card_${id}_desc_text'] ?? description,
                      style: AppTheme.getBodyStyle(
                        fontSize: 15,
                        weight: isCardHovered ? FontWeight.w600 : FontWeight.w500, // 🟢 Slightly bolder on hover for focus
                        color: provider.elementSettings['about_card_${id}_desc_color'] ?? (isCardHovered ? AppTheme.textMain.withValues(alpha: 0.9) : AppTheme.textSub),
                      ).copyWith(height: 1.7), // 🟢 Tall line-height for easier reading
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
      dynamicDelay,
    );
  }  
}