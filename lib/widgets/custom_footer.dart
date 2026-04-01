import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../theme/app_theme.dart'; 

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  void _triggerSound() {
    if (AppTheme.enableSoundEffects) {
      if (AppTheme.soundPack == 'heavy') {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.selectionClick();
      }
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;
    bool isMinimal = AppTheme.footerStyle == 'minimal';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardBg, 
        border: Border(
          top: BorderSide(
            color: AppTheme.accent.withValues(alpha: 0.5), 
            width: 1.5,
          ),
        ),
        boxShadow: AppTheme.enableShadows ? [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, -5))
        ] : [],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 30 : 80,
              vertical: isMinimal ? 50 : 80, 
            ),
            // 🛠️ FIX: Agar mobile hai to strictly Column do (for perfect vertical stack), warna Wrap do for desktop
            child: isMobile 
              ? Column(
                  crossAxisAlignment: isMinimal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: _buildFooterContents(isMobile, isMinimal),
                )
              : Wrap(
                  spacing: 80, 
                  runSpacing: 50,
                  crossAxisAlignment: WrapCrossAlignment.start, 
                  alignment: isMinimal ? WrapAlignment.center : WrapAlignment.spaceBetween,
                  children: _buildFooterContents(isMobile, isMinimal),
                ),
          ),

          // ==========================================
          // 4. BOTTOM COPYRIGHT & DEVELOPER BAR
          // ==========================================
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: isMobile ? 20 : 50),
            color: AppTheme.bg, 
            child: isMobile 
              ? Column(
                  children: [
                    _buildCopyrightText(),
                    const SizedBox(height: 10),
                    _buildDeveloperText(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCopyrightText(),
                    _buildDeveloperText(),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  // 🛠️ FIX: Footer contents ko ek List me extract kar diya taaki dono (Mobile aur Desktop) me easily same items pass kar sakein bina code duplicate kiye
  List<Widget> _buildFooterContents(bool isMobile, bool isMinimal) {
    return [
      // ==========================================
      // 1. BRAND SECTION
      // ==========================================
      AppTheme.applyAnim(
        SizedBox(
          width: isMobile ? double.infinity : (isMinimal ? double.infinity : 320),
          child: Column(
            crossAxisAlignment: isMinimal || (isMobile && isMinimal) ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                'FORTUNE',
                style: AppTheme.getHeadingStyle(
                  fontSize: 32,
                  color: AppTheme.textMain, 
                  weight: FontWeight.bold,
                ).copyWith(letterSpacing: 4.0),
              ),
              Text(
                'EVENT PLANNER',
                style: AppTheme.getBodyStyle(
                  fontSize: 12,
                  color: AppTheme.accent, 
                  weight: FontWeight.w600,
                ).copyWith(letterSpacing: 6.0),
              ),
              const SizedBox(height: 25),
              Text(
                'The Ultimate Event Management.\nDelivering premium execution and unified staffing solutions across the industry.',
                textAlign: isMinimal || (isMobile && isMinimal) ? TextAlign.center : TextAlign.left,
                style: AppTheme.getBodyStyle(
                  color: AppTheme.textSub.withValues(alpha: 0.9),
                  fontSize: 14,
                ).copyWith(height: 1.6),
              ),
            ],
          ),
        ),
        100, 
      ),

      if (!isMinimal) ...[
        if (isMobile) const SizedBox(height: 40), // 🛠️ FIX: Mobile ke liye proper vertical spacing

        // ==========================================
        // 2. DIRECT CONTACTS SECTION
        // ==========================================
        AppTheme.applyAnim(
          SizedBox(
            width: isMobile ? double.infinity : 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONNECT', 
                  style: AppTheme.getBodyStyle(
                    fontSize: 15, 
                    color: AppTheme.textMain,
                    weight: FontWeight.bold,
                  ).copyWith(letterSpacing: 2.0),
                ),
                const SizedBox(height: 25),
                _buildContactRow('Kaushik Panjre', '+91 88891 55593', 'tel:+918889155593'),
                _buildContactRow('Meet Shah', '+91 76930 64811', 'tel:+917693064811'),
                _buildContactRow('Pushpendra Thakur', '+91 82249 68245', 'tel:+918224968245'),
              ],
            ),
          ),
          200, 
        ),

        if (isMobile) const SizedBox(height: 20), // 🛠️ FIX: Mobile ke liye proper vertical spacing

        // ==========================================
        // 3. ADDRESS & EMAIL SECTION
        // ==========================================
        AppTheme.applyAnim(
          SizedBox(
            width: isMobile ? double.infinity : 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HEADQUARTERS', 
                  style: AppTheme.getBodyStyle(
                    fontSize: 15, 
                    color: AppTheme.textMain,
                    weight: FontWeight.bold,
                  ).copyWith(letterSpacing: 2.0),
                ),
                const SizedBox(height: 25),
                _buildIconRow(
                  Icons.location_on_outlined, 
                  '152 Orbit Mall,\nVijay Nagar, Indore',
                  'https://maps.google.com/?q=152+Orbit+Mall,Vijay+Nagar,Indore'
                ),
                const SizedBox(height: 25),
                _buildIconRow(
                  Icons.email_outlined, 
                  'fortuneeventplanner1\n@gmail.com',
                  'mailto:fortuneeventplanner1@gmail.com'
                ),
              ],
            ),
          ),
          300, 
        ),
      ],
    ];
  }

  Widget _buildCopyrightText() {
    return Text(
      '© ${DateTime.now().year} Fortune Event Planner. All Rights Reserved.',
      textAlign: TextAlign.center,
      style: AppTheme.getBodyStyle(
        color: AppTheme.textSub.withValues(alpha: 0.8), 
        fontSize: 12,
      ).copyWith(letterSpacing: 0.5),
    );
  }

  Widget _buildDeveloperText() {
    return MouseRegion(
      cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _triggerSound();
          _launchURL('https://www.google.com/search?q=Satish+Rangile+Developer');
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTheme.getBodyStyle(
              color: AppTheme.textSub.withValues(alpha: 0.8), 
              fontSize: 12,
            ).copyWith(letterSpacing: 0.5),
            children: [
              const TextSpan(text: 'Developed by '),
              TextSpan(
                text: 'Satish Rangile',
                style: TextStyle(
                  color: AppTheme.accent, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(String name, String phone, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0), 
      child: MouseRegion(
        cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            _triggerSound();
            _launchURL(url); 
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: AppTheme.getBodyStyle(
                  color: AppTheme.textSub, 
                  fontSize: 11,
                  weight: FontWeight.w700,
                ).copyWith(letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: AppTheme.getBodyStyle(
                  color: AppTheme.accent, 
                  fontSize: 15,
                  weight: FontWeight.w600,
                ).copyWith(letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconRow(IconData icon, String text, String url) {
    return MouseRegion(
      cursor: AppTheme.cursorType == 'none' ? SystemMouseCursors.none : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _triggerSound();
          _launchURL(url);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.accent, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  text,
                  style: AppTheme.getBodyStyle(
                    color: AppTheme.textMain.withValues(alpha: 0.9), 
                    fontSize: 14,
                  ).copyWith(height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}