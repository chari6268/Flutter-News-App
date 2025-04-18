import 'package:flutter/material.dart';

class NewsProvider with ChangeNotifier {
  // Example fields
  List<Map<String, String>> _newsArticles = [];

  // Getter for news articles
  List<Map<String, String>> get newsArticles => [..._newsArticles];

  // Example method to fetch news articles
  Future<void> fetchNews() async {
    // Simulate an API call
    await Future.delayed(Duration(seconds: 2));
    _newsArticles = [
      {'title': 'Breaking News 1', 'content': 'Content of breaking news 1'},
      {'title': 'Breaking News 2', 'content': 'Content of breaking news 2'},
    ];
    notifyListeners(); // Notify listeners about the state change
  }

  // Example method to clear news articles
  void clearNews() {
    _newsArticles = [];
    notifyListeners(); // Notify listeners about the state change
  }
}