import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.content,
    required super.mood,
    required super.isMoodOverridden,
    required super.type,
    required super.sentAt,
    required super.isRead,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      content: data['content'] ?? '',
      mood: Mood.fromValue(data['mood'] ?? 'neutral'),
      isMoodOverridden: data['isMoodOverridden'] ?? false,
      type: MessageType.text,
      sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'content': content,
        'mood': mood.value,
        'isMoodOverridden': isMoodOverridden,
        'type': type.name,
        'sentAt': Timestamp.fromDate(sentAt),
        'isRead': isRead,
      };
}
