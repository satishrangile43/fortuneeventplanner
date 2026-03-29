import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/service_card.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🚀 THE THEME ENGINE
import '../theme/theme_provider.dart'; // 🚀 THE GOD MODE MEMORY

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

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
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()) // 🟢 FIX: Sync radius with global
        ),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        
        // 🛠️ FIX: Wrapped in SingleChildScrollView so Mobile Keyboard doesn't cause Pixel Overflow
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Text Editor
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
                onChanged: (val) => provider.updateElement('${elementKey}_text', val), // 🚀 Live Update
              ),
              const SizedBox(height: 25),
              
              // 2. Color Picker (Presets)
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
                    // 🚀 ENGINE SYNC: Custom Cursor 
                    cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _triggerSound();
                        provider.updateElement('${elementKey}_color', c); // 🚀 Live Update
                      },
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, 
                          color: c, 
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          // 🟢 FIX: Indicator if selected
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

              // 3. Reset Button
              Center(
                child: MouseRegion(
                  // 🚀 ENGINE SYNC: Custom Cursor
                  cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _triggerSound();
                      provider.clearElementSetting('${elementKey}_text');
                      provider.clearElementSetting('${elementKey}_color');
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                    label: const Text("Reset to Theme Default", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            // 🚀 ENGINE SYNC: Custom Cursor
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
      // 🚀 ENGINE SYNC: Editable Mode Hover
      cursor: SystemMouseCursors.text,
      child: GestureDetector(
        onTap: () => _showObjectEditor(context, provider, key, defaultText), 
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent, width: 2, style: BorderStyle.solid), // 🔴 Pink Outline Indicator
            color: Colors.pinkAccent.withValues(alpha: 0.05), // 🟢 FIX: Very soft highlight so text is readable
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // 🟢 FIX: Horizontal breathing room
          child: child,
        ),
      ),
    );
  }

  // ==========================================
  // 🏗️ MAIN PAGE BUILDER
  // ==========================================
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isMobile = screenSize.width < 800;

    // 🚀 WRAP WITH CONSUMER
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // 🎨 Background Color Dynamic - Fallback to AppTheme.bg
          backgroundColor: provider.elementSettings['services_bg_color'] ?? AppTheme.bg, 
          
          body: MouseRegion(
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : 
                    AppTheme.cursorType == 'crosshair' ? SystemMouseCursors.precise : SystemMouseCursors.basic,
            child: Container(
              // 🚀 ENGINE SYNC: Dynamic Background Pattern Engine (Gradient/Mesh)
              decoration: AppTheme.getBackgroundDecoration(),
              child: Column(
                children: [
                  
                  // ==========================================
                  // 🧩 TOP NAVBAR
                  // ==========================================
                  if (AppTheme.navbarStyle != 'hidden') const CustomNavbar(),
                  
                  // ==========================================
                  // 📜 SCROLLABLE CONTENT
                  // ==========================================
                  Expanded(
                    child: SingleChildScrollView(
                      // 🚀 ENGINE SYNC: Smooth vs Fixed scrolling behaviour
                      physics: AppTheme.scrollEffect == 'bouncy' ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) : const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          // ==========================================
                          // --- PAGE HEADER (ANIMATED & PREMIUM) ---
                          // ==========================================
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 80,
                              vertical: isMobile ? 60 : 100, // 🟢 FIX: More breathing room on desktop
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.enableGradients ? LinearGradient(
                                colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.5), Colors.transparent], // 🟢 FIX: Smoother fade out
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ) : null,
                              color: !AppTheme.enableGradients ? Colors.transparent : null,
                            ),
                            child: Column(
                              children: [
                                // 🚀 1. EDITABLE TITLE
                                _buildEditable(
                                  context, provider, 'services_title', 'Our Expertise', // 🟢 FIX: Better default copy
                                  AppTheme.applyAnim(
                                    Text(
                                      provider.elementSettings['services_title_text'] ?? 'Our Expertise',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.getHeadingStyle(
                                        fontSize: isMobile ? 38 : 64, // 🟢 FIX: God-Tier massive desktop text
                                        weight: FontWeight.w800,
                                        color: provider.elementSettings['services_title_color'] ?? AppTheme.textMain,
                                      ).copyWith(
                                        letterSpacing: -1.0, // 🟢 FIX: Tighter kerning looks more modern
                                        shadows: AppTheme.enableShadows ? [Shadow(color: AppTheme.textMain.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 15)] : [],
                                      ),
                                    ),
                                    0,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // 🚀 2. EDITABLE SUBTITLE
                                _buildEditable(
                                  context, provider, 'services_subtitle', 'Comprehensive event management and unified operational support tailored to your absolute needs.',
                                  AppTheme.applyAnim(
                                    Container(
                                      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700), // 🟢 FIX: Stop subtitle from stretching too wide
                                      child: Text(
                                        provider.elementSettings['services_subtitle_text'] ?? 'Comprehensive event management and unified operational support tailored to your absolute needs.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 15 : 18, // 🟢 FIX: More readable size
                                          color: provider.elementSettings['services_subtitle_color'] ?? AppTheme.textSub, // 🟢 FIX: TextSub blends better than Accent here
                                          weight: FontWeight.w500,
                                        ).copyWith(letterSpacing: 0.5, height: 1.6),
                                      ),
                                    ),
                                    (AppTheme.transitionSpeed == 'fast' ? 50 : 200), // 🚀 ENGINE SYNC: Dynamic stagger
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ==========================================
                          // --- SERVICES GRID (DYNAMIC POWERED BY APP_THEME) ---
                          // ==========================================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 60,
                              vertical: 20,
                            ),
                            child: Wrap(
                              spacing: AppTheme.layoutStyle == 'dense' ? 20 : 40, // 🟢 FIX: Sync with Layout Style
                              runSpacing: AppTheme.layoutStyle == 'dense' ? 30 : 50,
                              alignment: WrapAlignment.center,
                              children: AppTheme.servicesData.asMap().entries.map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                
                                // 🚀 ENGINE SYNC: Intelligent dynamic staggering for grids
                                int delayMultiplier = AppTheme.transitionSpeed == 'fast' ? 30 : (AppTheme.transitionSpeed == 'slow' ? 150 : 80);
                                int dynamicDelay = (index % 4) * delayMultiplier;

                                return ServiceCard(
                                  title: data['title'],
                                  description: data['description'],
                                  delay: dynamicDelay,
                                  images: List<String>.from(data['images']), 
                                );
                              }).toList(),
                            ),
                          ),
                          
                          // ==========================================
                          // 🧩 BOTTOM FOOTER
                          // ==========================================
                          SizedBox(height: isMobile ? 60 : 100), // 🟢 FIX: Extra scroll room before footer
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
      },
    );
  }
}