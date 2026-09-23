import 'package:flutter/material.dart';
import '../theme/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.instance;

    return ListenableBuilder(
      listenable: themeService,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Tooltip(
          message: isDark ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro',
          child: IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => themeService.toggleTheme(),
          ),
        );
      },
    );
  }
}
