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
  // 🛠️ THE MINI-EDITOR (CLICK-TO-EDIT POPUP)
  // ==========================================
  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    // 🔊 ENGINE SYNC: Haptic feedback on open
    if (AppTheme.enableSoundEffects) HapticFeedback.lightImpact();

    TextEditingController textCtrl = TextEditingController(
      text: provider.elementSettings['${elementKey}_text'] ?? defaultText
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.accent, width: 1), 
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()) // 📏 ENGINE SYNC: Global Radius
        ),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              minLines: 1,
              decoration: AppTheme.getFormInputDecoration("Text Content"), // 📝 ENGINE SYNC: Form Style
              onChanged: (val) => provider.updateElement('${elementKey}_text', val),
            ),
            const SizedBox(height: 20),
            
            Text("Select Color:", style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white54)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Colors.white, Colors.black, AppTheme.accent, Colors.blueAccent, 
                Colors.redAccent, Colors.greenAccent, Colors.purpleAccent, Colors.orangeAccent
              ].map((c) => 
                GestureDetector(
                  onTap: () {
                    provider.updateElement('${elementKey}_color', c);
                    if (AppTheme.enableSoundEffects) HapticFeedback.selectionClick();
                  },
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      color: c, 
                      border: Border.all(color: Colors.white38),
                      boxShadow: AppTheme.enableGlow ? [BoxShadow(color: c.withValues(alpha: .5), blurRadius: 8)] : [] // ✨ ENGINE SYNC: Glow
                    ),
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 25),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.clearElementSetting('${elementKey}_text');
                  provider.clearElementSetting('${elementKey}_color');
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                label: const Text("Reset", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()))
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: Text("DONE", style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold))
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

    return GestureDetector(
      onTap: () => _showObjectEditor(context, provider, key, defaultText),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pinkAccent, width: 2, style: BorderStyle.solid), 
          color: Colors.pinkAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()),
        ),
        padding: const EdgeInsets.all(4),
        child: child,
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
          cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.basic,
          child: Scaffold(
            backgroundColor: provider.elementSettings['security_bg_color'] ?? AppTheme.bg, 
            body: Column(
              children: [
                const CustomNavbar(), 
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: AppTheme.scrollEffect == 'smooth' 
                        ? const BouncingScrollPhysics() 
                        : const ClampingScrollPhysics(), // ⚡ ENGINE SYNC: Scroll Style
                    child: Column(
                      children: [
                        // --- PAGE HEADER SECTION ---
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 80,
                            vertical: 80, 
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.enableGradients ? null : AppTheme.cardBg.withValues(alpha: 0.3),
                            gradient: AppTheme.enableGradients ? LinearGradient(
                              colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.3)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ) : null,
                          ),
                          child: Column(
                            children: [
                              // 🚀 1. EDITABLE TITLE
                              _buildEditable(
                                context, provider, 'security_title', 'Security & Staff',
                                AppTheme.applyAnim(
                                  Text(
                                    provider.elementSettings['security_title_text'] ?? 'Security & Staff',
                                    style: AppTheme.getHeadingStyle(
                                      fontSize: isMobile ? 36 : 56,
                                      weight: FontWeight.bold,
                                      color: provider.elementSettings['security_title_color'] ?? AppTheme.textMain,
                                    ),
                                  ),
                                  100, // Speed managed by AppTheme.durationMs internally
                                ),
                              ),
                              
                              const SizedBox(height: 15),
                              
                              // 🚀 2. EDITABLE SUBTITLE
                              _buildEditable(
                                context, provider, 'security_subtitle', 'ENSURING SAFETY, ORDER, AND SEAMLESS SUPPORT FOR YOUR EVENT',
                                AppTheme.applyAnim(
                                  Text(
                                    provider.elementSettings['security_subtitle_text'] ?? 'ENSURING SAFETY, ORDER, AND SEAMLESS SUPPORT FOR YOUR EVENT',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.getBodyStyle(
                                      fontSize: isMobile ? 12 : 16,
                                      weight: FontWeight.w600,
                                      color: provider.elementSettings['security_subtitle_color'] ?? AppTheme.accent, 
                                    ).copyWith(letterSpacing: 3.0),
                                  ),
                                  300,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- CONTENT SECTION ---
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 80,
                            vertical: 80,
                          ),
                          child: Wrap(
                            spacing: 40,
                            runSpacing: 40,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildSecurityCard(
                                context, provider, 'guard', 
                                'Security Guards',
                                Icons.security_outlined,
                                [
                                  'Venue safety & surveillance',
                                  'Access control and crowd supervision',
                                  'Gate management',
                                  'Guest safety monitoring',
                                ],
                                100,
                              ),
                              _buildSecurityCard(
                                context, provider, 'bouncer', 
                                'Bouncers',
                                Icons.shield_outlined,
                                [
                                  'High-crowd management',
                                  'VIP protection',
                                  'Stage and backstage security',
                                  'Emergency response support',
                                ],
                                200,
                              ),
                              _buildSecurityCard(
                                context, provider, 'porter', 
                                'Porters / Helpers',
                                Icons.people_outline,
                                [
                                  'Setup & dismantle support',
                                  'Equipment and material handling',
                                  'Backstage & logistic assistance',
                                ],
                                300,
                              ),
                            ],
                          ),
                        ),

                        const CustomFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

 // --- Updated Card Widget with Fixed Logic ---
  Widget _buildSecurityCard(BuildContext context, ThemeProvider provider, String id, String defaultTitle, IconData icon, List<String> points, int delay) {
    bool isHovered = false; // 👈 FIX: Builder ke bahar define kiya

    return StatefulBuilder(
      builder: (context, setState) {
        return AppTheme.applyAnim(
          MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            // 🖱️ ENGINE SYNC: Custom Cursor
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: Duration(milliseconds: AppTheme.durationMs), // ⏳ ENGINE SYNC: Speed
              width: 350,
              padding: const EdgeInsets.all(35),
              decoration: AppTheme.getCardDecoration(isHovered: isHovered),
              transform: AppTheme.getHoverTransform(isHovered), // 🌟 ENGINE SYNC: Hover Transform
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // ✨ ENGINE SYNC: Glow effect on icon
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accent.withValues(alpha: .1),
                          boxShadow: (AppTheme.enableGlow && isHovered) 
                              ? [BoxShadow(color: AppTheme.accent.withValues(alpha: .3), blurRadius: 15)] 
                              : []
                        ),
                        child: Icon(icon, size: 35, color: AppTheme.accent),
                      ), 
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildEditable(
                          context, provider, 'security_card_${id}_title', defaultTitle,
                          Text(
                            provider.elementSettings['security_card_${id}_title_text'] ?? defaultTitle,
                            style: AppTheme.getHeadingStyle(
                              fontSize: 24,
                              weight: FontWeight.bold,
                              color: provider.elementSettings['security_card_${id}_title_color'] ?? AppTheme.textMain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Divider(color: AppTheme.accent.withValues(alpha: 0.2)),
                  const SizedBox(height: 25),
                  ...points.map((point) => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.verified_user_rounded, 
                                 size: 18, 
                                 color: AppTheme.accent.withValues(alpha: 0.7)), 
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                point,
                                style: AppTheme.getBodyStyle(
                                  fontSize: 15,
                                  color: AppTheme.textSub,
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
          delay,
        );
      }
    );
  }
}