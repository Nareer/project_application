import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // สำหรับการจัดการไฟล์ภาพ

class BorrowBookAppAdd extends StatelessWidget {
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
  int _selectedIndex = 1;
  final List<String> _categories = ['Action', 'Drama', 'Comedy', 'Thriller'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
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
  
  void _showBorrowDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Confirmation'),
          content: Text('Do you want to add this book?'),
          actions: [
            TextButton(
              onPressed: () {
                print('Category: $selectedCategory');
                print('Book ID: ${bookIdController.text}');
                print('Book Name: ${bookNameController.text}');
                print('Image Path: $_imagePath');
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Movie', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
        leading: Padding(padding: const EdgeInsets.only(left: 16.0), child: Image.asset('assets/image/video-player.png')),
        actions: [Padding(padding: EdgeInsets.all(8.0), child: CircleAvatar(backgroundImage: AssetImage('assets/image/proflie.jpg')))],
        flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF4c8479), Color(0xFF2b5f56)], begin: Alignment.centerLeft, end: Alignment.centerRight))),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade300], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(_imagePath!), fit: BoxFit.cover, height: 200),
                    )
                  : Container(height: 200, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[300]), child: Center(child: Text('No Image Selected'))),
              SizedBox(height: 16),
              IconButton(icon: Icon(Icons.add_a_photo), onPressed: _pickImage, tooltip: 'Add Image'),
              SizedBox(height: 16),
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
                      SizedBox(height: 16),
                      Text('Movie ID:', style: TextStyle(fontSize: 16)),
                      TextField(controller: bookIdController, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter Movie ID')),
                      SizedBox(height: 16),
                      Text('Movie Name:', style: TextStyle(fontSize: 16)),
                      TextField(controller: bookNameController, decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Enter Movie Name')),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 243, 33, 33)), child: Text('Cancel', style: TextStyle(color: Colors.white))),
                          ElevatedButton(onPressed: _showBorrowDialog, style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 132, 141, 49)), child: Text('Add', style: TextStyle(color: Colors.white))),
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
