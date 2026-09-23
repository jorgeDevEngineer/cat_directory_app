import 'package:flutter/material.dart';

enum ErrorType { noConnection, serverError, unknown }

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final ErrorType type;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.type = ErrorType.unknown,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String defaultTitle;

    switch (type) {
      case ErrorType.noConnection:
        icon = Icons.wifi_off_rounded;
        defaultTitle = 'Sin Conexión a Internet';
        break;
      case ErrorType.serverError:
        icon = Icons.dns_rounded;
        defaultTitle = 'Error del Servidor';
        break;
      case ErrorType.unknown:
        icon = Icons.error_outline_rounded;
        defaultTitle = 'Algo salió mal';
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              defaultTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
