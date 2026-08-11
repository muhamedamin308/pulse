import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.participantIds,
    super.lastMessage,
    super.lastMessageMood,
    super.lastMessageAt,
    required super.unreadCount,
  });

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      lastMessage: data['lastMessage'],
      lastMessageMood: data['lastMessageMood'] != null
          ? Mood.fromValue(data['lastMessageMood'])
          : null,
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      unreadCount: Map<String, int>.from(data['unreadCount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'participantIds': participantIds,
        'lastMessage': lastMessage,
        'lastMessageMood': lastMessageMood?.value,
        'lastMessageAt':
            lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
        'unreadCount': unreadCount,
      };
}
