import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryService {
  static const String apiEndpoint = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  static Future<Map<String, String>> getMeaning(String word) async {
    final response = await http.get(Uri.parse('$apiEndpoint$word'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        var meanings = data[0]['meanings'] as List<dynamic>;
        if (meanings.isNotEmpty) {
          var definitions = meanings[0]['definitions'] as List<dynamic>;
          if (definitions.isNotEmpty) {
            var definition = definitions[0]['definition'] ?? 'No definition available';
            var example = definitions[0]['example'] ?? 'No example available';
            return {'meaning': definition, 'example': example};
          }
        }
      }
      return {'meaning': 'Word not found', 'example': ''};
    } else {
      throw Exception('Failed to load meaning');
    }
  }
}

