import 'package:flutter/material.dart';

class TrophyDialog extends StatefulWidget {
  const TrophyDialog({Key? key}) : super(key: key);

  @override
  _TrophyDialogState createState() => _TrophyDialogState();
}

class _TrophyDialogState extends State<TrophyDialog> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¡Enhorabuena! Has conseguido el logro.'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Selecciona la fecha de consecución:'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              setState(() {
                _selectedDate = pickedDate;
              });
            },
            child: const Text('Seleccionar fecha'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // No selecciona fecha
          child: const Text('Cancelar'),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => Navigator.of(context).pop(_selectedDate),
        ),
      ],
    );
  }
}
