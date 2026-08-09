import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/features/friends/domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity {
  const FriendModel({
    required super.uid,
    required super.name,
    required super.email,
    super.photoUrl,
    super.bio,
    required super.isOnline,
    super.lastSeen,
  });

  factory FriendModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      isOnline: data['isOnline'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'isOnline': isOnline,
        'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      };

  FriendEntity toEntity() => FriendEntity(
        uid: uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        bio: bio,
        isOnline: isOnline,
        lastSeen: lastSeen,
      );
}
