import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _energyController = TextEditingController(text: '500');
  final _stepsController = TextEditingController(text: '10000');
  final _standController = TextEditingController(text: '12');
  final _sleepController = TextEditingController(text: '8');

  int _energyGoal = 500;
  int _stepsGoal = 10000;
  int _standGoal = 12;
  int _sleepGoal = 8;

  @override
  void dispose() {
    _energyController.dispose();
    _stepsController.dispose();
    _standController.dispose();
    _sleepController.dispose();
    super.dispose();
  }

  void _saveGoals() {
    setState(() {
      _energyGoal = int.tryParse(_energyController.text) ?? _energyGoal;
      _stepsGoal = int.tryParse(_stepsController.text) ?? _stepsGoal;
      _standGoal = int.tryParse(_standController.text) ?? _standGoal;
      _sleepGoal = int.tryParse(_sleepController.text) ?? _sleepGoal;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Goals updated successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Row(
                children: [
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
                  SizedBox(width: 30),
                  Text(
                    "Goals",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Set your daily movement and recovery targets to stay motivated.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 20),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current targets',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    _goalSummary('Active Energy', '$_energyGoal kcal'),
                    const SizedBox(height: 12),
                    _goalSummary('Steps', '$_stepsGoal steps'),
                    const SizedBox(height: 12),
                    _goalSummary('Stand', '$_standGoal hrs'),
                    const SizedBox(height: 12),
                    _goalSummary('Sleep', '$_sleepGoal hrs'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update goals',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    _goalField('Active energy', _energyController, 'kcal'),
                    const SizedBox(height: 12),
                    _goalField('Steps', _stepsController, 'steps'),
                    const SizedBox(height: 12),
                    _goalField('Stand hours', _standController, 'hrs'),
                    const SizedBox(height: 12),
                    _goalField('Sleep hours', _sleepController, 'hrs'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveGoals,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Text('Save goals'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalSummary(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textMuted)),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _goalField(
    String label,
    TextEditingController controller,
    String suffix,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: suffix,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }
}
