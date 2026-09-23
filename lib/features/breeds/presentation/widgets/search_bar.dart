import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

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
    return Semantics(
      label: 'Buscar razas de gato por nombre',
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
          style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Buscar raza por nombre...',
            hintStyle: const TextStyle(color: AppColors.textLight),
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                    onPressed: onClear,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
