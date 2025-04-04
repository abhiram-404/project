import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  const Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Map',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 4.0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blue.shade100,
            indicatorColor: Colors.amber,
            indicatorWeight: 4.0,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Floor 1'),
              Tab(text: 'Floor 2'),
              Tab(text: 'Floor 3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MapScreen(
              assetPath: 'asset/floor_1.png',
              dropdownItems: [
                'CAUSALITY',
                'CARDIOLOGY ROOM - 001',
                'CARDIOLOGY ROOM - 002',
                'PEDIATRICS ROOM - 003',
                'PEDIATRICS ROOM - 004',
                'ORTHOPEDICS ROOM - 005',
                'ORTHOPEDICS ROOM - 006',
                'NEUROLOGY ROOM - 007',
                'NEUROLOGY ROOM - 008',
                'GENERAL MEDICINE - 009',
                'GENERAL MEDICINE - 010'
              ],
            ),
            MapScreen(
              assetPath: 'asset/floor_2.png',
              dropdownItems: [
                'I C U',
                'OPERATION THEATRE',
                'DENTIST ROOM - 011',
                'DENTIST ROOM - 012',
                'OPHTHALMOLOGY ROOM - 013',
                'OPHTHALMOLOGY ROOM - 014',
                'GYNAECOLOGY ROOM - 015',
                'GYNAECOLOGY ROOM - 016',
                'DERMATOLOGY ROOM - 017',
                'DERMATOLOGY ROOM - 018',
                'ENT ROOM - 019',
                'ENT ROOM - 020'
              ],
            ),
            MapScreen(
              assetPath: 'asset/map3.png',
              dropdownItems: ['Item X', 'Item Y', 'Item Z'],
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final String assetPath;
  final List<String> dropdownItems;

  const MapScreen({
    required this.assetPath,
    required this.dropdownItems,
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Add "Select a location" as the default option
    _selectedValue = "Select a location";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown at the top
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedValue,
            items: [
              // Add "Select a location" as the first item
              const DropdownMenuItem<String>(
                value: "Select a location",
                child: Text(
                  "Select a location",
                  style: TextStyle(color: Colors.grey), // Styled as disabled
                ),
              ),
              ...widget.dropdownItems.map(
                    (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
            ],
            onChanged: (value) {
              // Avoid allowing "Select a location" to be reselected
              if (value != "Select a location") {
                setState(() {
                  _selectedValue = value;
                });
              }
            },
            isExpanded: true,
            hint: const Text("Select a location"),
          ),
        ),
        // Interactive map below
        Expanded(
          child: Container(
            color: Colors.grey.shade200, // Light background for better contrast
            child: InteractiveViewer(
              panEnabled: true, // Allow panning
              minScale: 1.0, // Minimum zoom scale
              maxScale: 5.0, // Maximum zoom scale
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Add padding around the image
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.contain, // Ensure the image scales properly
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
