import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/screens/home/home_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
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

  List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Categories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select your favorite news categories',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing:.0,
                childAspectRatio: 0.8,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategories.contains(category.id);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCategories.remove(category.id);
                      } else {
                        _selectedCategories.add(category.id);
                      }
                    });
                  },
                  child: Card(
                    elevation: isSelected ? 8 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              category.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedCategories.isEmpty
                  ? null
                  : () async {
                      await authProvider.updateUserCategories(_selectedCategories);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}