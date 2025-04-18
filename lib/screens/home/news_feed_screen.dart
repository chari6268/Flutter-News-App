import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/widgets/news_card.dart';
import 'package:news_app/screens/widgets/ad_card.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<dynamic> _feedItems = []; // Mix of news and ads
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNewsFeed();
  }

  Future<void> _loadNewsFeed() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });

    try {
      List<String> categories = [];
      if (authProvider.currentUser != null) {
        categories = authProvider.currentUser!.selectedCategories;
      }
      
      List<NewsModel> news = await newsProvider.getNewsFeed(categories);
      
      // Insert ads after every 3 news items
      List<dynamic> feed = [];
      for (int i = 0; i < news.length; i++) {
        feed.add(news[i]);
        if ((i + 1) % 3 == 0) {
          feed.add({
            'type': 'ad',
            'imageUrl': 'https://via.placeholder.com/600x200?text=Advertisement',
            'targetUrl': 'https://example.com/ad${(i ~/ 3) + 1}',
          });
        }
      }

      setState(() {
        _feedItems = feed;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading news feed: $e')),
      );
    }
  }

  void _goToNextNews() {
    if (_currentPage < _feedItems.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNewsFeed,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _feedItems.isEmpty
              ? Center(child: Text('No news available'))
              : PageView.builder(
                  controller: _pageController,
                  itemCount: _feedItems.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = _feedItems[index];
                    
                    if (item is NewsModel) {
                      return NewsCard(
                        news: item,
                        onAudioComplete: _goToNextNews,
                      );
                    } else if (item is Map && item['type'] == 'ad') {
                      // Show ad for 3 seconds then auto-advance
                      Future.delayed(Duration(seconds: 3), () {
                        if (_currentPage == index) {
                          _goToNextNews();
                        }
                      });
                      
                      return AdCard(
                        imageUrl: item['imageUrl'],
                        targetUrl: item['targetUrl'],
                      );
                    }
                    
                    return SizedBox.shrink();
                  },
                ),
    );
  }
}