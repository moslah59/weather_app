import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearch;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      // Mobile keyboard-এ Search button
      textInputAction: TextInputAction.search,

      // Typing
      onChanged: onChanged,

      // Enter / Search button
      onSubmitted: onSubmitted,

      decoration: InputDecoration(
        hintText: 'Search city or place...',

        prefixIcon: const Icon(
          Icons.search,
        ),

        suffixIcon: IconButton(
          icon: const Icon(
            Icons.arrow_forward,
          ),
          onPressed: onSearch,
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
    );
  }
}