import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme/app_colors.dart';
import '../../data/models/cat_fact_model.dart';

class FactCard extends StatelessWidget {
  final bool isLoading;
  final CatFactModel? fact;
  final String? errorMessage;
  final VoidCallback onRetry;

  const FactCard({
    super.key,
    required this.isLoading,
    this.fact,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Dato Curioso Aleatorio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const Divider(color: AppColors.border, height: 24),
          if (isLoading) _buildShimmer(context),
          if (!isLoading && errorMessage != null) _buildError(context),
          if (!isLoading && fact != null) _buildFactText(context, fact!.fact),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 14, width: double.infinity, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 14, width: 220, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          errorMessage ?? 'Error al cargar el dato curioso.',
          style: const TextStyle(color: AppColors.error, fontSize: 14),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Reintentar'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildFactText(BuildContext context, String text) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        '"$text"',
        key: ValueKey(text),
        style: const TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          height: 1.4,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
