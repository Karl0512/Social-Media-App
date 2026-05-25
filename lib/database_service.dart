import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Signs up a new user and saves their profile to Firestore
  Future<void> signUp(String email, String password, String username) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save the username in a 'users' collection linked by UID
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'username': username,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Fetches the username for a specific user ID from Firestore
  Future<String> getUsername(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception("User profile not found.");
    return doc.get('username') as String;
  }

  /// Returns a stream of posts from Firestore ordered by timestamp
  Stream<QuerySnapshot> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Uploads a post to the 'posts' collection
  /// Returns the ID of the created document
  Future<void> uploadPost(String text, String username, {Uint8List? imageBytes}) async {
    if (text.trim().isEmpty && imageBytes == null) {
      throw Exception("Post content cannot be empty.");
    }

    final String? uid = _auth.currentUser?.uid;

    if (uid == null) {
      throw Exception("You must be logged in to post.");
    }

    // Convert image bytes to Base64 string if present
    String? base64Image;
    if (imageBytes != null) {
      base64Image = base64Encode(imageBytes);
    }

    // Add a new document with a generated ID
    await _firestore.collection('posts').add({
      'text': text,
      'username': username,
      'uid': uid,
      'imagePath': base64Image, // Storing string data directly
      'timestamp': FieldValue.serverTimestamp(), // Ensures server-side consistency
    });
  }
}