import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_functionalities/service/firebase_service.dart';
import 'package:flutter/material.dart';
import '../const/const.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService fs = FirestoreService();
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: fs.getFilteredMapData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          }

          // Data is available
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text('Price: ${data['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}
