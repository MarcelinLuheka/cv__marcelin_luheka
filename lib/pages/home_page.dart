
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mon Curriculum Vitae',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // IDENTITE
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // PHOTO DE PROFIL
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/famille/moi-marcelin.jpg',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'ML',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'MARCELIN LUHEKA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Étudiant en informatique',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Réseaux et télécommunications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Goma, République démocratique du Congo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const CVSection(
            title: 'PROFIL PROFESSIONNEL',
            icon: Icons.person_outline,
            content:
                'Étudiant en informatique à l’Institut Supérieur '
                'd’Informatique et de Gestion (ISIG Goma), '
                'spécialisé en réseaux et télécommunications.\n\n'
                'Passionné par les technologies numériques, '
                'le développement informatique et les systèmes '
                'de communication. Doté d’un esprit d’initiative, '
                'd’une bonne capacité d’apprentissage et d’un '
                'intérêt particulier pour les projets '
                'communautaires et technologiques.',
          ),

          const CVSection(
            title: 'FORMATION ACADÉMIQUE',
            icon: Icons.school_outlined,
            content:
                'INSTITUT SUPÉRIEUR D’INFORMATIQUE ET DE GESTION '
                '(ISIG GOMA)\n\n'
                'Domaine : Informatique\n'
                'Spécialité : Réseaux et télécommunications\n'
                'Situation : Études en cours.',
          ),

          const CVSection(
            title: 'EXPÉRIENCES ET PROJETS',
            icon: Icons.work_outline,
            content:
                '1. ENGAGEMENT ASSOCIATIF – ETIMARKI\n'
                '• Participation aux initiatives de développement '
                'communautaire.\n'
                '• Contribution aux projets de formation et '
                'd’accompagnement des jeunes.\n'
                '• Participation à la préparation et à '
                'l’organisation des activités associatives.\n\n'
                '2. PROJET COMMUNAUTAIRE – MAX CHESS CLUB\n'
                '• Participation au développement d’un club '
                'd’échecs à Goma.\n'
                '• Contribution à l’organisation des activités '
                'et rencontres.\n'
                '• Participation à la recherche de partenariats '
                'et de collaborations.\n\n'
                '3. PROJETS INFORMATIQUES PERSONNELS\n'
                '• Initiation au développement d’applications '
                'avec Python et Flutter.\n'
                '• Création et gestion de bases de données SQL.\n'
                '• Installation et configuration '
                'd’environnements informatiques.',
          ),

          const CVSection(
            title: 'COMPÉTENCES TECHNIQUES',
            icon: Icons.computer,
            content:
                '• Réseaux informatiques et télécommunications\n'
                '• Configuration et maintenance informatique\n'
                '• Programmation Python et Flutter\n'
                '• Gestion des bases de données SQL\n'
                '• Administration Linux et Windows\n'
                '• Virtualisation avec VMware\n'
                '• Création de sites web avec WordPress\n'
                '• Microsoft Word, Excel et PowerPoint',
          ),

          const CVSection(
            title: 'COMPÉTENCES LINGUISTIQUES',
            icon: Icons.language,
            content:
                '• Swahili : Courant\n'
                '• Esperanto : Courant\n'
                '• Français : Courant\n'
                '• Anglais : Courant\n'
                '• Allemand : Courant',
          ),

          const CVSection(
            title: 'CENTRES D’INTÉRÊT',
            icon: Icons.favorite_outline,
            content:
                '• Informatique et nouvelles technologies\n'
                '• Musique et pratique du violon\n'
                '• Jeux d’échecs et stratégie\n'
                '• Apprentissage des langues étrangères\n'
                '• Lecture et écriture\n'
                '• Engagement communautaire',
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              '© 2026 MARCELIN LUHEKA',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// WIDGET REUTILISABLE POUR LES SECTIONS DU CV

class CVSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const CVSection({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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
                  size: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.8,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
