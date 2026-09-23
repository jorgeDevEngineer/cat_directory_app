import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../core/widgets/cat_image_helper.dart';

class BreedCard extends StatefulWidget {
  final String breedName;
  final String country;
  final String coat;
  final String pattern;
  final VoidCallback onTap;

  const BreedCard({
    super.key,
    required this.breedName,
    required this.country,
    required this.coat,
    required this.pattern,
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
    final flag = _getCountryFlag(widget.country);
    final loc = LocalizationService.instance;

    return MergeSemantics(
      child: Semantics(
        label: 'Raza ${widget.breedName} de ${loc.translateCountry(widget.country)}',
        button: true,
        hint: 'Toca para ver los detalles de esta raza',
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Cover Cat Image with Cache
                  Stack(
                    children: [
                      CatImageHelper.buildCardImage(
                        breedName: widget.breedName,
                        countryFlag: flag,
                        height: 180,
                        heroTag: 'avatar_${widget.breedName}',
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$flag ${loc.translateCountry(widget.country)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Card Info Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: 'name_${widget.breedName}',
                                flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: toHeroContext.widget,
                                  );
                                },
                                child: Text(
                                  widget.breedName,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  _buildChip(context, loc.translateValue(widget.coat)),
                                  _buildChip(context, loc.translateValue(widget.pattern)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
