class Keymodel {
  final String id;
  final String key;
  final String addeddate;

  Keymodel({
    required this.id,
    required this.key,
    required this.addeddate,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'addeddate': addeddate,
    };
  }

  factory Keymodel.fromMap(Map<String, dynamic> res) {
    return Keymodel(
      id: res['id'],
      key: res['key'],
      addeddate: res['addeddate'],
    );
  }
}
