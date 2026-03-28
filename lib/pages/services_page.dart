import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/service_card.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🚀 THE THEME ENGINE
import '../theme/theme_provider.dart'; // 🚀 THE GOD MODE MEMORY

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  // ==========================================
  // 🛠️ THE MINI-EDITOR (CLICK-TO-EDIT POPUP)
  // ==========================================
  void _showObjectEditor(BuildContext context, ThemeProvider provider, String elementKey, String defaultText) {
    // Current value uthao (agar pehle se edit hua hai toh wo, nahi toh default)
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
            // 1. Text Editor
            TextField(
              controller: textCtrl,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                labelText: "Text Content",
                labelStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (val) => provider.updateElement('${elementKey}_text', val), // 🚀 Live Update
            ),
            const SizedBox(height: 20),
            
            // 2. Color Picker (Presets)
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
                  onTap: () => provider.updateElement('${elementKey}_color', c), // 🚀 Live Update
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: c, border: Border.all(color: Colors.white38)),
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 25),

            // 3. Reset Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  provider.clearElementSetting('${elementKey}_text');
                  provider.clearElementSetting('${elementKey}_color');
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                label: const Text("Reset to Theme Default", style: TextStyle(color: Colors.white)),
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
    if (!provider.isSelectionMode) return child; // Agar God mode off hai, toh normal widget dikhao

    return GestureDetector(
      onTap: () => _showObjectEditor(context, provider, key, defaultText), // Click karne par editor khulega
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.pinkAccent, width: 2, style: BorderStyle.solid), // 🔴 Pink Outline Indicator
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

    // 🚀 WRAP WITH CONSUMER
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // 🎨 Background Color Dynamic
          backgroundColor: provider.elementSettings['services_bg_color'] ?? AppTheme.bg, 
          
          body: Column(
            children: [
              const CustomNavbar(),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- PAGE HEADER (ANIMATED) ---
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 80,
                          vertical: 80,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.enableGradients ? LinearGradient(
                            colors: [AppTheme.bg, AppTheme.cardBg.withValues(alpha: 0.5)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ) : null,
                          color: !AppTheme.enableGradients ? AppTheme.bg : null,
                        ),
                        child: Column(
                          children: [
                            
                            // 🚀 1. EDITABLE TITLE
                            _buildEditable(
                              context, provider, 'services_title', 'Our Services',
                              AppTheme.applyAnim(
                                Text(
                                  provider.elementSettings['services_title_text'] ?? 'Our Services',
                                  style: AppTheme.getHeadingStyle(
                                    fontSize: isMobile ? 36 : 56,
                                    weight: FontWeight.bold,
                                    color: provider.elementSettings['services_title_color'] ?? AppTheme.textMain,
                                  ),
                                ),
                                0,
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                            
                            // 🚀 2. EDITABLE SUBTITLE
                            _buildEditable(
                              context, provider, 'services_subtitle', 'Comprehensive event management and operational support tailored to your needs.',
                              AppTheme.applyAnim(
                                Text(
                                  provider.elementSettings['services_subtitle_text'] ?? 'Comprehensive event management and operational support tailored to your needs.',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getBodyStyle(
                                    fontSize: isMobile ? 14 : 16,
                                    color: provider.elementSettings['services_subtitle_color'] ?? AppTheme.accent, 
                                  ).copyWith(letterSpacing: 1.5),
                                ),
                                200,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- SERVICES GRID (DYNAMIC POWERED BY APP_THEME) ---
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 80,
                          vertical: 40,
                        ),
                        child: Wrap(
                          spacing: 30,
                          runSpacing: 40,
                          alignment: WrapAlignment.center,
                          children: AppTheme.servicesData.map((data) {
                            return ServiceCard(
                              title: data['title'],
                              description: data['description'],
                              delay: data['delay'] ?? 100,
                              images: List<String>.from(data['images']), 
                            );
                          }).toList(),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      const CustomFooter(),   
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}