import 'package:ai_mental_health_chatbot/screens/bedtime/story_model.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final databaseRef = FirebaseDatabase.instance.ref('mp3_files');  // Reference to the root in Realtime Database

  // Fetch story metadata from Realtime Database and generate download URLs from Firebase Storage
  Future<List<Story>> fetchStories() async {
    List<Story> songList = [];

    try {
      // Fetch metadata from Firebase Realtime Database
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> mp3Metadata = Map<String, dynamic>.from(snapshot.value as Map);
        mp3Metadata.forEach((key, value){
          String title = value['title'];
          String relativePath = value['path'];
          songList.add(Story(title: title, url: relativePath));
        });
      }
    } catch (e) {
      print("Error fetching stories: $e");
    }
    return songList;  // Return the list of stories
  }
}
