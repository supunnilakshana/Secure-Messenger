class Videomodel {
  final String id;
  final String senderemail;
  final String reciveremail;
  final String videourl;
  final String date;

  Videomodel(
      {required this.id,
      required this.senderemail,
      required this.reciveremail,
      required this.videourl,
      required this.date});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderemail': senderemail,
      'reciveremail': reciveremail,
      'videourl': videourl,
      'date': date
    };
  }

  factory Videomodel.fromMap(Map<String, dynamic> res) {
    return Videomodel(
        id: res['id'],
        senderemail: res['senderemail'],
        reciveremail: res['reciveremail'],
        videourl: res['videourl'],
        date: res['date']);
  }
}
