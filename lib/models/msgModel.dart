class MsgModel {
  final String id;
  final String sendemail;
  final String reciveemail;
  final String message;
  final String msgtype;
  final String sendid;
  final String reciveid;
  final String datetime;
  final String datetimeid;

  MsgModel({
    required this.id,
    required this.sendemail,
    required this.reciveemail,
    required this.message,
    required this.sendid,
    required this.reciveid,
    required this.datetimeid,
    required this.msgtype,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sendemail': sendemail,
      'reciveemail': reciveemail,
      'message': message,
      'sendid': sendid,
      'reciveid': reciveid,
      'datetimeid': datetimeid,
      'msgtype': msgtype,
      'datetime': datetime
    };
  }

  MsgModel.fromMap(Map<dynamic, dynamic> res)
      : id = res["id"],
        sendemail = res["sendemail"],
        reciveemail = res["reciveemail"],
        message = res["message"],
        sendid = res["sendid"],
        reciveid = res["reciveid"],
        datetimeid = res["datetimeid"],
        msgtype = res["msgtype"],
        datetime = res["datetime"];
}
