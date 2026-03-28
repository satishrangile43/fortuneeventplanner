import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // ==========================================
  // 🛠️ THE MINI-EDITOR (CLICK-TO-EDIT POPUP)
  // ==========================================
  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    TextEditingController textCtrl = TextEditingController(
      text: provider.elementSettings['${elementKey}_text'] ?? defaultText
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.accent, width: 1), 
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()) // 🚀 ENGINE SYNC
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
              decoration: AppTheme.getFormInputDecoration("Text Content"), // 🚀 ENGINE SYNC
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
                  onTap: () => provider.updateElement('${elementKey}_color', c),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: c, border: Border.all(color: Colors.white38)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())), // 🚀 ENGINE SYNC
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
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius()), // 🚀 ENGINE SYNC
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
        return Scaffold(
          backgroundColor: provider.elementSettings['artist_bg_color'] ?? AppTheme.bg,
          body: MouseRegion(
            // 🚀 ENGINE SYNC: Custom Cursor Type
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.basic,
            child: Column(
              children: [
                const CustomNavbar(),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // --- PAGE HEADER ---
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 80,
                            vertical: 80,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.enableGradients ? null : AppTheme.cardBg.withValues(alpha: 0.3),
                            gradient: AppTheme.enableGradients ? LinearGradient(
                              colors: [
                                AppTheme.activeTheme == 'luxury' 
                                    ? Colors.deepPurple.shade900 
                                    : AppTheme.cardBg.withValues(alpha: 0.8), 
                                AppTheme.bg
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ) : null,
                          ),
                          child: Column(
                            children: [
                              _buildEditable(
                                context, provider, 'artist_title', 'Artist & Talent Management',
                                AppTheme.applyAnim(
                                  Text(
                                    provider.elementSettings['artist_title_text'] ?? 'Artist & Talent Management',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.getHeadingStyle(
                                      fontSize: isMobile ? 32 : 56,
                                      weight: FontWeight.bold,
                                      color: provider.elementSettings['artist_title_color'] ?? AppTheme.textMain, 
                                    ),
                                  ),
                                  100,
                                ),
                              ),
                              
                              const SizedBox(height: 15),
                              
                              _buildEditable(
                                context, provider, 'artist_subtitle', 'SEAMLESS COORDINATION & SPECIALIZED SECURITY FOR VIPS',
                                AppTheme.applyAnim(
                                  Text(
                                    provider.elementSettings['artist_subtitle_text'] ?? 'SEAMLESS COORDINATION & SPECIALIZED SECURITY FOR VIPS',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.getBodyStyle(
                                      fontSize: isMobile ? 12 : 16,
                                      weight: FontWeight.w600,
                                      color: provider.elementSettings['artist_subtitle_color'] ?? AppTheme.accent, 
                                    ).copyWith(letterSpacing: 3.0),
                                  ),
                                  300,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- MAIN CONTENT CARDS ---
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 80,
                            vertical: 60,
                          ),
                          child: Wrap(
                            spacing: 40,
                            runSpacing: 40,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildArtistCard(
                                context, provider, 'talent',
                                title: 'Talent Coordination',
                                icon: Icons.mic_external_on_outlined,
                                description: 'We provide seamless coordination between artists and event organizers ensuring all technical and hospitality riders are met with precision.',
                                features: [
                                  'Artist Liaison & Shadowing',
                                  'Technical Rider Management',
                                  'Hospitality & Travel Coordination',
                                ],
                                delay: 400,
                              ),
                              _buildArtistCard(
                                context, provider, 'crowd',
                                title: 'Crowd Control',
                                icon: Icons.groups_outlined,
                                description: 'Specialized security and crowd management for artist zones, ensuring a safe and controlled environment for talent and guests alike.',
                                features: [
                                  'Backstage Security',
                                  'Green Room Management',
                                  'Entry/Exit Point Control',
                                  'VVIP Zone Security',
                                ],
                                delay: 600,
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

  Widget _buildArtistCard(BuildContext context, ThemeProvider provider, String id, {
    required String title,
    required IconData icon,
    required String description,
    required List<String> features,
    required int delay,
  }) {
    bool isCardHovered = false; // Local state managed by MouseRegion inside State
    
    return AppTheme.applyAnim(
      StatefulBuilder(
        builder: (context, setCardState) {
          return MouseRegion(
            onEnter: (_) => setCardState(() => isCardHovered = true),
            onExit: (_) => setCardState(() => isCardHovered = false),
            // 🚀 ENGINE SYNC: Custom Cursor
            cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: Duration(milliseconds: AppTheme.durationMs), // 🚀 ENGINE SYNC: Duration
              width: 450, 
              padding: const EdgeInsets.all(40),
              // 🚀 ENGINE SYNC: UI Style & Shape
              decoration: AppTheme.getCardDecoration(isHovered: isCardHovered),
              // 🚀 ENGINE SYNC: Hover Transform (Tilt/Scale/Lift)
              transform: AppTheme.getHoverTransform(isCardHovered),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 35, color: AppTheme.accent),
                  ),
                  const SizedBox(height: 25),
                  
                  _buildEditable(
                    context, provider, 'artist_card_${id}_title', title,
                    Text(
                      provider.elementSettings['artist_card_${id}_title_text'] ?? title,
                      style: AppTheme.getHeadingStyle(
                        fontSize: 28,
                        weight: FontWeight.bold,
                        color: provider.elementSettings['artist_card_${id}_title_color'] ?? AppTheme.textMain,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  _buildEditable(
                    context, provider, 'artist_card_${id}_desc', description,
                    Text(
                      provider.elementSettings['artist_card_${id}_desc_text'] ?? description,
                      style: AppTheme.getBodyStyle(
                        fontSize: 15,
                        color: provider.elementSettings['artist_card_${id}_desc_color'] ?? AppTheme.textSub,
                      ).copyWith(height: 1.6),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  Divider(color: AppTheme.accent.withValues(alpha: 0.2)),
                  const SizedBox(height: 25),
                  
                  ...features.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String feature = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.star_rounded, size: 20, color: AppTheme.accent), 
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildEditable(
                              context, provider, 'artist_card_${id}_feat_$idx', feature,
                              Text(
                                provider.elementSettings['artist_card_${id}_feat_${idx}_text'] ?? feature,
                                style: AppTheme.getBodyStyle(
                                  fontSize: 15,
                                  weight: FontWeight.w500,
                                  color: provider.elementSettings['artist_card_${id}_feat_${idx}_color'] ?? AppTheme.textMain,
                                ),
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