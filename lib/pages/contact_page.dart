import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        backgroundColor: Colors.black.withValues(alpha: 0.95), // 🟢 Better blur contrast
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5), 
          borderRadius: BorderRadius.circular(AppTheme.getGlobalRadius())
        ),
        title: Text("✏️ Edit Object", style: AppTheme.getHeadingStyle(fontSize: 18, color: Colors.white)),
        
        // 🛠️ FIX: Mobile Keyboard Overflow fix using SingleChildScrollView
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
                  ),
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
            color: Colors.pinkAccent.withValues(alpha: 0.05), // 🟢 Soft highlight
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
    bool isMobile = screenSize.width < 900; // 🟢 Breakpoint increased for better form rendering on tablets

    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MouseRegion(
          cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : 
                  AppTheme.cursorType == 'crosshair' ? SystemMouseCursors.precise : SystemMouseCursors.basic,
          child: Scaffold(
            backgroundColor: provider.elementSettings['contact_bg_color'] ?? AppTheme.bg,
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 80,
                              vertical: isMobile ? 60 : 100, // 🟢 Better padding for breathing room
                            ),
                            child: isMobile
                                // ==========================================
                                // 📱 MOBILE VIEW
                                // ==========================================
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildContactInfo(context, provider, isMobile),
                                      const SizedBox(height: 60), // 🟢 More spacing between text and form on mobile
                                      AppTheme.applyAnim(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                                          decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
                                            borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
                                          ),
                                          child: const ContactFormWidget(isMobile: true),
                                        ),
                                        300,
                                      ),
                                    ],
                                  )
                                // ==========================================
                                // 💻 DESKTOP VIEW
                                // ==========================================
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 🛠️ FIX: Distributes space perfectly
                                    children: [
                                      // LEFT SIDE: Contact Info
                                      Expanded(
                                        flex: 5, 
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 40.0), // 🛠️ FIX: Prevent text from touching the form
                                          child: _buildContactInfo(context, provider, isMobile),
                                        )
                                      ), 
                                      
                                      // RIGHT SIDE: Contact Form Box
                                      Expanded(
                                        flex: 6, // 🛠️ FIX: Slightly reduced form flex so it doesn't stretch too wide
                                        child: AppTheme.applyAnim(
                                          Container(
                                            padding: const EdgeInsets.all(50),
                                            decoration: AppTheme.getCardDecoration(isHovered: false).copyWith(
                                              borderRadius: BorderRadius.circular(AppTheme.borderStyle == 'sharp' ? 0 : AppTheme.getGlobalRadius()),
                                            ),
                                            child: const ContactFormWidget(isMobile: false),
                                          ),
                                          200, // 🚀 Faster desktop form load
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: isMobile ? 40 : 80),
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
  // 📝 CONTACT TEXT INFORMATION
  // ==========================================
  Widget _buildContactInfo(BuildContext context, ThemeProvider provider, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditable(
          context, provider, 'contact_title', "Let's\nConnect.",
          AppTheme.applyAnim(
            Text(
              provider.elementSettings['contact_title_text'] ?? "Let's\nConnect.",
              style: AppTheme.getHeadingStyle(
                fontSize: isMobile ? 52 : 82, // 🟢 Massive title
                weight: FontWeight.w800, // 🟢 Extra bold
                color: provider.elementSettings['contact_title_color'] ?? AppTheme.textMain, 
              ).copyWith(
                height: 1.0, 
                letterSpacing: -2.0, // 🟢 SaaS level kerning
                shadows: AppTheme.enableShadows ? [Shadow(color: AppTheme.textMain.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 15)] : []
              ),
            ),
            0,
          ),
        ),
        const SizedBox(height: 30),
        _buildEditable(
          context, provider, 'contact_subtitle', 'Ready to elevate your next event?\nContact our team for a premium consultation.', // 🟢 Better copy
          AppTheme.applyAnim(
            Text(
              provider.elementSettings['contact_subtitle_text'] ?? 'Ready to elevate your next event?\nContact our team for a premium consultation.',
              style: AppTheme.getBodyStyle(
                fontSize: isMobile ? 15 : 18,
                weight: FontWeight.w500,
                color: provider.elementSettings['contact_subtitle_color'] ?? AppTheme.textSub, 
              ).copyWith(height: 1.6),
            ),
            (AppTheme.transitionSpeed == 'fast' ? 50 : 150),
          ),
        ),
        const SizedBox(height: 60), // 🟢 Separator space
        
        // 🚀 Dynamic Staggered Details
        _buildDetailItem(context, provider, 'contact_1', 'HEAD OF OPERATIONS', 'Kaushik Panjre', '+91 91745 64996', 1),
        _buildDetailItem(context, provider, 'contact_2', 'LEAD LOGISTICS', 'Meet Shah', '+91 76930 64811', 2),
        _buildDetailItem(context, provider, 'contact_3', 'SECURITY CHIEF', 'Pushpendra Thakur', '+91 82249 68245', 3),
        const SizedBox(height: 20),
        _buildDetailItem(context, provider, 'contact_email', 'DIRECT INQUIRIES', 'EMAIL', 'fortuneeventplanner1@gmail.com', 4),
        _buildDetailItem(context, provider, 'contact_address', 'HEADQUARTERS', 'ADDRESS', '152 Orbit Mall, Vijay Nagar, Indore', 5),
      ],
    );
  }

  // ==========================================
  // 🟢 PREMIUM INFO ITEM (HOVERABLE)
  // ==========================================
  Widget _buildDetailItem(BuildContext context, ThemeProvider provider, String id, String badge, String title, String detail, int index) {
    int delayMultiplier = AppTheme.transitionSpeed == 'fast' ? 30 : (AppTheme.transitionSpeed == 'slow' ? 100 : 60);
    
    return AppTheme.applyAnim(
      _ContactInfoHoverWrapper(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35.0), // 🟢 More space between contacts
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtle Left Line Indicator
              Container(
                height: 45, width: 3,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small Badge (e.g. HEAD OF OPERATIONS)
                    Text(
                      badge,
                      style: AppTheme.getBodyStyle(
                        fontSize: 10,
                        weight: FontWeight.bold,
                        color: AppTheme.accent.withValues(alpha: .8), 
                      ).copyWith(letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 6),
                    
                    // Name
                    Text(
                      title.toUpperCase(),
                      style: AppTheme.getBodyStyle(
                        fontSize: 13,
                        weight: FontWeight.w700,
                        color: AppTheme.textSub, 
                      ).copyWith(letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    
                    // Value (Phone/Email)
                    _buildEditable(
                      context, provider, '${id}_detail', detail,
                      Text(
                        provider.elementSettings['${id}_detail_text'] ?? detail,
                        style: AppTheme.getBodyStyle(
                          fontSize: 18, // 🟢 Larger, more clickable looking text
                          weight: FontWeight.w600,
                          color: provider.elementSettings['${id}_detail_color'] ?? AppTheme.textMain, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      (index * delayMultiplier) + 200, // 🚀 Delayed after heading
    );
  }
}

// ==========================================
// 🖱️ HOVER ANIMATION WRAPPER FOR CONTACTS
// ==========================================
class _ContactInfoHoverWrapper extends StatefulWidget {
  final Widget child;
  const _ContactInfoHoverWrapper({required this.child});

  @override
  State<_ContactInfoHoverWrapper> createState() => _ContactInfoHoverWrapperState();
}

class _ContactInfoHoverWrapperState extends State<_ContactInfoHoverWrapper> {
  bool _isHovered = false;

  void _triggerSound() {
    if (AppTheme.enableSoundEffects && AppTheme.soundPack == 'clicky') {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _triggerSound();
      },
      onExit: (_) => setState(() => _isHovered = false),
      cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppTheme.transitionSpeed == 'fast' ? 150 : 300),
        curve: Curves.easeOutCubic,
        // 🟢 FIX: Beautiful subtle hover slide instead of full parallax
        transform: Matrix4.translationValues(_isHovered ? 10 : 0, 0, 0), 
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.accent.withValues(alpha: 0.05) : Colors.transparent, // Soft background highlight
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Added padding for the hover background
        child: widget.child,
      ),
    );
  }
}