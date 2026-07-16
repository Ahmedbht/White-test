import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../state/app_state.dart';
import '../widgets/pet_avatar.dart';

class PetSelectorScreen extends StatelessWidget {
  const PetSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return DecoratedBox(
      decoration: BoxDecoration(gradient: appState.backgroundTheme.gradient),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                'Choose your companion',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B4A75),
                    ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.85,
                ),
                itemCount: kPets.length,
                itemBuilder: (context, index) {
                  final pet = kPets[index];
                  final isSelected = pet.id == appState.selectedPet.id;
                  return _PetCard(
                    pet: pet,
                    isSelected: isSelected,
                    onTap: () => appState.selectPet(pet),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final Pet pet;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetCard({
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? const Color(0xFFE0559A) : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: pet.color.withValues(alpha: isSelected ? 0.6 : 0.3),
              blurRadius: isSelected ? 18 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PetAvatar(pet: pet, size: 84),
            const SizedBox(height: 14),
            Text(
              pet.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF6B4A75),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 6),
              const Icon(Icons.favorite, color: Color(0xFFE0559A), size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
