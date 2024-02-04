import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/ChatModel.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
      String courseId, String userId, String userName, String message) async {
    final chatMessage = {
      'senderId': userId,
      'senderName': userName,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('chats')
        .add(chatMessage);
    notifyListeners();
  }

  Stream<List<ChatMessage>> getMessages(String courseId) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }
}
