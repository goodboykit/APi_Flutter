import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ArticleService {
  static const String apiKey = '3ec3d706731d4b1eb5f41e5d9c202c57';
  static const String baseUrl = 'https://newsapi.org/v2';

  // Asynchronous function to fetch articles
  static Future<List<Article>> fetchArticles() async {
    try {
      // Make HTTP GET request
      final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Extract articles from JSON
        final List<dynamic> articlesJson = jsonData['articles'] ?? [];
        
        // Convert JSON articles to Article objects
        List<Article> articles = articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
        
        return articles;
      } else {
        // Handle error
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur
      print('Error fetching articles: $e');
      throw Exception('Error fetching articles: $e');
    }
  }

  // Asynchronous function to search articles
  static Future<List<Article>> searchArticles(String query) async {
    if (query.isEmpty) {
      return fetchArticles();
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> articlesJson = jsonData['articles'] ?? [];
        
        List<Article> articles = articlesJson
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
        
        return articles;
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching articles: $e');
      throw Exception('Error searching articles: $e');
    }
  }
}