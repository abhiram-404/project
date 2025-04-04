import 'package:flutter/material.dart';

class Map extends StatelessWidget {
  const Map({super.key});

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
        body: TabBarView(
          children: [
            MapScreen(assetPath: 'asset/map.png'),
            MapScreen(assetPath: 'asset/map2.png'),
            MapScreen(assetPath: 'asset/map3.png'),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final String assetPath;
  const MapScreen({required this.assetPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200, // Light background for better contrast
      child: InteractiveViewer(
        panEnabled: true, // Allow panning
        minScale: 1.0, // Minimum zoom scale
        maxScale: 5.0, // Maximum zoom scale
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding around the image
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain, // Ensure the image scales properly
          ),
        ),
      ),
    );
  }
}
