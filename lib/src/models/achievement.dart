import 'dart:convert';

class Achievement {
  String title;
  DateTime? completedDate;
  bool isInProgress;

  Achievement(
      {required this.title, this.completedDate, this.isInProgress = false});

  // Getter para verificar si el logro está completado
  bool get isCompleted => completedDate != null;

  // Para convertir el logro a Map (para JSON)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completedDate': completedDate?.toIso8601String(),
      'isInProgress': isInProgress,
    };
  }

  // Para crear un logro desde un Map
  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      title: map['title'],
      completedDate: map['completedDate'] != null
          ? DateTime.parse(map['completedDate'])
          : null,
      isInProgress: map['isInProgress'] ?? false,
    );
  }
}
