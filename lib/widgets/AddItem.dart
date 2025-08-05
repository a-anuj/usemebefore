import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 for formatting the date

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController storageController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  DateTime? selectedDate;

  void submit() {
    final name = nameController.text;
    final expiry = expiryController.text;

    // 🔥 Send to Firebase here
    // FirebaseFirestore.instance.collection('foods').add({ ... });

    Navigator.pop(context); // Close the popup
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        expiryController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: storageController,
            decoration: InputDecoration(
              labelText: 'Storage',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: expiryController,
            readOnly: true,
            onTap: _pickDate,
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: submit,
              child: Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
