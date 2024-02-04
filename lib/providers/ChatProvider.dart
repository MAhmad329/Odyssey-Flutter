import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        .orderBy('timestamp',
            descending:
                true) // Add this line to order by timestamp in descending order
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }
}

class ChatMessage {
  final String senderId;
  final String senderName;
  final String message;
  final Timestamp timestamp;

  ChatMessage(
      {required this.senderId,
      required this.senderName,
      required this.message,
      required this.timestamp});

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatMessage(
      senderId: data['senderId'],
      senderName: data['senderName'],
      message: data['message'],
      timestamp: data['timestamp'],
    );
  }
}
