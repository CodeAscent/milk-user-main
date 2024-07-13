import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher {
  /// Launches the given [url] if it is valid and can be handled by the device.
  /// Returns `true` if the URL was launched successfully, otherwise `false`.
  Future<bool> launchURL(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
        return true;
      } catch (e) {
        debugPrint('Could not launch $url: $e');
        return false;
      }
    } else {
      debugPrint('Could not launch $url: Invalid URL');
      return false;
    }
  }
}
