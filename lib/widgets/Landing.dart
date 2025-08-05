import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usemebefore/widgets/Item.dart';
import 'package:usemebefore/widgets/ItemCard.dart';
import 'package:usemebefore/widgets/AddItem.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Landing extends StatefulWidget{
  const Landing ({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LandingState();
  }
}

class _LandingState extends State<Landing>{
  final uid = FirebaseAuth.instance.currentUser?.uid;
  List<Item>? foodList;

  @override
  void initState() {
    super.initState();
    fetchUserItems();
  }
  void fetchUserItems() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('userId', isEqualTo: uid)
        .get();

    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      print(data);
      return Item(
        title: data['title'],
        expiryDate: data['expiryDate'],
        storage: data['storage'],
        note: data['note'],
        imageUrl: data['imageUrl'],
      );
    }).toList();

    setState(() {
      foodList = items;
    });
  }




  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "useMeBefore",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        backgroundColor: const Color(0xFFE3F2FD),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    "Add Food Item",
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 520,
                    child: AddItemForm(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No items added yet."));
          }

          final docs = snapshot.data!.docs;

          final items = docs.map((doc) {
            final data = doc.data();
            return Item(
              title: data['name'] ?? "",
              expiryDate: data['expiry'] ?? "",
              storage: data['storage'] ?? "",
              note: data['note'] ?? "",
              imageUrl: data['imageUrl'] ?? "",
            );
          }).toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ItemCard(food: items[index]);
            },
          );
        },
      ),
    );
  }

}