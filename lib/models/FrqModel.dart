class FrqModel {
  final String id;
  final String email;

  final String name;
  final int status;
  final String datetime;
  FrqModel(
      {required this.id,
      required this.email,
      required this.name,
      this.status = 0,
      required this.datetime});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'status': status,
      'datetime': datetime
    };
  }

  factory FrqModel.fromMap(Map<String, dynamic> res) {
    return FrqModel(
      id: res['id'],
      email: res['email'],
      name: res['name'],
      status: res['status'],
      datetime: res['datetime'],
    );
  }
}
