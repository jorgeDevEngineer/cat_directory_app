import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../breeds/domain/entities/breed.dart';
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

  @override
  Widget build(BuildContext context) {
    final breed = widget.breed;

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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Header
            Center(
              child: Hero(
                tag: 'avatar_${widget.breedName}',
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🐱', style: TextStyle(fontSize: 44)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Breed info cards
            if (breed != null) ...[
              _buildInfoRow(Icons.public_rounded, 'País de Origen', breed.country),
              _buildInfoRow(Icons.history_edu_rounded, 'Origen', breed.origin),
              _buildInfoRow(Icons.texture_rounded, 'Pelaje (Coat)', breed.coat),
              _buildInfoRow(Icons.category_rounded, 'Patrón (Pattern)', breed.pattern),
            ],

            const SizedBox(height: 24),

            // Random Fact Section with Cubit
            BlocBuilder<BreedDetailCubit, BreedDetailState>(
              bloc: _cubit,
              builder: (context, state) {
                return FactCard(
                  isLoading: state is BreedDetailFactLoading,
                  fact: state is BreedDetailFactLoaded ? state.fact : null,
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
                label: const Text('Obtener otro Dato Curioso'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
