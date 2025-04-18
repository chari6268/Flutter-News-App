import 'package:flutter/material.dart';

class MultiSelectCategoryScreen extends StatefulWidget {
  @override
  _MultiSelectCategoryScreenState createState() =>
      _MultiSelectCategoryScreenState();
}

class _MultiSelectCategoryScreenState extends State<MultiSelectCategoryScreen> {
  // Dummy list of categories
  List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
    'Category 6',
    'Category 7',
    'Category 8',
    'Category 9',
  ];

  // Map to track selected categories
  Map<String, bool> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    // Initialize all categories as not selected
    for (String category in categories) {
      selectedCategories[category] = false;
    }
  }

  // Function to toggle category selection
  void toggleCategory(String category) {
    setState(() {
      selectedCategories[category] = !selectedCategories[category]!;
    });
  }

  // Function to handle saving selected categories
  void saveSelectedCategories() {
    List<String> selected = selectedCategories.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    // TODO: Implement persistence logic here (e.g., save to local storage or remote database)
    print('Selected categories: $selected');
    // Show a confirmation dialog or navigate back
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Categories Saved'),
          content: Text('Your selected categories have been saved.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Grid of categories
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Adjust for desired number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2, // Adjust for cell aspect ratio
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String category = categories[index];
                  bool isSelected = selectedCategories[category]!;
                  return GestureDetector(
                    onTap: () => toggleCategory(category),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[100] : Colors.grey[200],
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue[800] : Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Save button
            ElevatedButton(
              onPressed: saveSelectedCategories,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}