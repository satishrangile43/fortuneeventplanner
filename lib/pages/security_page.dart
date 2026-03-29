import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:provider/provider.dart';

// Hamare banaye hue Custom Widgets aur Theme Engine
import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 MASTER ENGINE
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  // ==========================================
  // 🔊 SOUND TRIGGER HELPER
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
        backgroundColor: Colors.black.withValues(alpha: 0.95), // 🟢 FIX: Darker blur base for visibility
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5), 
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()) 
        ),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        
        // 🛠️ FIX: Mobile pe Keyboard aane se screen fatne (overflow) se bachane ke liye SingleChildScrollView
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                  fillColor: Colors.white.withValues(alpha: 0.05), // 🟢 FIX: Better contrast input
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
            color: Colors.pinkAccent.withValues(alpha: 0.05), // 🟢 FIX: Very soft highlight so text is readable
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // 🟢 FIX: Breathing room
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
        return MouseRegion(
          // 🖱️ ENGINE SYNC: Custom Cursor Type
          cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : 
                  AppTheme.cursorType == 'crosshair' ? SystemMouseCursors.precise : SystemMouseCursors.basic,
          child: Scaffold(
            backgroundColor: provider.elementSettings['security_bg_color'] ?? AppTheme.bg, 
            body: Container(
              decoration: AppTheme.getBackgroundDecoration(), // 🌟 Apply Global Background Pattern
              child: Column(
                children: [
                  if (AppTheme.navbarStyle != 'hidden') const CustomNavbar(), 
                  
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AppTheme.scrollEffect == 'bouncy' 
                          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) 
                          : const ClampingScrollPhysics(), // ⚡ ENGINE SYNC: Smooth Scroll Style
                      child: Column(
                        children: [
                          // ==========================================
                          // --- PAGE HEADER SECTION ---
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 80,
                              vertical: isMobile ? 60 : 100, // 🟢 FIX: Better desktop padding
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.enableGradients ? LinearGradient(
                                colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.5), Colors.transparent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ) : null,
                            ),
                            child: Column(
                              children: [
                                // 🚀 1. EDITABLE TITLE
                                _buildEditable(
                                  context, provider, 'security_title', 'Elite Security & Logistics', // 🟢 Premium Copy
                                  AppTheme.applyAnim(
                                    Text(
                                      provider.elementSettings['security_title_text'] ?? 'Elite Security & Logistics',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.getHeadingStyle(
                                        fontSize: isMobile ? 38 : 64, // 🟢 Massive Desktop Impact
                                        weight: FontWeight.w800,
                                        color: provider.elementSettings['security_title_color'] ?? AppTheme.textMain,
                                      ).copyWith(
                                        letterSpacing: -1.0,
                                        shadows: AppTheme.enableShadows ? [Shadow(color: AppTheme.textMain.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 15)] : [],
                                      ),
                                    ),
                                    0,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // 🚀 2. EDITABLE SUBTITLE
                                _buildEditable(
                                  context, provider, 'security_subtitle', 'Absolute control, unwavering protection, and seamless crowd management for your peace of mind.',
                                  AppTheme.applyAnim(
                                    Container(
                                      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700),
                                      child: Text(
                                        provider.elementSettings['security_subtitle_text'] ?? 'Absolute control, unwavering protection, and seamless crowd management for your peace of mind.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 15 : 18,
                                          weight: FontWeight.w500,
                                          color: provider.elementSettings['security_subtitle_color'] ?? AppTheme.textSub, 
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
                          // --- CONTENT SECTION (SECURITY GRID) ---
                          // ==========================================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 60,
                              vertical: 40,
                            ),
                            child: Wrap(
                              spacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, // 🟢 Adaptive Spacing
                              runSpacing: AppTheme.layoutStyle == 'dense' ? 30 : 50,
                              alignment: WrapAlignment.center, // 🛠️ FIX: Keep cards perfectly centered on all devices
                              children: [
                                _buildSecurityCard(
                                  context, provider, 'guard', 
                                  'Security Guards',
                                  Icons.security_rounded, // Premium Icon
                                  [
                                    'Comprehensive venue surveillance',
                                    'Access control & identity verification',
                                    'Perimeter and gate management',
                                    'Proactive threat detection',
                                  ],
                                  0, // Index 0
                                ),
                                _buildSecurityCard(
                                  context, provider, 'bouncer', 
                                  'Bouncers & VIP Protection',
                                  Icons.admin_panel_settings_rounded, // Premium Icon
                                  [
                                    'High-density crowd control',
                                    'Close personal protection for VIPs',
                                    'Stage barricade & backstage security',
                                    'Immediate emergency response',
                                  ],
                                  1, // Index 1
                                ),
                                _buildSecurityCard(
                                  context, provider, 'porter', 
                                  'Logistics & Support',
                                  Icons.engineering_rounded, // Premium Icon
                                  [
                                    'Rapid setup & dismantle support',
                                    'Heavy equipment handling',
                                    'Backstage coordination',
                                    'Seamless material flow management',
                                  ],
                                  2, // Index 2
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
 // 🛡️ PREMIUM CARD BUILDER WIDGET
 // ==========================================
  Widget _buildSecurityCard(BuildContext context, ThemeProvider provider, String id, String defaultTitle, IconData icon, List<String> points, int index) {
    bool isHovered = false; 
    
    // 🚀 ENGINE SYNC: Intelligent dynamic staggering for grids
    int delayMultiplier = AppTheme.transitionSpeed == 'fast' ? 40 : (AppTheme.transitionSpeed == 'slow' ? 150 : 80);
    int dynamicDelay = (index % 3) * delayMultiplier;

    return StatefulBuilder(
      builder: (context, setState) {
        return AppTheme.applyAnim(
          MouseRegion(
            onEnter: (_) {
              setState(() => isHovered = true);
              if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky') HapticFeedback.selectionClick();
            },
            onExit: (_) => setState(() => isHovered = false),
            // 🖱️ ENGINE SYNC: Custom Cursor
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300),
              width: MediaQuery.of(context).size.width < 600 ? double.infinity : 380, // 🟢 FIX: Full width on mobile, wider on desktop
              padding: const EdgeInsets.all(40), // 🟢 FIX: Better breathing room
              // 🌟 ENGINE SYNC: Decoration and Transforms
              decoration: AppTheme.getCardDecoration(isHovered: isHovered).copyWith(
                borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
                boxShadow: AppTheme.enableShadows && isHovered ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.25), blurRadius: 30, spreadRadius: 5)] : [],
              ),
              transform: AppTheme.getHoverTransform(isHovered), 
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ✨ ENGINE SYNC: Glow effect on icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isHovered ? AppTheme.accent : AppTheme.accent.withValues(alpha: 0.1),
                          boxShadow: (AppTheme.enableGlow && isHovered) 
                              ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.5), blurRadius: 20)] 
                              : []
                        ),
                        child: Icon(icon, size: 30, color: isHovered ? AppTheme.cardBg : AppTheme.accent), // Icon inverts on hover
                      ), 
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildEditable(
                          context, provider, 'security_card_${id}_title', defaultTitle,
                          Text(
                            provider.elementSettings['security_card_${id}_title_text'] ?? defaultTitle,
                            style: AppTheme.getHeadingStyle(
                              fontSize: 22,
                              weight: FontWeight.w800,
                              color: provider.elementSettings['security_card_${id}_title_color'] ?? (isHovered ? (AppTheme.enableGlow ? AppTheme.accent : AppTheme.textMain) : AppTheme.textMain), // 🟢 Text reacts to hover
                            ).copyWith(height: 1.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Divider(color: AppTheme.accent.withValues(alpha: isHovered ? 0.4 : 0.1), thickness: isHovered ? 2 : 1), // Line becomes stronger on hover
                  const SizedBox(height: 25),
                  
                  // Feature List
                  ...points.map((point) => Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0), // Align icon with text baseline
                              child: Icon(Icons.check_circle_rounded, 
                                   size: 16, 
                                   color: isHovered ? AppTheme.accent : AppTheme.textSub.withValues(alpha: 0.5)),
                            ), 
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                point,
                                style: AppTheme.getBodyStyle(
                                  fontSize: 14,
                                  weight: isHovered ? FontWeight.w600 : FontWeight.w500, // Text gets bolder on hover
                                  color: isHovered ? AppTheme.textMain.withValues(alpha: 0.9) : AppTheme.textSub,
                                ).copyWith(height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          dynamicDelay,
        );
      }
    );
  }
}