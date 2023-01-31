import 'package:spacex_launch/helpers/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<void> launchWebUrl(String url) async {
    try {
      Uri _url = Uri.parse(url);
      Log.debug("launchUrl : $_url");

      if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
      }
    } catch (e) {
      Log.debug("launchUrl error $e");
    }
  }
}
