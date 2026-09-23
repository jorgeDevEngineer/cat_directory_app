import 'package:flutter/material.dart';
import '../../../../core/localization/localization_service.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.instance;

    return ListenableBuilder(
      listenable: loc,
      builder: (context, _) {
        final isEs = loc.isSpanish;

        return Tooltip(
          message: isEs ? 'Cambiar a Inglés' : 'Switch to Spanish',
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => loc.toggleLanguage(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEs ? '🇪🇸 ES' : '🇺🇸 EN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
