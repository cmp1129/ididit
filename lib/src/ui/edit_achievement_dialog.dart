import 'package:flutter/material.dart';

class EditAchievementDialog extends StatefulWidget {
  final String initialText;
  const EditAchievementDialog({Key? key, required this.initialText})
      : super(key: key);

  @override
  _EditAchievementDialogState createState() => _EditAchievementDialogState();
}

class _EditAchievementDialogState extends State<EditAchievementDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar logro'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Nuevo texto del logro'),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(null), // Señal de eliminación
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () =>
              Navigator.of(context).pop(_controller.text), // Guarda cambios
        ),
      ],
    );
  }
}
