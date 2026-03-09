import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final encodedMessage = message != null
          ? Uri.encodeComponent(message)
          : '';

      final Uri whatsappUri = Uri.parse(
        'whatsapp://send?phone=$cleanPhone${encodedMessage.isNotEmpty ? '&text=$encodedMessage' : ''}',
      );

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        return true;
      }

      final Uri webWhatsappUri = Uri.parse(
        'https://wa.me/$cleanPhone${encodedMessage.isNotEmpty ? '?text=$encodedMessage' : ''}',
      );

      if (await canLaunchUrl(webWhatsappUri)) {
        await launchUrl(webWhatsappUri, mode: LaunchMode.externalApplication);
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> contactEngineer({
    required String engineerName,
    required String engineerPhone,
    String? projectDetails,
  }) async {
    var message =
        'Hi $engineerName,\n\n'
        'I found your profile on the Engineer Connect app and would like to discuss a project with you.\n\n';

    if (projectDetails != null && projectDetails.isNotEmpty) {
      message += 'Project Details:\n$projectDetails\n\n';
    }

    message += 'Looking forward to hearing from you!';

    return openWhatsApp(phoneNumber: engineerPhone, message: message);
  }

  static Future<bool> contactConstructor({
    required String constructorName,
    required String constructorPhone,
    String? requestDetails,
  }) async {
    var message =
        'Hi $constructorName,\n\n'
        'I found your profile on the Constructor Connect app and would like to discuss my construction needs.\n\n';

    if (requestDetails != null && requestDetails.isNotEmpty) {
      message += 'Request Details:\n$requestDetails\n\n';
    }

    message += 'Looking forward to your response!';

    return openWhatsApp(phoneNumber: constructorPhone, message: message);
  }
}
