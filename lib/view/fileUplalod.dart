/*
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  File? _selectedImage;
  File? _selectedPdf;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedPdf = File(result.files.single.path!);
      });
    }
  }

  // Method to upload file to Firebase Storage
  Future<void> _uploadFile() async {
    if (_selectedImage == null || _selectedPdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select both an image and a PDF file.')));
      return;
    }
    ;

    String imageFileName =
        'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    String pdfFileName = 'pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf';

    try {
      // Upload image
      TaskSnapshot imageSnapshot =
      await _storage.ref(imageFileName).putFile(_selectedImage!);
      String imageUrl = await imageSnapshot.ref.getDownloadURL();

      // Upload PDF
      TaskSnapshot pdfSnapshot =
      await _storage.ref(pdfFileName).putFile(_selectedPdf!);
      String pdfUrl = await pdfSnapshot.ref.getDownloadURL();

      // Save metadata to Firestore
      await _firestore.collection('files').add({
        'imageUrl': imageUrl,
        'pdfUrl': pdfUrl,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'name': _nameController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Files uploaded successfully.')));
      _clearFields();
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  void _clearFields() {
    setState(() {
      _selectedImage = null;
      _selectedPdf = null;
    });
    _descriptionController.clear();
    _priceController.clear();
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Upload to Firebase")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage == null
                  ? Text("No file selected")
                  : Image.file(
                _selectedImage!,
                height: 150,
              ),
              // Show the selected image if any
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _pickImage, child: Text('Select Image')),
              SizedBox(height: 20),
              _selectedPdf != null
                  ? Text('PDF Selected: ${_selectedPdf!.path.split('/').last}')
                  : Text('No PDF selected'),
              SizedBox(height: 10),
              ElevatedButton(onPressed: _pickPdf, child: Text('Select PDF')),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _uploadFile, child: Text('Upload Files')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.canPop(context);
                  },
                  child: Text("Imags")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.canPop(context);
                  },
                  child: Text("Meet me")),
            ],
          ),
        ),
      ),
    );
  }
}*/

// Import necessary packages
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedFile;
  String? _fileType;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileType = result.files.single.extension;
      });
    }
  }

  Future<String> _uploadFile(File file, String fileType) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('$fileType/$fileName');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _uploadData() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a file to upload!')),
      );
      return;
    }

    try {
      final fileUrl = await _uploadFile(_selectedFile!, _fileType ?? 'unknown');

      await _firestore.collection('uploads').add({
        'title': _titleController.text,
        'year': _yearController.text,
        'duration': _durationController.text,
        'rating': _ratingController.text,
        'category': _categoryController.text,
        'description': _descriptionController.text,
        'fileUrl': fileUrl,
        'fileType': _fileType,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data uploaded successfully!')),
      );

      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading data: $e')),
      );
    }
  }

  void _clearFields() {
    _titleController.clear();
    _yearController.clear();
    _durationController.clear();
    _ratingController.clear();
    _categoryController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedFile = null;
      _fileType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Year'),
              ),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration'),
              ),
              TextField(
                controller: _ratingController,
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Select File'),
              ),
              SizedBox(height: 16),
              if (_selectedFile != null)
                Text('Selected File: ${_selectedFile!.path.split('/').last}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadData,
                child: Text('Upload Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
