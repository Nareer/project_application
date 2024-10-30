import 'package:flutter/material.dart';

class BorrowBookAppRequest extends StatelessWidget {
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
  TextEditingController returnDateController = TextEditingController();
  int _selectedIndex = 1; // Start with the "Assets Lists" tab selected

  // Function to show date picker
  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // Format the selected date
        returnDateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // Method to show dialog alert
  void _showBorrowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Borrow Confirmation'),
          content: Text('Do you want to borrow this movie?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle borrow action here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  // Method to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String borrowDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"; // Get today's date

    return Scaffold(
      appBar: AppBar(
        title: Text('Borrow Movie', style: TextStyle(color: Colors.white, fontSize: 24)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/image/video-player.png'),
        ),
        actions: [
          CircleAvatar(backgroundImage: AssetImage('assets/image/proflie.jpg')),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF4c8479), Color(0xFF2b5f56)]),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), spreadRadius: 5, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/image/avengers.jpg', fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Action', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Book ID: A0005', style: TextStyle(fontSize: 16)),
                    Text('Book Name: AVENGERS', style: TextStyle(fontSize: 16)),
                    Text('Borrow Date: $borrowDate', style: TextStyle(fontSize: 16)), // Use the current date
                    TextField(
                      controller: returnDateController,
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: 'Return Date',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectReturnDate(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle back action here
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: Text('Back', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: _showBorrowDialog,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: Text('Borrow', style: TextStyle(color: Colors.white)),
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
