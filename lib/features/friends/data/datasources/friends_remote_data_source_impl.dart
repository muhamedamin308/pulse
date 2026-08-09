import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/constants/pulse_constants.dart';
import 'package:pulse/core/errors/exceptions.dart';
import 'package:pulse/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:pulse/features/friends/data/models/friend_model.dart';

@Injectable(as: FriendsRemoteDataSource)
class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  final FirebaseFirestore _firestore;

  FriendsRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> addFriend(String currentUserId, String targetUserId) async {
    try {
      final batch = _firestore.batch();

      final currentUserRef = _firestore
          .collection(PulseConstants.usersCollection)
          .doc(targetUserId);

      final targetUserRef = _firestore
          .collection(PulseConstants.usersCollection)
          .doc(currentUserId);

      batch.update(currentUserRef, {
        PulseConstants.firendsIds: FieldValue.arrayUnion([currentUserId])
      });

      batch.update(targetUserRef, {
        PulseConstants.firendsIds: FieldValue.arrayUnion([targetUserId])
      });

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<FriendModel>> getFriends(String userId) async {
    try {
      final userDoc = await _firestore
          .collection(PulseConstants.usersCollection)
          .doc(userId)
          .get();

      final friendIds =
          List<String>.from(userDoc[PulseConstants.firendsIds] ?? []);
      if (friendIds.isEmpty) return [];

      final snapshots = await Future.wait(friendIds.map((id) =>
          _firestore.collection(PulseConstants.usersCollection).doc(id).get()));

      return snapshots
          .where((doc) => doc.exists)
          .map((doc) => FriendModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('FRIENDS ERROR: $e');

      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<FriendModel>> getSuggestedUsers(String userId) async {
    try {
      final userDoc = await _firestore
          .collection(PulseConstants.usersCollection)
          .doc(userId)
          .get();

      final friendsIds =
          List<String>.from(userDoc[PulseConstants.firendsIds] ?? []);
      final excludeIds = [...friendsIds, userId];

      final snapshot = await _firestore
          .collection(PulseConstants.usersCollection)
          .limit(20)
          .get();

      return snapshot.docs
          .where((doc) => !excludeIds.contains(doc.id))
          .map((doc) => FriendModel.fromFirestore(doc))
          .take(10)
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeFriend(String currentUserId, String targetUserId) async {
    try {
      final batch = _firestore.batch();

      final currentUserRef = _firestore
          .collection(PulseConstants.usersCollection)
          .doc(currentUserId);
      final targetUserRef = _firestore
          .collection(PulseConstants.usersCollection)
          .doc(targetUserId);

      batch.update(currentUserRef, {
        PulseConstants.firendsIds: FieldValue.arrayRemove([targetUserId]),
      });
      batch.update(targetUserRef, {
        PulseConstants.firendsIds: FieldValue.arrayRemove([currentUserId])
      });

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<FriendModel>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection(PulseConstants.usersCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => FriendModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
