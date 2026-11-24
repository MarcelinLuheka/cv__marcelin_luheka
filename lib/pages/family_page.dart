
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/app_colors.dart';
import '../services/family_service.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final FamilyService _familyService = FamilyService();

  List<dynamic> familyMembers = [];
  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  // CHARGER LES MEMBRES DEPUIS L'API
  Future<void> loadMembers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final members = await _familyService.getMembers();

      if (!mounted) return;

      setState(() {
        familyMembers = members;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // INITIALES DU MEMBRE
  String getInitials(Map<String, dynamic> member) {
    final firstName = member['prenom']?.toString() ?? '';
    final lastName = member['nom']?.toString() ?? '';

    return '${firstName.isNotEmpty ? firstName[0] : ''}'
        '${lastName.isNotEmpty ? lastName[0] : ''}'.toUpperCase();
  }

  // NOM COMPLET
  String getFullName(Map<String, dynamic> member) {
    return [
      member['prenom'],
      member['nom'],
      member['postnom'],
    ]
        .where((value) =>
            value != null && value.toString().isNotEmpty)
        .join(' ');
  }

  // TROUVER LA PHOTO LOCALE SELON LE PRENOM
  String? getPhotoPath(Map<String, dynamic> member) {
    final prenom =
        member['prenom']?.toString().toLowerCase().trim() ?? '';

    final normalizedName = prenom
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ï', 'i')
        .replaceAll('î', 'i');

    switch (normalizedName) {
      case 'lambert':
        return 'assets/images/famille/pere.jpg';

      case 'margueritte':
        return 'assets/images/famille/mere.jpg';

      case 'agano':
        return 'assets/images/famille/soeur-agano.jpg';

      case 'lavie':
        return 'assets/images/famille/frere-lavie.jpg';

      case 'wassi':
        return 'assets/images/famille/grand-frere-wassi.jpg';

      case 'etienne':
        return 'assets/images/famille/grand-frere-etienne.jpg';

      case 'fidele':
        return 'assets/images/famille/peti-frere-fidele.jpg';

      case 'djoi':
        return 'assets/images/famille/peti-frere-djoi.jpg';

      default:
        return null;
    }
  }

  // AJOUTER UN MEMBRE
  Future<void> addMember() async {
    final member = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddFamilyMemberDialog(),
    );

    if (member == null) return;

    final memberData = Map<String, dynamic>.from(member);
    final imagePath = memberData.remove('imagePath')?.toString();

    setState(() => isSaving = true);

    try {
      final result = imagePath != null
          ? await _familyService.addMemberWithImage(
              memberData,
              imagePath,
            )
          : await _familyService.addMember(memberData);

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre ajouté avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        await loadMembers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Impossible d’ajouter le membre.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  // MODIFIER UN MEMBRE
  Future<void> editMember(Map<String, dynamic> member) async {
    final updatedMember = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddFamilyMemberDialog(
        member: member,
      ),
    );

    if (updatedMember == null) return;

    final id = int.tryParse(member['id']?.toString() ?? '');

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identifiant du membre introuvable.'),
        ),
      );
      return;
    }

    final memberData = Map<String, dynamic>.from(updatedMember);
    final imagePath = memberData.remove('imagePath')?.toString();

    setState(() => isSaving = true);

    try {
      final result = imagePath != null
          ? await _familyService.updateMemberWithImage(
              id,
              memberData,
              imagePath,
            )
          : await _familyService.updateMember(
              id,
              memberData,
            );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre modifié avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        await loadMembers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Modification impossible.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  // SUPPRIMER UN MEMBRE
  Future<void> removeMember(Map<String, dynamic> member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(
          'Voulez-vous vraiment supprimer ${getFullName(member)} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final id = int.tryParse(member['id']?.toString() ?? '');

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identifiant du membre introuvable.'),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final result = await _familyService.deleteMember(id);

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre supprimé avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        await loadMembers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Suppression impossible.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  // INTERFACE PRINCIPALE
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadMembers,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.family_restroom,
                  color: Colors.white,
                  size: 55,
                ),
                const SizedBox(height: 15),
                const Text(
                  'MA FAMILLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Les personnes qui occupent une place importante dans ma vie.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
                Chip(
                  label: Text(
                    '${familyMembers.length} membre(s)',
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

          const SizedBox(height: 22),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isSaving ? null : addMember,
              icon: const Icon(Icons.person_add),
              label: Text(
                isSaving ? 'Enregistrement...' : 'Ajouter un membre',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            )
          else if (errorMessage != null)
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Impossible de charger les membres.\n$errorMessage',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loadMembers,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          else if (familyMembers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Aucun membre enregistré pour le moment.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns =
                    constraints.maxWidth >= 650 ? 3 : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: familyMembers.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final member = familyMembers[index]
                        as Map<String, dynamic>;

                    return FamilyMemberCard(
                      name: getFullName(member),
                      relationship:
                          member['parente']?.toString() ?? '',
                      initials: getInitials(member),
                      imagePath: getPhotoPath(member),
                      imageUrl: member['image_url']?.toString(),
                      onEdit: isSaving
                          ? null
                          : () => editMember(member),
                      onDelete: isSaving
                          ? null
                          : () => removeMember(member),
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
      ),
    );
  }
}

// FORMULAIRE D'AJOUT ET DE MODIFICATION

class AddFamilyMemberDialog extends StatefulWidget {
  final Map<String, dynamic>? member;

  const AddFamilyMemberDialog({
    super.key,
    this.member,
  });

  @override
  State<AddFamilyMemberDialog> createState() =>
      _AddFamilyMemberDialogState();
}

class _AddFamilyMemberDialogState
    extends State<AddFamilyMemberDialog> {
  final _formKey = GlobalKey<FormState>();

  final nomController = TextEditingController();
  final postnomController = TextEditingController();
  final prenomController = TextEditingController();
  final lieuController = TextEditingController();
  final dateController = TextEditingController();
  final parenteController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? selectedImage;

  @override
  void initState() {
    super.initState();

    final member = widget.member;

    if (member != null) {
      nomController.text = member['nom']?.toString() ?? '';
      postnomController.text =
          member['postnom']?.toString() ?? '';
      prenomController.text =
          member['prenom']?.toString() ?? '';
      lieuController.text =
          member['lieu_naissance']?.toString() ?? '';
      dateController.text =
          member['date_naissance']?.toString().split('T').first ?? '';
      parenteController.text =
          member['parente']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    postnomController.dispose();
    prenomController.dispose();
    lieuController.dispose();
    dateController.dispose();
    parenteController.dispose();
    super.dispose();
  }

  // CHOISIR UNE PHOTO DEPUIS LA GALERIE
  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image != null && mounted) {
        setState(() {
          selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de sélectionner la photo : $e'),
        ),
      );
    }
  }

  // CALENDRIER
  Future<void> selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Date de naissance',
    );

    if (selectedDate != null) {
      dateController.text =
          '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }

  // CHAMPS DU FORMULAIRE
  Widget buildField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  // APERCU DE LA PHOTO
  Widget buildImagePreview() {
    final imageUrl = widget.member?['image_url']?.toString();

    Widget imageWidget;

    if (selectedImage != null) {
      imageWidget = Image.file(
        File(selectedImage!.path),
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.person,
            size: 55,
            color: AppColors.primary,
          );
        },
      );
    } else {
      imageWidget = const Icon(
        Icons.person,
        size: 55,
        color: AppColors.primary,
      );
    }

    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 110,
            height: 110,
            color: AppColors.primary.withValues(alpha: 0.10),
            child: imageWidget,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.photo_library),
          label: const Text('Choisir une photo'),
        ),
        if (selectedImage != null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                selectedImage = null;
              });
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Annuler la nouvelle photo',
              style: TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ENREGISTRER
  void saveMember() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      {
        'nom': nomController.text.trim(),
        'postnom': postnomController.text.trim(),
        'prenom': prenomController.text.trim(),
        'lieu_naissance': lieuController.text.trim(),
        'date_naissance': dateController.text.trim(),
        'parente': parenteController.text.trim(),
        if (selectedImage != null)
          'imagePath': selectedImage!.path,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.member != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Modifier un membre' : 'Ajouter un membre',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildImagePreview(),

                buildField('Nom', nomController),
                buildField('Postnom', postnomController),
                buildField('Prénom', prenomController),
                buildField('Lieu de naissance', lieuController),
                buildField(
                  'Date de naissance',
                  dateController,
                  readOnly: true,
                  onTap: selectDate,
                ),
                buildField('Parenté', parenteController),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: saveMember,
          child: Text(isEditing ? 'Modifier' : 'Enregistrer'),
        ),
      ],
    );
  }
}

// CARTE D'UN MEMBRE

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relationship;
  final String initials;
  final String? imagePath;
  final String? imageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.initials,
    required this.imagePath,
    this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  // PHOTO DE SECOURS : INITIALES
  Widget buildInitials() {
    return CircleAvatar(
      radius: 35,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // AFFICHER LA PHOTO OU LES INITIALES
  Widget buildMemberPhoto() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return SizedBox(
        width: 70,
        height: 70,
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return buildLocalOrInitials();
            },
          ),
        ),
      );
    }

    return buildLocalOrInitials();
  }

  // PHOTO LOCALE OU INITIALES
  Widget buildLocalOrInitials() {
    if (imagePath == null) {
      return buildInitials();
    }

    return SizedBox(
      width: 70,
      height: 70,
      child: ClipOval(
        child: Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return buildInitials();
          },
        ),
      ),
    );
  }

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
            buildMemberPhoto(),

            const SizedBox(height: 12),

            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              relationship,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  tooltip: 'Modifier',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'Supprimer',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
