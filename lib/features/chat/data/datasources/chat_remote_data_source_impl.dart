import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/mood.dart';
import 'package:pulse/core/constants/pulse_constants.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:pulse/features/chat/data/models/chat_model.dart';
import 'package:pulse/features/chat/data/models/message_model.dart';

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSourceImpl(this._firestore);

  String _generateChatId(String uid1, String uid2) {
    final ids = [uid1, uid2]..sort();
    return ids.join('_');
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatId) {
    try {
      return _firestore
          .collection(PulseConstants.chatsCollection)
          .doc(chatId)
          .collection(PulseConstants.messagesCollection)
          .orderBy('sentAt', descending: false)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => MessageModel.fromFirestore(doc)).toList());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<ChatModel>> getChats(String userId) {
    try {
      return _firestore
          .collection(PulseConstants.chatsCollection)
          .where('participantIds', arrayContains: userId)
          .orderBy('lastMessageAt', descending: true)
          .snapshots()
          .map((snap) =>
              snap.docs.map((doc) => ChatModel.fromFirestore(doc)).toList());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> createChat(String currentUserId, String targetUserId) async {
    try {
      final chatId = _generateChatId(currentUserId, targetUserId);
      final chatRef =
          _firestore.collection(PulseConstants.chatsCollection).doc(chatId);

      final doc = await chatRef.get();
      if (!doc.exists) {
        await chatRef.set({
          'participantIds': [currentUserId, targetUserId],
          'lastMessage': null,
          'lastMessageMood': null,
          'lastMessageAt': null,
          'unreadCount': {
            currentUserId: 0,
            targetUserId: 0,
          },
        });
      }
      return chatId;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    required Mood mood,
    required bool isMoodOverridden,
  }) async {
    try {
      final chatRef =
          _firestore.collection(PulseConstants.chatsCollection).doc(chatId);

      final messageRef =
          chatRef.collection(PulseConstants.messagesCollection).doc();

      final batch = _firestore.batch();

      // Add message
      batch.set(messageRef, {
        'senderId': senderId,
        'content': content,
        'mood': mood.value,
        'isMoodOverridden': isMoodOverridden,
        'type': 'text',
        'sentAt': Timestamp.fromDate(DateTime.now()),
        'isRead': false,
      });

      // Update chat metadata
      final chatDoc = await chatRef.get();
      final data = chatDoc.data() as Map<String, dynamic>;
      final participantIds = List<String>.from(data['participantIds'] ?? []);
      final otherUserId = participantIds.firstWhere((id) => id != senderId);

      batch.update(chatRef, {
        'lastMessage': content,
        'lastMessageMood': mood.value,
        'lastMessageAt': Timestamp.fromDate(DateTime.now()),
        'unreadCount.$otherUserId': FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection(PulseConstants.chatsCollection)
          .doc(chatId)
          .collection(PulseConstants.messagesCollection)
          .doc(messageId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    try {
      await _firestore
          .collection(PulseConstants.chatsCollection)
          .doc(chatId)
          .update({'unreadCount.$userId': 0});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
