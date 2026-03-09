import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

/// WhatsApp Helper - Opens WhatsApp with pre-filled message
class WhatsAppHelper {
  /// Opens WhatsApp with the given phone number and optional message
  /// 
  /// Parameters:
  /// - [phoneNumber]: Phone number in international format (e.g., +91XXXXXXXXXX)
  /// - [message]: Optional pre-filled message text
  /// 
  /// Returns: true if WhatsApp was opened successfully, false otherwise
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      // Clean phone number (remove spaces, dashes, etc.)
      String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      // Encode message for URL
      String encodedMessage = message != null 
          ? Uri.encodeComponent(message) 
          : '';
      
      // Try WhatsApp app scheme first (better for mobile)
      final Uri whatsappUri = Uri.parse(
        'whatsapp://send?phone=$cleanPhone${encodedMessage.isNotEmpty ? '&text=$encodedMessage' : ''}'
      );
      
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        return true;
      }
      
      // Fallback to web.whatsapp.com (works everywhere)
      final Uri webWhatsappUri = Uri.parse(
        'https://wa.me/$cleanPhone${encodedMessage.isNotEmpty ? '?text=$encodedMessage' : ''}'
      );
      
      if (await canLaunchUrl(webWhatsappUri)) {
        await launchUrl(webWhatsappUri, mode: LaunchMode.externalApplication);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
      return false;
    }
  }
  
  /// Opens WhatsApp for an engineer with a pre-filled enquiry message
  static Future<bool> contactEngineer({
    required String engineerName,
    required String engineerPhone,
    String? projectDetails,
  }) async {
    String message = 'Hi $engineerName,\n\n'
        'I found your profile on the Engineer Connect app and would like to discuss a project with you.\n\n';
    
    if (projectDetails != null && projectDetails.isNotEmpty) {
      message += 'Project Details:\n$projectDetails\n\n';
    }
    
    message += 'Looking forward to hearing from you!';
    
    return openWhatsApp(
      phoneNumber: engineerPhone,
      message: message,
    );
  }
  
  /// Opens WhatsApp for a constructor with a pre-filled request message
  static Future<bool> contactConstructor({
    required String constructorName,
    required String constructorPhone,
    String? requestDetails,
  }) async {
    String message = 'Hi $constructorName,\n\n'
        'I found your profile on the Constructor Connect app and would like to discuss my construction needs.\n\n';
    
    if (requestDetails != null && requestDetails.isNotEmpty) {
      message += 'Request Details:\n$requestDetails\n\n';
    }
    
    message += 'Looking forward to your response!';
    
    return openWhatsApp(
      phoneNumber: constructorPhone,
      message: message,
    );
  }
}
