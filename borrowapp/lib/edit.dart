import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BorrowBookAppEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BorrowBookScreen(),
    );
  }
}

class BorrowBookScreen extends StatefulWidget {
  @override
  _BorrowBookScreenState createState() => _BorrowBookScreenState();
}

class _BorrowBookScreenState extends State<BorrowBookScreen> {
  final TextEditingController bookIdController = TextEditingController();
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  
  String? _imagePath, selectedCategory;
  bool _isActive = true;
  int _selectedIndex = 1;

  final List<String> _categories = ['Action', 'Drama', 'Comedy', 'Thriller'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _imagePath = pickedFile.path);
  }

  void _showBorrowDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Confirmation'),
        content: Text('Do you want to add this book?'),
        actions: [
          TextButton(
            onPressed: () {
              print('Category: $selectedCategory');
              print('Book ID: ${bookIdController.text}');
              print('Book Name: ${bookNameController.text}');
              print('Image Path: $_imagePath');
              print('Status: ${_isActive ? "Active" : "Inactive"}');
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('No')),
        ],
      ),
    );
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add New Category'),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(hintText: 'Enter category name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                setState(() {
                  _categories.add(categoryController.text);
                  selectedCategory = categoryController.text;
                  categoryController.clear();
                });
              }
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Movie', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/image/video-player.png'),
        ),
        actions: [Padding(padding: EdgeInsets.all(8.0), child: CircleAvatar(backgroundImage: AssetImage('assets/image/proflie.jpg')))],
        backgroundColor: Color(0xFF4c8479),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _imagePath != null
                  ? Image.file(File(_imagePath!), fit: BoxFit.cover, height: 200)
                  : Container(height: 200, color: Colors.grey[300], child: Center(child: Text('No Image Selected'))),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(icon: Icon(Icons.add_a_photo), onPressed: _pickImage)]),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category:', style: TextStyle(fontSize: 16)),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        hint: Text('Select Category'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue;
                            if (newValue == 'Add New Category') _addNewCategory();
                          });
                        },
                        items: [..._categories.map((category) => DropdownMenuItem(value: category, child: Text(category))), DropdownMenuItem(value: 'Add New Category', child: Text('Add New Category'))],
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                      Text('Movie ID:', style: TextStyle(fontSize: 16)),
                      TextField(controller: bookIdController, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter Movie ID')),
                      Text('Movie Name:', style: TextStyle(fontSize: 16)),
                      TextField(controller: bookNameController, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter Movie Name')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status: ${_isActive ? "Active" : "Disable"}', style: TextStyle(fontSize: 16)),
                          Switch(value: _isActive, onChanged: (value) => setState(() => _isActive = value)),
                        ],
                      ),
                      Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                         ElevatedButton(
                           onPressed: () {
                              // Handle the Cancel action here
                           },
                          style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.red, // Set your desired background color
                           foregroundColor: Colors.white, // Set the text color
                            ),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: _showBorrowDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Set your desired background color
                              foregroundColor: Colors.white, // Set the text color
                            ),
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4c8479), Color(0xFF2b5f56)], begin: Alignment.topLeft, end: Alignment.topRight)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.movie_rounded), label: 'Lists'),
            BottomNavigationBarItem(icon: Icon(Icons.space_dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Log out'),
          ],
        ),
      ),
    );
  }
}
