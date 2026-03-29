import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GitHubCMS {
  // 🔴 TERA PRIVATE DATA
  static const String owner = 'YOUR_GITHUB_USERNAME'; // Jaise: satishrangile43
  static const String repo = 'fortuneeventplanner';
  static const String path = 'settings.json'; 
  
  // 🔐 SECURE TOKEN: Ab token yahan rahega, UI se nahi aayega!
  // Yahan apna asli token daal dena
  static const String _secureToken = 'HIDDEN';

  // 🟢 FIX: Ab ye sirf 'settings' mangega, 'token' nahi mangega
  static Future<bool> publishToLive(Map<String, dynamic> settings) async {
    // 🛑 SECURITY CHECK: Sirf tu (developer) hi publish kar sakega. Live users ke liye disabled.
    if (!kDebugMode) {
      debugPrint("❌ SECURITY ALERT: Cannot publish from Production App.");
      return false; 
    }

    const String apiUrl = 'https://api.github.com/repos/$owner/$repo/contents/$path';

    try {
      final getRes = await http.get(Uri.parse(apiUrl));
      String sha = '';
      if (getRes.statusCode == 200) {
        sha = jsonDecode(getRes.body)['sha'];
      }

      final String base64Content = base64Encode(utf8.encode(jsonEncode(settings)));

      final putRes = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $_secureToken', // Ab token yahan se uthega
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "message": "Live Update from Custom CMS 🚀",
          "content": base64Content,
          if (sha.isNotEmpty) "sha": sha,
        }),
      );

      return putRes.statusCode == 200 || putRes.statusCode == 201;
    } catch (e) {
      debugPrint("❌ Publish Error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchLiveSettings() async {
    final String rawUrl = 'https://raw.githubusercontent.com/$owner/$repo/main/$path?v=${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      final res = await http.get(Uri.parse(rawUrl));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("❌ Fetch Error: $e");
    }
    return null;
  }
}