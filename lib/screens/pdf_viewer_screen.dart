import 'package:flutter/material.dart';
import 'package:pdf_reader/utils/dictionary.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerScreen extends StatefulWidget {
  final String filePath;

  const PDFViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PdfControllerPinch _pdfController;
  String wordMeaning = '';
  bool isWordMeaningVisible = false;
  final TextEditingController _wordController = TextEditingController();

  int currentPage = 1; // Current page number
  int totalPages = 1; // Total number of pages

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.filePath),
    );

    // Listener for page changes
    _pdfController.addListener(() {
      setState(() {
        currentPage = _pdfController.page ?? 1;
        totalPages = _pdfController.pagesCount ?? 1;
      });
    });
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  void _fetchMeaning(String word) async {
    try {
      Map<String, String> result = await DictionaryService.getMeaning(word);
      setState(() {
        wordMeaning =
            'Definition: ${result['meaning']}\n\nExample: ${result['example']}';
        isWordMeaningVisible = true;
      });
    } catch (e) {
      setState(() {
        wordMeaning = 'Error fetching meaning';
        isWordMeaningVisible = true;
      });
    }
  }

  void _closePopup() {
    setState(() {
      isWordMeaningVisible = false;
      wordMeaning = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for the screen
      appBar: AppBar(
        title: const Text('Understand & Read', style: TextStyle(fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () async {
                // Close the existing popup if it is visible
                if (isWordMeaningVisible) {
                  setState(() {
                    isWordMeaningVisible = false;
                    wordMeaning = ''; // Clear the meaning as well
                  });
                }

                // Open the word input dialog
                String? word = await _showWordInputDialog(context);
                if (word != null && word.isNotEmpty) {
                  _fetchMeaning(word);
                }
              },
              child: Container(
                width: 40, // Adjust size for the circle
                height: 40, // Adjust size for the circle
                decoration: BoxDecoration(
                  color: Colors.purple[50], // Background color for the circle
                  shape: BoxShape.circle, // Makes it a circle
                ),
                child: Icon(
                  Icons.manage_search,
                  color: Colors.purple[800], // Icon color
                  size: 30, // Adjust icon size
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PdfViewPinch(controller: _pdfController),
          // Display page numbers on the side
          Positioned(
            top: 20,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[800]?.withOpacity(0.8), // Semi-transparent
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Page $currentPage / $totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isWordMeaningVisible)
            Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Padding to prevent touching edges
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850], // Dark background for popup
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Meaning:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(wordMeaning,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _closePopup,
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.purple[200]),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<String?> _showWordInputDialog(BuildContext context) {
    _wordController.clear(); // Clear the text input before showing the dialog
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: AlertDialog(
            backgroundColor: Colors.grey[850], // Dark background for dialog
            title:
                const Text('Enter Word', style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: _wordController,
              style:
                  const TextStyle(color: Colors.white), // White text for input
              decoration: InputDecoration(
                hintText: 'Type a word',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[700],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _wordController.clear(); // Clear the input if canceled
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  String word = _wordController.text;
                  _wordController.clear(); // Clear the input after submission
                  Navigator.pop(context, word);
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple[200]),
                child: const Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }
}
