import 'package:flutter/material.dart';
import '../../../../core/localization/localization_service.dart';

class FactCard extends StatelessWidget {
  final bool isLoading;
  final String? factText;
  final String? errorMessage;
  final VoidCallback onRetry;

  const FactCard({
    super.key,
    required this.isLoading,
    this.factText,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.instance;
    return Semantics(
      label: isLoading
          ? 'Dato curioso cargando'
          : errorMessage != null
              ? 'Error al cargar dato curioso'
              : 'Dato curioso aleatorio: ${factText ?? ""}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
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
                ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  loc.isSpanish ? 'Dato Curioso Aleatorio' : 'Random Cat Fact',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Theme.of(context).dividerColor, height: 16),
            const SizedBox(height: 8),
            if (isLoading) _buildShimmer(context),
            if (!isLoading && errorMessage != null) _buildError(context),
            if (!isLoading && factText != null) _buildFactText(context, factText!),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 14,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 14,
          width: 220,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Theme.of(context).colorScheme.outline, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage ?? 'You must connect to the internet to get a new random fact.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Retry'),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFactText(BuildContext context, String text) {
    final loc = LocalizationService.instance;
    final translated = loc.translateFact(text);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        '"$translated"',
        key: ValueKey(translated),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
      ),
    );
  }
}
