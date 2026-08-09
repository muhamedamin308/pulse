class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final List<String> friendIds;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.friendIds,
    required this.isOnline,
    this.lastSeen,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    List<String>? friendIds,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      friendIds: friendIds ?? this.friendIds,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  List<Object?> get props => [
        uid,
        name,
        email,
        photoUrl,
        bio,
        friendIds,
        isOnline,
        lastSeen,
        createdAt,
      ];

  bool get stringify => true;
}
