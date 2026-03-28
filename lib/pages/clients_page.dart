import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  // Card-wise hover state management for interactive transforms
  int? hoveredIndex;

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
        backgroundColor: Colors.black.withValues(alpha: 0.95), // 🟢 Clearer background
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

    final List<String> clientsList = [
      'Event Management Companies',
      'Wedding Planners',
      'Corporate Event Agencies',
      'Brand Activation Companies',
      'Exhibition & Expo Organizers',
      'Production Houses',
      'Hospitality Partners',
      'Private Concierge Services',
    ];

    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MouseRegion(
          cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : 
                  AppTheme.cursorType == 'crosshair' ? SystemMouseCursors.precise : SystemMouseCursors.basic,
          child: Scaffold(
            backgroundColor: provider.elementSettings['clients_bg_color'] ?? AppTheme.bg, 
            body: Container(
              decoration: AppTheme.getBackgroundDecoration(), // 🌟 Apply Global Background Pattern
              child: Column(
                children: [
                  if (AppTheme.navbarStyle != 'hidden') const CustomNavbar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AppTheme.scrollEffect == 'bouncy' 
                          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) 
                          : const ClampingScrollPhysics(), // ⚡ ENGINE SYNC: Scroll Style
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
                                colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.5), Colors.transparent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ) : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 🚀 1. EDITABLE TITLE
                                _buildEditable(
                                  context, provider, 'clients_title', 'Trusted By The Best', // 🟢 Premium Copy
                                  AppTheme.applyAnim(
                                    Text(
                                      provider.elementSettings['clients_title_text'] ?? 'Trusted By The Best',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.getHeadingStyle(
                                        fontSize: isMobile ? 38 : 64, // 🟢 Massive Desktop Impact
                                        weight: FontWeight.w800,
                                        color: provider.elementSettings['clients_title_color'] ?? AppTheme.textMain, 
                                      ).copyWith(
                                        letterSpacing: -1.0, // Modern kerning
                                        shadows: AppTheme.enableShadows ? [Shadow(color: AppTheme.textMain.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 15)] : []
                                      ),
                                    ),
                                    0,
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // 🚀 2. EDITABLE SUBTITLE
                                _buildEditable(
                                  context, provider, 'clients_subtitle', 'Partnering with industry leaders to deliver flawless event execution globally.',
                                  AppTheme.applyAnim(
                                    Container(
                                      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700), // 🟢 Control wide screens
                                      child: Text(
                                        provider.elementSettings['clients_subtitle_text'] ?? 'Partnering with industry leaders to deliver flawless event execution globally.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 15 : 18,
                                          weight: FontWeight.w500,
                                          color: provider.elementSettings['clients_subtitle_color'] ?? AppTheme.textSub, // 🟢 TextSub is better than Accent here
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
                          // --- CLIENTS GRID SECTION ---
                          // ==========================================
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 60,
                            ),
                            child: Wrap(
                              spacing: AppTheme.layoutStyle == 'dense' ? 15 : 25, // 🟢 Adaptive Spacing
                              runSpacing: AppTheme.layoutStyle == 'dense' ? 15 : 25,
                              alignment: WrapAlignment.center,
                              children: List.generate(clientsList.length, (index) {
                                return _buildClientChip(context, provider, clientsList[index], index, isMobile);
                              }),
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
  // 🏢 PREMIUM CLIENT CHIP (Hover Optimized)
  // ==========================================
  Widget _buildClientChip(BuildContext context, ThemeProvider provider, String defaultName, int index, bool isMobile) {
    bool isThisHovered = hoveredIndex == index;
    
    // 🚀 ENGINE SYNC: Wave staggered animation based on index
    int delayMultiplier = AppTheme.transitionSpeed == 'fast' ? 30 : (AppTheme.transitionSpeed == 'slow' ? 100 : 50);
    int staggeredDelay = (index * delayMultiplier) + 200;

    return AppTheme.applyAnim(
      MouseRegion(
        cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => hoveredIndex = index);
          if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky') HapticFeedback.selectionClick();
        },
        onExit: (_) => setState(() => hoveredIndex = null),
        child: AnimatedContainer(
          duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300),
          curve: Curves.easeOutCubic,
          transform: AppTheme.getHoverTransform(isThisHovered),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 40, vertical: isMobile ? 15 : 25), // 🟢 Bigger targets on desktop
          decoration: AppTheme.getCardDecoration(isHovered: isThisHovered).copyWith(
            borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius() * 1.5), // 🟢 Pill/Oval style looks better for chips
            // 🟢 Add subtle glow on hover
            boxShadow: AppTheme.enableShadows && isThisHovered 
                ? [BoxShadow(color: AppTheme.accent.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 8))] 
                : AppTheme.getCardDecoration(isHovered: isThisHovered).boxShadow,
          ),
          child: _buildEditable(
            context, provider, 'client_$index', defaultName,
            Row(
              mainAxisSize: MainAxisSize.min, // Wrap around content
              children: [
                // 🟢 Animated subtle dot indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isThisHovered ? (AppTheme.enableGlow ? Colors.white : AppTheme.accent) : AppTheme.accent.withValues(alpha: 0.5),
                    boxShadow: (AppTheme.enableGlow && isThisHovered) ? [BoxShadow(color: AppTheme.accent, blurRadius: 10)] : []
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  (provider.elementSettings['client_${index}_text'] ?? defaultName).toString().toUpperCase(),
                  style: AppTheme.getBodyStyle(
                    fontSize: isMobile ? 12 : 14,
                    weight: isThisHovered ? FontWeight.w800 : FontWeight.w600, // 🟢 Bolder on hover
                    // 🟢 Proper inverted colors if 'solid' style is used
                    color: provider.elementSettings['client_${index}_color'] ?? 
                          (isThisHovered && AppTheme.globalUIStyle == 'solid' ? AppTheme.bg : AppTheme.textMain), 
                  ).copyWith(letterSpacing: 2.0),
                ),
              ],
            ),
          ),
        ),
      ),
      staggeredDelay,
    );
  }
}