import 'package:flutter/material.dart';
import '../models/achievement.dart';

class FilterPage extends StatelessWidget {
  final List<Achievement> achievements;
  final Function(List<Achievement>) onFiltered;

  const FilterPage(
      {Key? key, required this.achievements, required this.onFiltered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar Logros'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Ordenar por fecha ascendente'),
            trailing: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                List<Achievement> filteredAchievements = List.from(achievements)
                  ..sort((a, b) {
                    // Si a o b no tienen fecha, los colocamos al final
                    if (a.completedDate == null && b.completedDate == null)
                      return 0;
                    if (a.completedDate == null) return 1;
                    if (b.completedDate == null) return -1;
                    return a.completedDate!.compareTo(b.completedDate!);
                  });
                onFiltered(filteredAchievements);
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            title: const Text('Ordenar por fecha descendente'),
            trailing: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                List<Achievement> filteredAchievements = List.from(achievements)
                  ..sort((a, b) {
                    // Si a o b no tienen fecha, los colocamos al final
                    if (a.completedDate == null && b.completedDate == null)
                      return 0;
                    if (a.completedDate == null) return 1;
                    if (b.completedDate == null) return -1;
                    return b.completedDate!.compareTo(a.completedDate!);
                  });
                onFiltered(filteredAchievements);
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            title: const Text('Ordenar logros en progreso primero'),
            trailing: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                List<Achievement> filteredAchievements = List.from(achievements)
                  ..sort((a, b) {
                    if (a.isInProgress && !b.isInProgress) return -1;
                    if (!a.isInProgress && b.isInProgress) return 1;
                    return 0; // Mantener el orden entre los que no están en progreso
                  });
                onFiltered(filteredAchievements);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
