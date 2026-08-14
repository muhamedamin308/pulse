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
  Stream<List<MessageModel>> getMessages(String chatId) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<void> markMessagesAsRead(String chatId, String userId) {
    // TODO: implement markMessagesAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(
      {required String chatId,
      required String senderId,
      required String content,
      required Mood mood,
      required bool isMoodOverridden}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
