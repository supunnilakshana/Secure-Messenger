class Keymodel {
  final String id;
  final String key;
  final String extesion;
  final String addeddate;

  Keymodel(
      {required this.id,
      required this.key,
      required this.addeddate,
      required this.extesion});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'addeddate': addeddate,
      ' extesion': extesion
    };
  }

  factory Keymodel.fromMap(Map<String, dynamic> res) {
    return Keymodel(
      id: res['id'],
      key: res['key'],
      extesion: res['extesion'],
      addeddate: res['addeddate'],
    );
  }
}
