class Usermodel {
  final String id;
  final String email;
  final List<String> firends;

  Usermodel({
    required this.id,
    required this.email,
    required this.firends,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      // 'firends': firends,
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> res) {
    return Usermodel(
      id: res['id'],
      email: res['email'],
      firends: res['firends'] ?? [],
    );
  }
}
