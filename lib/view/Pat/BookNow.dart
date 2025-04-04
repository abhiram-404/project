import 'package:flutter/material.dart';

class Booknow extends StatefulWidget {
  final String doctorName;

  Booknow({required this.doctorName});

  @override
  _BooknowState createState() => _BooknowState();
}

class _BooknowState extends State<Booknow> {
  final TextEditingController _dateController = TextEditingController();
  int? selectedTimeSlot; // Track the selected time slot index

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade200,
              Colors.teal.shade200,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Name
              Center(
                child: Text(
                  widget.doctorName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Date Picker Section
              Text(
                'SELECT DATE',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Pick a date',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      // Format the date as desired
                      String formattedDate =
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 30),

              // Time Slot Section
              Text(
                'CHOOSE TIME SLOT',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  6,
                      (index) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // If the button is already selected, deselect it; otherwise, select it
                        selectedTimeSlot = selectedTimeSlot == index ? null : index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTimeSlot == index
                          ? Colors.teal.shade700
                          : Colors.white.withOpacity(0.9),
                      foregroundColor: selectedTimeSlot == index
                          ? Colors.white
                          : Colors.teal.shade800,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '${9 + index}:00',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              Spacer(),

              // Book Now Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle book now action
                    if (selectedTimeSlot != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Appointment Booked!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a time slot!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'BOOK NOW',
                    style: TextStyle(fontSize: 18, letterSpacing: 1.1),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
