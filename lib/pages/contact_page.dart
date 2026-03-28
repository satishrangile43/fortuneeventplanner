import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Hamare banaye hue Custom Widgets aur Theme Engine
import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../widgets/contact_form.dart'; 
import '../theme/app_theme.dart'; // 🔥 ASLI POWER
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

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
              maxLines: 3,
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
    bool isMobile = screenSize.width < 850;

    // 🚀 ENGINE SYNC: Wrap with Consumer
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // 🎨 ENGINE SYNC: Dynamic Background with local override support
          backgroundColor: provider.elementSettings['contact_bg_color'] ?? AppTheme.bg,
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
                          horizontal: isMobile ? 20 : 80,
                          vertical: 80, // Thoda extra premium padding
                        ),
                        child: isMobile
                            ? Column(
                                children: [
                                  _buildContactInfo(context, provider, isMobile),
                                  const SizedBox(height: 50),
                                  // 🚀 ENGINE SYNC: Form Container with UI Style Engine
                                  Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: AppTheme.getCardDecoration(isHovered: false),
                                    child: const ContactFormWidget(isMobile: true),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Side: Text & Contact Details
                                  Expanded(flex: 1, child: _buildContactInfo(context, provider, isMobile)),
                                  const SizedBox(width: 80),
                                  // Right Side: Form Container with UI Style Engine
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(50),
                                      // 🚀 ENGINE SYNC: UI Style Engine (Glass, Flat, etc.)
                                      decoration: AppTheme.getCardDecoration(isHovered: false),
                                      child: const ContactFormWidget(isMobile: false),
                                    ),
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

  // Left Side (Contact Details)
  Widget _buildContactInfo(BuildContext context, ThemeProvider provider, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🚀 ENGINE SYNC: Editable Title
        _buildEditable(
          context, provider, 'contact_title', "Let's\nConnect.",
          AppTheme.applyAnim(
            Text(
              provider.elementSettings['contact_title_text'] ?? "Let's\nConnect.",
              style: AppTheme.getHeadingStyle(
                fontSize: isMobile ? 56 : 82,
                weight: FontWeight.bold,
                color: provider.elementSettings['contact_title_color'] ?? AppTheme.textMain, 
              ).copyWith(height: 1.0),
            ),
            100,
          ),
        ),
        
        const SizedBox(height: 30),
        
        // 🚀 ENGINE SYNC: Editable Subtitle
        _buildEditable(
          context, provider, 'contact_subtitle', 'Ready to elevate your next event?\nContact our team for a consultation.',
          AppTheme.applyAnim(
            Text(
              provider.elementSettings['contact_subtitle_text'] ?? 'Ready to elevate your next event?\nContact our team for a consultation.',
              style: AppTheme.getBodyStyle(
                fontSize: isMobile ? 16 : 18,
                color: provider.elementSettings['contact_subtitle_color'] ?? AppTheme.textSub, 
              ).copyWith(height: 1.6),
            ),
            300,
          ),
        ),

        const SizedBox(height: 50),

        _buildDetailItem(context, provider, 'contact_1', 'KAUSHIK PANJRE', '+91 91745 64996', 400),
        _buildDetailItem(context, provider, 'contact_2', 'MEET SHAH', '+91 7693064811', 500),
        _buildDetailItem(context, provider, 'contact_3', 'PUSHPENDRA THAKUR', '+91 8224968245', 600),
        
        const SizedBox(height: 20),
        
        _buildDetailItem(context, provider, 'contact_email', 'EMAIL', 'fortuneeventplanner1@gmail.com', 700),
        _buildDetailItem(context, provider, 'contact_address', 'ADDRESS', '152 orbit mall vijay nagar indore', 800),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, ThemeProvider provider, String id, String title, String detail, int delay) {
    return AppTheme.applyAnim(
      Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.getBodyStyle(
                fontSize: 12,
                weight: FontWeight.bold,
                color: AppTheme.accent.withValues(alpha: .7), 
              ).copyWith(letterSpacing: 3.0),
            ),
            const SizedBox(height: 8),
            // 🚀 ENGINE SYNC: Editable Detail Text
            _buildEditable(
              context, provider, '${id}_detail', detail,
              Text(
                provider.elementSettings['${id}_detail_text'] ?? detail,
                style: AppTheme.getBodyStyle(
                  fontSize: 17,
                  weight: FontWeight.w500,
                  color: provider.elementSettings['${id}_detail_color'] ?? AppTheme.textMain, 
                ),
              ),
            ),
          ],
        ),
      ),
      delay,
    );
  }
}