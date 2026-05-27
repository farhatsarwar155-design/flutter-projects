import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String _apiKey = 'AIzaSyBKQ5mibtJscuzY_g9PvaD31zKkmh5ovvM';

  // ✅ UPDATED: Latest model name (gemini-1.5-flash is free and fast)
  static const String _model = 'gemini-1.5-flash';

  // ✅ UPDATED: API version v1 instead of v1beta
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1/models/$_model:generateContent';

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': userMessage
                }
              ]
            }
          ],
          // ✅ OPTIONAL: Generation config for better responses
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 2048,
            'topP': 0.8,
            'topK': 40
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ UPDATED: Better response parsing with null checks
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {

          final botResponse = data['candidates'][0]['content']['parts'][0]['text'];
          return botResponse ?? 'Sorry, I could not generate a response.';
        } else {
          return 'Sorry, I received an empty response. Please try again.';
        }
      } else if (response.statusCode == 404) {
        // Specific error for model not found
        return 'Error: Model not found (404). Please check if the API key is valid and the model name is correct.';
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        return 'Error ${response.statusCode}: $errorMessage';
      }
    } catch (e) {
      return 'Error: Failed to connect to AI service. Please check your internet connection.\nDetails: $e';
    }
  }
}