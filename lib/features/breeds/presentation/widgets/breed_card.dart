import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/breed.dart';

class BreedCard extends StatefulWidget {
  final Breed breed;
  final VoidCallback onTap;

  const BreedCard({
    super.key,
    required this.breed,
    required this.onTap,
  });

  @override
  State<BreedCard> createState() => _BreedCardState();
}

class _BreedCardState extends State<BreedCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  String _getCountryFlag(String country) {
    if (country.isEmpty) return '🐾';
    switch (country.toLowerCase()) {
      case 'ethiopia':
        return '🇪🇹';
      case 'greece':
        return '🇬🇷';
      case 'united states':
      case 'usa':
        return '🇺🇸';
      case 'united kingdom':
      case 'uk':
        return '🇬🇧';
      case 'thailand':
        return '🇹🇭';
      case 'russia':
        return '🇷🇺';
      case 'japan':
        return '🇯🇵';
      case 'egypt':
        return '🇪🇬';
      case 'france':
        return '🇫🇷';
      case 'turkey':
        return '🇹🇷';
      default:
        return '📍';
    }
  }

  @override
  Widget build(BuildContext context) {
    final flag = _getCountryFlag(widget.breed.country);

    return Semantics(
      label: 'Raza ${widget.breed.breed}, País ${widget.breed.country}',
      button: true,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) {
          _scaleController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _scaleController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar / Icon with Hero animation tag
                  Hero(
                    tag: 'avatar_${widget.breed.breed}',
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryLight, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero tag on breed name
                        Hero(
                          tag: 'name_${widget.breed.breed}',
                          flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                            return Material(
                              color: Colors.transparent,
                              child: toHeroContext.widget,
                            );
                          },
                          child: Text(
                            widget.breed.breed,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$flag ${widget.breed.country}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          children: [
                            _buildChip(widget.breed.coat),
                            _buildChip(widget.breed.pattern),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
