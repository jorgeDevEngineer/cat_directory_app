import 'package:flutter/material.dart';
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

    return MergeSemantics(
      child: Semantics(
        label: 'Raza ${widget.breedName} de ${widget.country}',
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Cat Photo Avatar with Fallback to Flag Emoji
                    CatImageHelper.buildAvatar(
                      breedName: widget.breedName,
                      countryFlag: flag,
                      size: 56,
                      heroTag: 'avatar_${widget.breedName}',
                    ),
                    const SizedBox(width: 16),
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$flag ${widget.country}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: [
                              _buildChip(context, widget.coat),
                              _buildChip(context, widget.pattern),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ExcludeSemantics(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
