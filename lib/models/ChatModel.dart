import 'package:cloud_firestore/cloud_firestore.dart';

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
