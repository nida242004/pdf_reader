import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'pdf_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  void _pickPDF(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PDFViewerScreen(filePath: filePath)),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('READING MADE EASIER'), centerTitle: true, toolbarHeight: 80),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _pickPDF(context),
          icon: const Icon(
            Icons.upload_file,
            size: 24,
            color: Colors.white,
          ), // Upload icon
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              Text('UPLOAD PDF', style: TextStyle(fontSize: 18)),
              // Add space between icon and text
            ],
          ),
          style: ElevatedButton.styleFrom(
            minimumSize:
                const Size(200, 60), // Make the button bigger (width x height)
            padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 30), // Adjust padding for bigger button
          ),
        ),
      ),
    );
  }
}
