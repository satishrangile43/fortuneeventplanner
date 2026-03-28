import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_navbar.dart';
import '../widgets/custom_footer.dart';
import '../theme/app_theme.dart'; // 🔥 THEME ENGINE IMPORTED
import '../theme/theme_provider.dart'; // 🚀 GOD MODE MEMORY

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

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

    // 🚀 ENGINE SYNC: Wrapped in Consumer
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // 🎨 ENGINE SYNC: Dynamic Background
          backgroundColor: provider.elementSettings['clients_bg_color'] ?? AppTheme.bg, 
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
                          vertical: 80, // Premium spacing
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🚀 1. EDITABLE TITLE
                            _buildEditable(
                              context, provider, 'clients_title', 'Who We Serve',
                              AppTheme.applyAnim(
                                Text(
                                  provider.elementSettings['clients_title_text'] ?? 'Who We Serve',
                                  style: AppTheme.getHeadingStyle(
                                    fontSize: isMobile ? 36 : 56,
                                    weight: FontWeight.bold,
                                    color: provider.elementSettings['clients_title_color'] ?? AppTheme.textMain, 
                                  ),
                                ),
                                100,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // 🚀 2. EDITABLE SUBTITLE
                            _buildEditable(
                              context, provider, 'clients_subtitle', 'Partnering with industry leaders to deliver flawless event execution.',
                              AppTheme.applyAnim(
                                Text(
                                  provider.elementSettings['clients_subtitle_text'] ?? 'Partnering with industry leaders to deliver flawless event execution.',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getBodyStyle(
                                    fontSize: isMobile ? 14 : 18,
                                    color: provider.elementSettings['clients_subtitle_color'] ?? AppTheme.accent, 
                                  ).copyWith(letterSpacing: 1.2),
                                ),
                                300,
                              ),
                            ),

                            const SizedBox(height: 80),

                            // Clients Grid
                            Wrap(
                              spacing: 25,
                              runSpacing: 25,
                              alignment: WrapAlignment.center,
                              children: List.generate(clientsList.length, (index) {
                                return _buildClientChip(context, provider, clientsList[index], index);
                              }),
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

  // Stylish Client Name Card with UI Style Engine
  Widget _buildClientChip(BuildContext context, ThemeProvider provider, String defaultName, int index) {
    return AppTheme.applyAnim(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        decoration: AppTheme.getCardDecoration(isHovered: false),
        // 🚀 3. EDITABLE CLIENT CHIP
        child: _buildEditable(
          context, provider, 'client_$index', defaultName,
          Text(
            (provider.elementSettings['client_${index}_text'] ?? defaultName).toString().toUpperCase(),
            style: AppTheme.getBodyStyle(
              fontSize: 14,
              weight: FontWeight.bold,
              color: provider.elementSettings['client_${index}_color'] ?? AppTheme.textMain, 
            ).copyWith(letterSpacing: 2.0),
          ),
        ),
      ),
      (index * 100) + 400, // Staggered delay for smooth entrance
    );
  }
}