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
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  void handleSignout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          width: 250,
          height: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Logout",
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 17,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      textStyle: GoogleFonts.lato(fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  void _requestNotificationPermission() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      print('Notification permission granted: $granted');
    }
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "Add Item",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 520,
          child: AddItemForm(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "Track your items before they expire!",
              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Add your first item to get started.",
              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAddItemDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _searchController,
          style: GoogleFonts.lato(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search by title...',
            hintStyle: GoogleFonts.lato(color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
      ),
    );
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
            onPressed: _showAddItemDialog,
            icon: const Icon(Icons.add_circle),
          ),
          IconButton(
            onPressed: handleSignout,
            icon: Icon(
              Icons.logout_outlined,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(), // always visible
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
                  return _buildEmptyState();
                }

                final docs = snapshot.data!.docs;
                final items = docs.map((doc) {
                  final data = doc.data();
                  return Item(
                    id: doc.id,
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
