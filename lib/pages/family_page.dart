
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const List<Map<String, String>> familyMembers = [
    {'name': 'Lambert Kyeya', 'relationship': 'Père', 'initials': 'LK'},
    {'name': 'Kavira Margueritte', 'relationship': 'Mère', 'initials': 'KM'},
    {'name': 'Agano Luheka', 'relationship': 'Grande sœur', 'initials': 'AL'},
    {'name': 'Lavie Luheka', 'relationship': 'Grand frère', 'initials': 'LL'},
    {'name': 'Wassi Luheka', 'relationship': 'Grand frère', 'initials': 'WL'},
    {'name': 'Etienne Luheka', 'relationship': 'Grand frère', 'initials': 'EL'},
    {'name': 'Fidele Luheka', 'relationship': 'Petit frère', 'initials': 'FL'},
    {'name': 'Djoi Luheka', 'relationship': 'Petit frère', 'initials': 'DL'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              Icon(Icons.family_restroom, color: Colors.white, size: 55),
              SizedBox(height: 15),
              Text(
                'MA FAMILLE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Les personnes qui occupent une place importante dans ma vie.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 15),
              Chip(
                label: Text(
                  '8 membres',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'Les membres de ma famille',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 15),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 650 ? 3 : 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: familyMembers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final member = familyMembers[index];

                return FamilyMemberCard(
                  name: member['name']!,
                  relationship: member['relationship']!,
                  initials: member['initials']!,
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'La famille est une richesse précieuse.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relationship;
  final String initials;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.initials,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              relationship,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
