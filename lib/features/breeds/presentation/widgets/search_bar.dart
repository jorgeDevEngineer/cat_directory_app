import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/localization_service.dart';

class CustomSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CustomSearchBar({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.instance;

    return ListenableBuilder(
      listenable: loc,
      builder: (context, _) {
        return Semantics(
          label: loc.searchHint,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: query,
                  selection: TextSelection.collapsed(offset: query.length),
                ),
              ),
              onChanged: onChanged,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: loc.searchHint,
                prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: onClear,
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
