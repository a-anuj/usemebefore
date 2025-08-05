import 'package:flutter/material.dart';


class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  void submit() {
    final name = nameController.text;
    final expiry = expiryController.text;

    // 🔥 Send to Firebase here
    // FirebaseFirestore.instance.collection('foods').add({ ... });

    Navigator.pop(context); // Close the sheet
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  // 👈 key for left alignment
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Add logic
              },
              child: Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}


