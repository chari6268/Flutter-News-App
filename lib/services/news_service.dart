import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/models/comment_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NewsModel>> getNewsFeed(List<String> categories) async {
    // First get news from user's selected categories
    QuerySnapshot prioritySnap = await _firestore
        .collection('news')
        .where('category', whereIn: categories)
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    List<NewsModel> priorityNews = prioritySnap.docs
        .map((doc) => NewsModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Then get other news
    QuerySnapshot otherSnap = await _firestore
        .collection('news')
        .where('category', whereNotIn: categories)
        .orderBy('postedDate', descending: true)
        .limit(10)
        .get();

    List<NewsModel> otherNews = otherSnap.docs
        .map((doc) => NewsModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Combine both lists
    return [...priorityNews, ...otherNews];
  }

  Future<List<NewsModel>> getSavedNews(String userId) async {
    QuerySnapshot snap = await _firestore
        .collection('news')
        .where('savedBy', arrayContains: userId)
        .orderBy('postedDate', descending: true)
        .get();

    return snap.docs
        .map((doc) => NewsModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> toggleSaveNews(String newsId, String userId, bool save) async {
    if (save) {
      await _firestore.collection('news').doc(newsId).update({
        'savedBy': FieldValue.arrayUnion([userId]),
      });
    } else {
      await _firestore.collection('news').doc(newsId).update({
        'savedBy': FieldValue.arrayRemove([userId]),
      });
    }
  }

  Future<void> toggleLikeNews(String newsId, String userId, bool like) async {
    if (like) {
      await _firestore.collection('news').doc(newsId).update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likes': FieldValue.increment(1),
      });
    } else {
      await _firestore.collection('news').doc(newsId).update({
        'likedBy': FieldValue.arrayRemove([userId]),
        'likes': FieldValue.increment(-1),
      });
    }
  }

  Future<void> addComment(CommentModel comment) async {
    await _firestore.collection('comments').add(comment.toJson());
  }

  Future<List<CommentModel>> getComments(String newsId) async {
    QuerySnapshot snap = await _firestore
        .collection('comments')
        .where('newsId', isEqualTo: newsId)
        .orderBy('timestamp', descending: true)
        .get();

    return snap.docs
        .map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> reportNews(
      String newsId, String userId, String reason, String comment) async {
    await _firestore.collection('reports').add({
      'newsId': newsId,
      'userId': userId,
      'reason': reason,
      'comment': comment,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<NewsModel>> searchNewsByCategory(String category) async {
    QuerySnapshot snap = await _firestore
        .collection('news')
        .where('category', isEqualTo: category)
        .orderBy('postedDate', descending: true)
        .get();

    return snap.docs
        .map((doc) => NewsModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<NewsModel>> searchNewsByKeyword(String keyword) async {
    // Basic implementation - in a real app, you might use a more sophisticated search
    QuerySnapshot snap = await _firestore.collection('news').get();

    return snap.docs
        .map((doc) => NewsModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((news) =>
            news.title.toLowerCase().contains(keyword.toLowerCase()) ||
            news.content.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}