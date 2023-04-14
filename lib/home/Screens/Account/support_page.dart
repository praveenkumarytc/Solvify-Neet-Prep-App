import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/Utils/images.dart';
import 'package:shield_neet/providers/auth_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shield_neet/components/solvify_appbar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  final String email = 'solvifyneetprepapp@gmail.com';
  final String phone = '9361906094';

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(emailLaunchUri);
  }

  Future<void> _sendWhatsApp(BuildContext context) async {
    var userName = Provider.of<AuthProvider>(context, listen: false).fullName;
    String message = "Hello! Solvify Team,\n\n"
        "I am $userName\n";
    final String url = 'whatsapp://send?phone=+91$phone&text=$message';
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: 'Support'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => _sendWhatsApp(context),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Images.whatsapp_logo,
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '+91 $phone',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _sendEmail,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.mail_outline,
                      color: ColorResources.PRIMARY_MATERIAL,
                      size: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'If you have any questions or feedback, please feel free to reach out to us using the above contact details.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: ColorResources.BLACK),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
