import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usemebefore/widgets/Item.dart';
import 'package:usemebefore/widgets/ItemCard.dart';
import 'package:usemebefore/widgets/AddItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();


class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<StatefulWidget> createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() async {
    final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      // You may want to log or act depending on 'granted'
      print('Notification permission granted: $granted');
    }
  }
  final uid = FirebaseAuth.instance.currentUser?.uid;
  String searchQuery = '';

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

      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // StreamBuilder for dynamic list
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('userId', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                          "No items added yet.",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.grey
                        ),
                      )
                  );
                }

                final docs = snapshot.data!.docs;

                final items = docs.map((doc) {
                  final data = doc.data();
                  return Item(
                    id: doc.id ?? "",
                    title: data['name'] ?? "",
                    expiryDate: data['expiry'] ?? "",
                    storage: data['storage'] ?? "",
                    note: data['note'] ?? "",
                    imageUrl: data['imageUrl'] ?? "",
                  );
                }).where((item) {
                  return item.title.toLowerCase().contains(searchQuery);
                }).toList();

                if (items.isEmpty) {
                  return const Center(child: Text("No items match your search."));
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        await FirebaseFirestore.instance
                            .collection('items')
                            .doc(item.id)
                            .delete();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item.title} deleted")),
                        );
                      },
                      child: ItemCard(food: item),
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
