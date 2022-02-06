class UserContext {
  final int UserId;
  final int ContextId;

  UserContext({required this.UserId, required this.ContextId});

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId,
      'ContextId': ContextId,
    };
  }
}
