import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement.dart';
import 'add_achievement_dialog.dart';
import 'edit_achievement_dialog.dart';
import 'filter_page.dart';
import 'trophy_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Achievement> achievements = [];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final String? achievementsJson = prefs.getString('achievements');

    if (achievementsJson != null) {
      setState(() {
        achievements = (jsonDecode(achievementsJson) as List)
            .map((item) => Achievement.fromMap(item))
            .toList();
      });
    }
  }

  Future<void> _saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final String achievementsJson = jsonEncode(
      achievements.map((achievement) => achievement.toMap()).toList(),
    );
    await prefs.setString('achievements', achievementsJson);
  }

  void _addAchievement(String title) {
    setState(() {
      achievements.add(Achievement(title: title));
      _saveAchievements();
    });
  }

  void _editAchievement(int index) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) =>
          EditAchievementDialog(initialText: achievements[index].title),
    );

    if (result == null) {
      setState(() {
        achievements.removeAt(index);
        _saveAchievements();
      });
    } else if (result.isNotEmpty) {
      setState(() {
        achievements[index] = Achievement(
            title: result,
            completedDate: achievements[index].completedDate,
            isInProgress: achievements[index].isInProgress);
        _saveAchievements();
      });
    }
  }

  void _markAsCompleted(int index) async {
    final completionDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => const TrophyDialog(),
    );
    if (completionDate != null) {
      setState(() {
        achievements[index].completedDate = completionDate;
        _saveAchievements();
      });
    }
  }

  void _toggleInProgress(int index) {
    setState(() {
      achievements[index].isInProgress = !achievements[index].isInProgress;
      _saveAchievements();
    });

    if (achievements[index].isInProgress) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("¡Logro en progreso!"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void _filterAchievements() async {
    final filteredAchievements = await Navigator.push<List<Achievement>>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          achievements: achievements,
          onFiltered: (filteredList) {
            setState(() {
              achievements = filteredList;
            });
          },
        ),
      ),
    );
    if (filteredAchievements != null) {
      setState(() {
        achievements = filteredAchievements;
        _saveAchievements();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _filterAchievements,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // Hacer las cajas un poco más anchas
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  title: Text(achievement.title),
                  subtitle: achievement.completedDate != null
                      ? Text(
                          'Conseguido el: ${DateFormat('yyyy-MM-dd').format(achievement.completedDate!)}',
                          style: TextStyle(color: Colors.grey[600]),
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editAchievement(index),
                      ),
                      // In Progress button
                      IconButton(
                        icon: Icon(
                          achievement.isInProgress
                              ? Icons.hourglass_empty
                              : Icons.hourglass_full,
                          color: achievement.isInProgress ? Colors.green : null,
                        ),
                        onPressed: () => _toggleInProgress(index),
                      ),
                      // Trofeo button
                      IconButton(
                        icon: const Icon(Icons.emoji_events),
                        color: achievement.isCompleted ? Colors.amber : null,
                        onPressed: () => _markAsCompleted(index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAchievement = await showDialog<String>(
            context: context,
            builder: (context) => const AddAchievementDialog(),
          );
          if (newAchievement != null && newAchievement.isNotEmpty) {
            _addAchievement(newAchievement);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
