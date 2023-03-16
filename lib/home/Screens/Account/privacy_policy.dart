import 'package:flutter/material.dart';
import 'package:shield_neet/components/solvify_appbar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SolvifyAppbar(title: 'Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Introduction',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We take your privacy seriously and are committed to protecting your personal information. This policy explains how we collect, use, and protect your data.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              Text(
                'What information we collect',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We collect the following types of information:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Personal information such as name, email address, and phone number',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Information about your device such as the operating system and browser type',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              Text(
                'How we use your information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We use your information to:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Provide and improve our services',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Communicate with you about your account and any issues that arise',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Personalize your experience',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              Text(
                'How we protect your information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We take appropriate measures to protect your information from unauthorized access or disclosure. This includes:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Encrypting sensitive data',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '- Regularly monitoring our systems for vulnerabilities',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              Text(
                'Changes to this policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We may update this policy from time to time. We will notify you of any significant changes by email or by posting a notice.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
