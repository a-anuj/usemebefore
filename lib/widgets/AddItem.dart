import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firebase = FirebaseStorage.instance;
final _firebaseStore = FirebaseFirestore.instance;
class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading=false;
  final nameController = TextEditingController();
  final storageController = TextEditingController();
  final noteController = TextEditingController();
  final expiryController = TextEditingController();

  File? _imageFile;
  DateTime? selectedDate;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth:800,
        maxHeight:800
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
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

  void submit() async {
    final isValid = _formKey.currentState!.validate();
    final isImagePicked = _imageFile != null;

    if (isValid && isImagePicked) {
      try {
        setState(() {
          _isLoading=true;
        });
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final fileName = 'images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // 📤 Upload image
        final ref = _firebase.ref().child(fileName);
        await ref.putFile(_imageFile!);
        final imageUrl = await ref.getDownloadURL();

        // 🔥 Save to Firestore
        final docRef = await _firebaseStore.collection('items').add({
          'userId': userId,
          'name': nameController.text.trim(),
          'storage': storageController.text.trim(),
          'note': noteController.text.trim(),
          'expiry': expiryController.text.trim(),
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 💥 Add the generated doc ID back into the doc
        await docRef.update({'id': docRef.id});


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added.')),
        );
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading=false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong 😢')),
        );
      }
    } else {
      // 👀 Show image + form validation errors
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: storageController,
            decoration: InputDecoration(labelText: 'Fridge,Cupboard,shelf...', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Storage is required' : null,
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: noteController,
            decoration: InputDecoration(labelText: 'Use for pasta/biriyani...', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Note is required' : null,
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: expiryController,
            readOnly: true,
            onTap: _pickDate,
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Expiry date is required' : null,
          ),
          SizedBox(height: 25),
          Text("Image", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_imageFile!, fit: BoxFit.cover),
              )
                  : Icon(Icons.camera_alt, size: 40, color: Colors.black),
            ),
          ),
          SizedBox(height: 10),
          Text(
            _imageFile != null ? "Image captured." : "* Image is required",
            style: GoogleFonts.lato(
              color: _imageFile != null ? Colors.green[800] : Colors.red[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child:
              _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                onPressed: submit,
                child:Text('Add'),
            ),
          ),
        ]),
      ),
    );
  }
}
