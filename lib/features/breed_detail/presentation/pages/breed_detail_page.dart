import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../core/widgets/cat_image_helper.dart';
import '../../../breeds/domain/entities/breed.dart';
import '../cubit/breed_detail_cubit.dart';
import '../cubit/breed_detail_state.dart';
import '../widgets/fact_card.dart';

class BreedDetailPage extends StatefulWidget {
  final String breedName;
  final Breed? breed;

  const BreedDetailPage({
    super.key,
    required this.breedName,
    this.breed,
  });

  @override
  State<BreedDetailPage> createState() => _BreedDetailPageState();
}

class _BreedDetailPageState extends State<BreedDetailPage> {
  late BreedDetailCubit _cubit;
  final loc = LocalizationService.instance;

  @override
  void initState() {
    super.initState();
    _cubit = BreedDetailCubit(factRepository: getIt());
    _cubit.loadRandomFact();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _cleanCountryName(String country) {
    if (country.isEmpty) return 'Unknown';
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
    final breed = widget.breed;
    final flag = breed != null ? _getCountryFlag(breed.country) : '🐾';

    return ListenableBuilder(
      listenable: loc,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Hero(
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CatImageHelper.buildAvatar(
                    breedName: widget.breedName,
                    countryFlag: flag,
                    size: 110,
                    heroTag: 'avatar_${widget.breedName}',
                  ),
                ),
                const SizedBox(height: 24),

                if (breed != null) ...[
                  _buildInfoRow(context, Icons.public_rounded, loc.countryOfOrigin, _cleanCountryName(breed.country)),
                  _buildInfoRow(context, Icons.history_edu_rounded, loc.origin, loc.translateValue(breed.origin)),
                  _buildInfoRow(context, Icons.texture_rounded, loc.coat, loc.translateValue(breed.coat)),
                  _buildInfoRow(context, Icons.category_rounded, loc.pattern, loc.translateValue(breed.pattern)),
                ],

                const SizedBox(height: 24),

                BlocBuilder<BreedDetailCubit, BreedDetailState>(
                  bloc: _cubit,
                  builder: (context, state) {
                    return FactCard(
                      isLoading: state is BreedDetailFactLoading,
                      factText: state is BreedDetailFactLoaded ? state.fact.fact : null,
                      errorMessage: state is BreedDetailFactError ? state.message : null,
                      onRetry: () => _cubit.loadRandomFact(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _cubit.loadRandomFact(),
                    icon: const Icon(Icons.casino_rounded),
                    label: Text(loc.getAnotherFact),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
          const SizedBox(width: 14),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
