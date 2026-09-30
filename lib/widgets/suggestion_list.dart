import 'package:flutter/material.dart';

class SuggestionList extends StatelessWidget {
  final List<dynamic> suggestions;
  final Function(
      double latitude,
      double longitude,
      String name,
      ) onSelected;

  const SuggestionList({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(
        top: 5,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(12),

        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
          ),
        ],
      ),

      child: ListView.builder(
        shrinkWrap: true,

        itemCount: suggestions.length,

        itemBuilder: (
            context,
            index,
            ) {
          final suggestion =
          suggestions[index];

          final properties =
          suggestion['properties'];

          final coordinates =
          suggestion['geometry']
          ['coordinates'];

          final name =
              properties['name'] ??
                  properties['city'] ??
                  properties['state'] ??
                  'Unknown location';

          final city =
              properties['city'] ?? '';

          final state =
              properties['state'] ?? '';

          final country =
              properties['country'] ?? '';

          String subtitle = '';

          if (city
              .toString()
              .isNotEmpty) {
            subtitle +=
                city.toString();
          }

          if (state
              .toString()
              .isNotEmpty) {
            if (subtitle.isNotEmpty) {
              subtitle += ', ';
            }

            subtitle +=
                state.toString();
          }

          if (country
              .toString()
              .isNotEmpty) {
            if (subtitle.isNotEmpty) {
              subtitle += ', ';
            }

            subtitle +=
                country.toString();
          }

          return ListTile(
            leading: const Icon(
              Icons.location_on,
            ),

            title: Text(
              name.toString(),
            ),

            subtitle: Text(
              subtitle,
            ),

            onTap: () {
              final longitude =
              (coordinates[0] as num)
                  .toDouble();

              final latitude =
              (coordinates[1] as num)
                  .toDouble();

              onSelected(
                latitude,
                longitude,
                name.toString(),
              );
            },
          );
        },
      ),
    );
  }
}