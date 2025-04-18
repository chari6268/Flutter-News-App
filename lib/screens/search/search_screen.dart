import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  bool _isLoading = false;
  List<NewsModel> _searchResults = [];
  String _searchQuery = '';

  final List<CategoryModel> _categories = [
    CategoryModel(id: '1', name: 'Politics', imageUrl: 'assets/politics.jpg'),
    CategoryModel(id: '2', name: 'Sports', imageUrl: 'assets/sports.jpg'),
    CategoryModel(id: '3', name: 'Technology', imageUrl: 'assets/tech.jpg'),
    CategoryModel(id: '4', name: 'Entertainment', imageUrl: 'assets/entertainment.jpg'),
    CategoryModel(id: '5', name: 'Business', imageUrl: 'assets/business.jpg'),
    CategoryModel(id: '6', name: 'Health', imageUrl: 'assets/health.jpg'),
    CategoryModel(id: '7', name: 'Science', imageUrl: 'assets/science.jpg'),
    CategoryModel(id: '8', name: 'World', imageUrl: 'assets/world.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _searchNews() async {
    if (_searchController.text.trim().isEmpty) return;
    
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    
    setState(() {
      _isLoading = true;
      _searchQuery = _searchController.text;
    });

    try {
      List<NewsModel> results;
      
      if (_tabController!.index == 0) {
        // Search by keyword
        results = await newsProvider.searchNewsByKeyword(_searchQuery);
      } else {
        // Search by category
        results = await newsProvider.searchNewsByCategory(_searchQuery);
      }
      
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching news: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Keyword'),
            Tab(text: 'Category'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Keyword search
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for news...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onSubmitted: (_) => _searchNews(),
                ),
              ),
              Expanded(
                child: _buildSearchResults(),
              ),
            ],
          ),
          // Category search
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select a category to see news',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.text = category.name;
                          _searchQuery = category.name;
                        });
                        _searchNews();
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                category.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_searchQuery.isNotEmpty && _tabController!.index == 1)
                Expanded(
                  child: _buildSearchResults(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_searchQuery.isEmpty) {
      return Center(child: Text('Enter a search term'));
    }
    
    if (_searchResults.isEmpty) {
      return Center(child: Text('No results found for "$_searchQuery"'));
    }
    
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return NewsCard(
          news: _searchResults[index],
          onAudioComplete: () {}, // No auto-advance in search results
        );
      },
    );
  }
}