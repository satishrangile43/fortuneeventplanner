import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

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
        backgroundColor: Colors.black.withValues(alpha: 0.95), // 🟢 Better contrast
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
          backgroundColor: provider.elementSettings['artist_bg_color'] ?? AppTheme.bg,
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
                                      ? Colors.deepPurple.shade900.withValues(alpha: 0.8) 
                                      : AppTheme.cardBg.withValues(alpha: 0.8), // 🟢 Smoother base
                                  AppTheme.bg.withValues(alpha: 0.5),
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
                                  context, provider, 'artist_title', 'Artist & Talent Management',
                                  AppTheme.applyAnim(
                                    Text(
                                      provider.elementSettings['artist_title_text'] ?? 'Artist & Talent Management',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.getHeadingStyle(
                                        fontSize: isMobile ? 38 : 64, // 🟢 Massive Desktop Impact
                                        weight: FontWeight.w800,
                                        color: provider.elementSettings['artist_title_color'] ?? AppTheme.textMain, 
                                      ).copyWith(
                                        letterSpacing: -1.0, // Modern kerning
                                        shadows: AppTheme.enableShadows ? [Shadow(color: AppTheme.textMain.withValues(alpha: 0.15), offset: const Offset(0, 4), blurRadius: 15)] : []
                                      ),
                                    ),
                                    0,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // 🚀 2. EDITABLE SUBTITLE
                                _buildEditable(
                                  context, provider, 'artist_subtitle', 'Flawless execution, uncompromising security, and elite hospitality for VIPs and global talent.', // 🟢 Better VIP Copy
                                  AppTheme.applyAnim(
                                    Container(
                                      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700), // 🟢 Control wide screens
                                      child: Text(
                                        provider.elementSettings['artist_subtitle_text'] ?? 'Flawless execution, uncompromising security, and elite hospitality for VIPs and global talent.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 15 : 18,
                                          weight: FontWeight.w500,
                                          color: provider.elementSettings['artist_subtitle_color'] ?? AppTheme.textSub, // 🟢 TextSub blends perfectly
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
                                _buildArtistCard(
                                  context, provider, 'talent',
                                  title: 'Talent Coordination',
                                  icon: Icons.mic_external_on_rounded, // 🟢 Modern rounded icon
                                  description: 'We orchestrate seamless communication between artists and organizers, ensuring every technical demand and hospitality rider is met flawlessly.',
                                  features: [
                                    'Dedicated Artist Shadowing & Liaison',
                                    'Technical Rider Fulfillment',
                                    'VIP Travel & Hospitality Logistics',
                                  ],
                                  delay: 200,
                                ),
                                _buildArtistCard(
                                  context, provider, 'crowd',
                                  title: 'VVIP Crowd Control',
                                  icon: Icons.security_rounded, // 🟢 Better icon logic
                                  description: 'Discreet yet unbreachable security tailored for high-profile talent, guaranteeing a safe, uninterrupted environment for performance.',
                                  features: [
                                    'Stage & Backstage Security Zones',
                                    'Green Room Access Control',
                                    'Safe Extraction & Entry Protocols',
                                  ],
                                  delay: 400,
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
  // 🌟 VVIP ARTIST CARD (Hover & Glow Optimized)
  // ==========================================
  Widget _buildArtistCard(BuildContext context, ThemeProvider provider, String id, {
    required String title,
    required IconData icon,
    required String description,
    required List<String> features,
    required int delay,
  }) {
    bool isCardHovered = false; 
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
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
              width: isMobile ? double.infinity : 480, // 🟢 Wider on desktop for better text flow
              padding: EdgeInsets.all(isMobile ? 30 : 50), // 🟢 Luxurious padding
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
                  const SizedBox(height: 30),
                  
                  // Title
                  _buildEditable(
                    context, provider, 'artist_card_${id}_title', title,
                    Text(
                      provider.elementSettings['artist_card_${id}_title_text'] ?? title,
                      style: AppTheme.getHeadingStyle(
                        fontSize: isMobile ? 26 : 30,
                        weight: FontWeight.w800,
                        color: provider.elementSettings['artist_card_${id}_title_color'] ?? (isCardHovered ? (AppTheme.enableGlow ? AppTheme.accent : AppTheme.textMain) : AppTheme.textMain), // 🟢 Text reacts to hover
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Description
                  _buildEditable(
                    context, provider, 'artist_card_${id}_desc', description,
                    Text(
                      provider.elementSettings['artist_card_${id}_desc_text'] ?? description,
                      style: AppTheme.getBodyStyle(
                        fontSize: 15,
                        weight: FontWeight.w500,
                        color: provider.elementSettings['artist_card_${id}_desc_color'] ?? AppTheme.textSub,
                      ).copyWith(height: 1.6),
                    ),
                  ),
                  
                  const SizedBox(height: 35),
                  Divider(color: AppTheme.accent.withValues(alpha: isCardHovered ? 0.3 : 0.1), thickness: isCardHovered ? 2 : 1), // 🟢 Line becomes stronger on hover
                  const SizedBox(height: 25),
                  
                  // Feature List
                  ...features.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String feature = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Icon(Icons.check_circle_rounded, size: 18, color: isCardHovered ? AppTheme.accent : AppTheme.textSub.withValues(alpha: 0.4)), // 🟢 Solid icon on hover
                          ), 
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildEditable(
                              context, provider, 'artist_card_${id}_feat_$idx', feature,
                              Text(
                                provider.elementSettings['artist_card_${id}_feat_${idx}_text'] ?? feature,
                                style: AppTheme.getBodyStyle(
                                  fontSize: 15,
                                  weight: isCardHovered ? FontWeight.w600 : FontWeight.w500, // 🟢 Bolder on hover
                                  color: provider.elementSettings['artist_card_${id}_feat_${idx}_color'] ?? (isCardHovered ? AppTheme.textMain.withValues(alpha: 0.9) : AppTheme.textSub),
                                ).copyWith(height: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }
      ),
      delay,
    );
  }  
}