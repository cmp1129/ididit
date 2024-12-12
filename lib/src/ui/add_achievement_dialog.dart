import 'package:flutter/material.dart';

class AddAchievementDialog extends StatefulWidget {
  const AddAchievementDialog({Key? key}) : super(key: key);

  @override
  _AddAchievementDialogState createState() => _AddAchievementDialogState();
}

class _AddAchievementDialogState extends State<AddAchievementDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logro que quieres cumplir:'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Ejemplo: Viajar a Japón',
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
        ),
      ],
    );
  }
}
