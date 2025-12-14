import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/screens/camera_screen.dart';
import 'package:glow_up/screens/profile_screen.dart';
import 'package:glow_up/services/auth_service.dart';
import 'package:glow_up/services/db_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = AuthService().currentUser?.uid ?? '';
    final db = DatabaseService(uid: uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s GlowUps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.getFriendsPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(post['photoUrl'], height: 300, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.whatshot, color: Colors.deepOrange),
                            onPressed: () => db.voteOnPost(posts[index].reference.parent.parent!.id, 'fire'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.thumb_up, color: Colors.grey),
                            onPressed: () => db.voteOnPost(posts[index].reference.parent.parent!.id, 'solid'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.thumb_down, color: Colors.grey),
                            onPressed: () => db.voteOnPost(posts[index].reference.parent.parent!.id, 'meh'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScreen())),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}