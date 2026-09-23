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

  String _cleanCountryName(String country) {
    if (country.isEmpty) return 'Unknown';
    // Clean text before parentheses or extra details e.g. "United Kingdom (England)" -> "United Kingdom"
    final index = country.indexOf('(');
    String cleaned = index != -1 ? country.substring(0, index) : country;
    return cleaned.trim();
  }

  String _getCountryFlag(String country) {
    if (country.isEmpty) return '🐾';
    final lower = country.toLowerCase().trim();

    if (lower.contains('united kingdom') || lower.contains('uk') || lower.contains('england')) return '🇬🇧';
    if (lower.contains('united states') || lower.contains('usa')) return '🇺🇸';
    if (lower.contains('ethiopia')) return '🇪🇹';
    if (lower.contains('greece')) return '🇬🇷';
    if (lower.contains('thailand')) return '🇹🇭';
    if (lower.contains('russia')) return '🇷🇺';
    if (lower.contains('japan')) return '🇯🇵';
    if (lower.contains('egypt')) return '🇪🇬';
    if (lower.contains('france')) return '🇫🇷';
    if (lower.contains('turkey')) return '🇹🇷';
    if (lower.contains('canada')) return '🇨🇦';
    if (lower.contains('china')) return '🇨🇳';
    if (lower.contains('iran')) return '🇮🇷';
    if (lower.contains('burma') || lower.contains('myanmar')) return '🇲🇲';
    if (lower.contains('somalia')) return '🇸🇴';
    if (lower.contains('singapore')) return '🇸🇬';
    if (lower.contains('australia')) return '🇦🇺';
    if (lower.contains('isle of man')) return '🇮🇲';
    if (lower.contains('cyprus')) return '🇨🇾';
    if (lower.contains('brazil')) return '🇧🇷';
    if (lower.contains('germany')) return '🇩🇪';
    if (lower.contains('norway')) return '🇳🇴';
    if (lower.contains('sweden')) return '🇸🇪';
    if (lower.contains('ukraine')) return '🇺🇦';

    return '📍';
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
                            '$flag ${_cleanCountryName(widget.country)}',
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
                                runSpacing: 6,
                                children: [
                                  if (widget.coat.isNotEmpty)
                                    _buildChip(
                                      context,
                                      icon: Icons.texture_rounded,
                                      label: '${loc.coat}: ${loc.translateValue(widget.coat)}',
                                    ),
                                  if (widget.pattern.isNotEmpty)
                                    _buildChip(
                                      context,
                                      icon: Icons.category_rounded,
                                      label: '${loc.pattern}: ${loc.translateValue(widget.pattern)}',
                                    ),
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

  Widget _buildChip(BuildContext context, {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
