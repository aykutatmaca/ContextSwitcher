class Log {
  late int? LogId;
  late int? UserId;
  late int? ContextId;
  late String? TimeStamp;

  late String contextName; //generated from ContextId, not stored in database
  late String userName; //generated from UserId, not stored in database
  late DateTime date; //generated from TimeStamp, not stored in database

  Log(
      {this.LogId,
      required this.UserId,
      required this.ContextId,
      required this.TimeStamp});

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId,
      'ContextId': ContextId,
      'TimeStamp': TimeStamp,
    };
  }
}
