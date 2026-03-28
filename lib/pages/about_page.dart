import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 ASLI SHAKTI
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
        shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme.accent, width: 1), borderRadius: BorderRadius.circular(15)),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white),
              maxLines: 4, // 🚀 Quote thoda lamba ho sakta hai
              minLines: 1,
              decoration: InputDecoration(
                labelText: "Text Content",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withValues(alpha: 0.8)),
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
          borderRadius: BorderRadius.circular(8),
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

    // 🚀 ENGINE SYNC: Provider Wrapper
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // 🎨 ENGINE SYNC: Dynamic Background with Global Override Support
          backgroundColor: provider.elementSettings['about_bg_color'] ?? AppTheme.bg,
          body: Column(
            children: [
              const CustomNavbar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 100,
                          vertical: 80,
                        ),
                        child: Column(
                          children: [
                            // 🚀 1. EDITABLE PAGE TITLE
                            _buildEditable(
                              context, provider, 'about_title', 'About Fortune',
                              AppTheme.applyAnim(
                                Text(
                                  provider.elementSettings['about_title_text'] ?? 'About Fortune',
                                  style: AppTheme.getHeadingStyle(
                                    fontSize: isMobile ? 36 : 56,
                                    weight: FontWeight.bold,
                                    color: provider.elementSettings['about_title_color'] ?? AppTheme.textMain,
                                  ),
                                ),
                                100,
                              ),
                            ),
                            
                            const SizedBox(height: 50),
                            
                            // --- Main Quote / Vision Container ---
                            AppTheme.applyAnim(
                              Container(
                                padding: EdgeInsets.all(isMobile ? 30 : 50),
                                // 🚀 ENGINE SYNC: UI Style Engine 
                                decoration: AppTheme.getCardDecoration(isHovered: false),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.format_quote_rounded, 
                                      size: 60, 
                                      color: AppTheme.accent.withValues(alpha: 0.6)
                                    ),
                                    const SizedBox(height: 30),
                                    
                                    // 🚀 2. EDITABLE QUOTE
                                    _buildEditable(
                                      context, provider, 'about_quote', 'To strengthen event companies by delivering reliable manpower and operational support that improves coordination, enhances guest experience, and maintains safety.',
                                      Text(
                                        provider.elementSettings['about_quote_text'] ?? 'To strengthen event companies by delivering reliable manpower and operational support that improves coordination, enhances guest experience, and maintains safety.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 18 : 24,
                                          weight: FontWeight.w500,
                                          color: provider.elementSettings['about_quote_color'] ?? AppTheme.textMain,
                                        ).copyWith(height: 1.6),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 40),
                                    Divider(
                                      color: AppTheme.accent.withValues(alpha: 0.2), 
                                      indent: 50, 
                                      endIndent: 50
                                    ),
                                    const SizedBox(height: 40),
                                    
                                    // 🚀 3. EDITABLE DESCRIPTION
                                    _buildEditable(
                                      context, provider, 'about_desc', 'We aim to simplify event execution by providing trained professionals capable of handling every segment of event management with discipline and efficiency.',
                                      Text(
                                        provider.elementSettings['about_desc_text'] ?? 'We aim to simplify event execution by providing trained professionals capable of handling every segment of event management with discipline and efficiency.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.getBodyStyle(
                                          fontSize: isMobile ? 14 : 17,
                                          color: provider.elementSettings['about_desc_color'] ?? AppTheme.textSub,
                                        ).copyWith(height: 1.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
        );
      }
    );
  }
}