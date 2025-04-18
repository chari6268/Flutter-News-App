class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String audioUrl;
  final DateTime postedDate;
  final String category;
  final int likes;
  final List<String> savedBy;
  final List<String> likedBy;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.audioUrl,
    required this.postedDate,
    required this.category,
    required this.likes,
    required this.savedBy,
    required this.likedBy,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      postedDate: DateTime.parse(json['postedDate']),
      category: json['category'],
      likes: json['likes'],
      savedBy: List<String>.from(json['savedBy']),
      likedBy: List<String>.from(json['likedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'postedDate': postedDate.toIso8601String(),
      'category': category,
      'likes': likes,
      'savedBy': savedBy,
      'likedBy': likedBy,
    };
  }
}