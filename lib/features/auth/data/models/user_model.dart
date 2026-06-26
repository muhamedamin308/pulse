import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.photoUrl,
    super.bio,
    required super.friendIds,
    required super.isOnline,
    super.lastSeen,
    required super.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      friendIds: List<String>.from(data['friendIds'] ?? []),
      isOnline: data['isOnline'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'friendIds': friendIds,
        'isOnline': isOnline,
        'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  UserEntity toEntity() => UserEntity(
        uid: uid,
        name: name,
        email: email,
        photoUrl: photoUrl,
        bio: bio,
        friendIds: friendIds,
        isOnline: isOnline,
        lastSeen: lastSeen,
        createdAt: createdAt,
      );
}
