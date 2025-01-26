class Chats {
  final String chatId;
  final List<Map<String, String>> members;
  final String profile;
  final String? chatname;
  final String? createdBy;

  Chats({
    required this.chatId,
    required this.members,
    required this.profile,
    this.chatname,
    this.createdBy,
  });

  // From Map Constructor
  factory Chats.fromMap(Map<String, dynamic> map) {
    return Chats(
      chatId: map['chatId'] as String,
      members: List<Map<String, String>>.from(
        (map['members'] as List<dynamic>)
            .map((e) => Map<String, String>.from(e as Map)),
      ),
      profile: map['profile'] as String,
      chatname: map['chatname'] as String?,
      createdBy: map['createdBy'] as String?,
    );
  }

  // To Map Method
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'members': members.map((e) => e).toList(),
      'profile': profile,
      'chatname': chatname,
      'createdBy': createdBy,
    };
  }

  // CopyWith Method
  Chats copyWith({
    String? chatId,
    List<Map<String, String>>? members,
    String? profile,
    String? chatname,
    String? createdBy,
  }) {
    return Chats(
      chatId: chatId ?? this.chatId,
      members: members ?? this.members,
      profile: profile ?? this.profile,
      chatname: chatname ?? this.chatname,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
