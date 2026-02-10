import 'package:url_launcher/url_launcher.dart';

class ContactServices {
  //gmail
  Future<void> openGmail({
    required String name,
    required String subject,
    required String body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'tharindunirmal1111@gmail.com',
      query: 'subject=$subject&body=Hi, My name is $name. $body',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not open email app';
    }
  }

  //telephone
  Future<void> openPhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+94703814047', // your number
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not open phone app';
    }
  }

  //whatsApp
  Future<void> openWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/94703814047?text=Hello%20there',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'WhatsApp not installed';
    }
  }
}
