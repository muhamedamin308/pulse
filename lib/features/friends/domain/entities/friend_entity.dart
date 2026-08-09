class FriendEntity {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final bool isOnline;
  final DateTime? lastSeen;

  const FriendEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.isOnline,
    this.lastSeen,
  });
}
