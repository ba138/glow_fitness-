import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass_card.dart';
import '../home_shell.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key, this.isOnboarding = false});

  final bool isOnboarding;

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profile = Get.put(ProfileController());

  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _ageController;
  late HeightUnit _heightUnit;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _profile.name.value);
    _weightController = TextEditingController(text: _profile.formattedWeight);
    _heightController = TextEditingController(text: _profile.formattedHeight);
    _ageController = TextEditingController(text: '${_profile.age.value}');
    _heightUnit = _profile.heightUnit.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _profile.updateProfile(
      newName: _nameController.text,
      newWeight: double.parse(_weightController.text),
      newHeight: double.parse(_heightController.text),
      newHeightUnit: _heightUnit,
      newAge: int.parse(_ageController.text),
    );

    if (!mounted) {
      return;
    }

    if (widget.isOnboarding) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, _, _) => const HomeShell(),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile details updated')));
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isOnboarding,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AuroraBackground(
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                _header(context),
                const SizedBox(height: 20),
                GlassCard(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.42),
                      AppColors.accent.withValues(alpha: 0.22),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.accentGradient,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          widget.isOnboarding
                              ? 'Add your details so Glow Fitness can personalize your dashboard.'
                              : 'Keep your personal stats current for better workout guidance.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal details',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _textField(
                          label: 'Name',
                          controller: _nameController,
                          icon: Icons.badge_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _textField(
                          label: 'Weight',
                          controller: _weightController,
                          icon: Icons.monitor_weight_rounded,
                          suffix: 'kg',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _positiveNumberValidator,
                        ),
                        const SizedBox(height: 14),
                        _heightUnitSelector(),
                        const SizedBox(height: 10),
                        _textField(
                          label: 'Height',
                          controller: _heightController,
                          icon: Icons.height_rounded,
                          suffix: _heightUnit == HeightUnit.cm ? 'cm' : 'ft',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _positiveNumberValidator,
                        ),
                        const SizedBox(height: 14),
                        _textField(
                          label: 'Age',
                          controller: _ageController,
                          icon: Icons.cake_rounded,
                          suffix: 'yrs',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final age = int.tryParse(value ?? '');
                            if (age == null || age <= 0) {
                              return 'Enter a valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        GlassCard(
                          onTap: _saveDetails,
                          borderRadius: 16,
                          gradient: AppColors.primaryGradient,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Center(
                            child: Text(
                              widget.isOnboarding ? 'Continue' : 'Save details',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        if (!widget.isOnboarding) ...[
          GlassCard(
            padding: const EdgeInsets.all(10),
            borderRadius: 16,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
        Text(
          widget.isOnboarding ? 'Tell Us About You' : 'Profile Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _heightUnitSelector() {
    return Row(
      children: [
        const Text('Height unit', style: TextStyle(color: AppColors.textMuted)),
        const Spacer(),
        SegmentedButton<HeightUnit>(
          segments: const [
            ButtonSegment(value: HeightUnit.cm, label: Text('cm')),
            ButtonSegment(value: HeightUnit.ft, label: Text('ft')),
          ],
          selected: {_heightUnit},
          showSelectedIcon: false,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return AppColors.textMuted;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary.withValues(alpha: 0.65);
              }
              return Colors.white.withValues(alpha: 0.08);
            }),
            side: WidgetStateProperty.all(
              BorderSide(color: Colors.white.withValues(alpha: 0.12)),
            ),
          ),
          onSelectionChanged: (value) {
            setState(() => _heightUnit = value.first);
          },
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.textMuted),
        suffixText: suffix,
        suffixStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
        errorStyle: const TextStyle(color: AppColors.amber),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
      ),
    );
  }

  String? _positiveNumberValidator(String? value) {
    final number = double.tryParse(value ?? '');
    if (number == null || number <= 0) {
      return 'Enter a valid number';
    }
    return null;
  }
}
