class CommentModel {
  final String id;
  final String newsId;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final List<String> mentions;

  CommentModel({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    required this.mentions,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      newsId: json['newsId'],
      userId: json['userId'],
      userName: json['userName'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      mentions: List<String>.from(json['mentions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'newsId': newsId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'mentions': mentions,
    };
  }
}