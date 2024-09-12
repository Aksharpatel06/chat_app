
class UserModal {
  String? username, email, photoUrl, userToken;
  bool? isOnline;

  UserModal._(
      {required this.username,
      required this.email,
      required this.isOnline,
      required this.photoUrl,
      required this.userToken});

  factory UserModal(Map m1) {
    return UserModal._(
        username: m1['username'],
        email: m1['email'],
        isOnline: m1['isOnline'],
        userToken: m1['token'] ?? '--',
        photoUrl: m1['photoUrl'] ??
            'https://t3.ftcdn.net/jpg/01/65/63/94/360_F_165639425_kRh61s497pV7IOPAjwjme1btB8ICkV0L.jpg');
  }

  Map<String, dynamic> objectToMap(UserModal userModal) {
    return {
      'username': userModal.username ?? 'akshar',
      'email': userModal.email!,
      'photoUrl': userModal.photoUrl!,
      'token': userModal.userToken!,
      'isOnline': userModal.isOnline ?? true,
    };
  }
}
