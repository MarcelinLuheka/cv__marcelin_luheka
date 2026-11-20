
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _openLink(
    BuildContext context,
    Uri url,
  ) async {
    final success = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d’ouvrir cette application.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'luhekamarcelin@gmail.com',
      queryParameters: {
        'subject': 'Prise de contact',
      },
    );

    final whatsappUri = Uri.parse(
      'https://wa.me/243992764367',
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Mes contacts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.contact_mail,
                  color: Colors.white,
                  size: 60,
                ),
                SizedBox(height: 18),
                Text(
                  'RESTONS EN CONTACT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Je serais heureux d’échanger avec vous '
                  'pour toute question, proposition ou collaboration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'MES COORDONNÉES',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          // CONTACT PAR EMAIL
          _ContactCard(
            icon: Icons.email_outlined,
            title: 'Adresse e-mail',
            value: 'luhekamarcelin@gmail.com',
            buttonText: 'Envoyer un e-mail',
            onTap: () => _openLink(context, emailUri),
          ),

          const SizedBox(height: 16),

          // CONTACT PAR WHATSAPP
          _ContactCard(
            icon: Icons.chat,
            title: 'WhatsApp',
            value: '+243 992 764 367',
            buttonText: 'Me contacter sur WhatsApp',
            onTap: () => _openLink(context, whatsappUri),
          ),

          const SizedBox(height: 35),

          const Center(
            child: Text(
              'Merci de votre visite !',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String buttonText;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTap,
                icon: Icon(icon),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
