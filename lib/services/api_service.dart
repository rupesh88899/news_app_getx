import 'dart:convert';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/news_model.dart';

class ApiService extends GetxService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  // static const String _apiKey1 = 'a230c894906543d8b621f13a87cfefde';
  static const String _apiKey2 = '548b0bfc33b7486693f96463f240cf31';

  // Rotate API keys to handle rate limits
  String get _currentApiKey => _apiKey2;

  Future<List<NewsModel>> getTopHeadlines({String country = 'us'}) async {
    try {
      final url =
          '$_baseUrl/top-headlines?country=$country&apiKey=$_currentApiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        return articles.map((article) => NewsModel.fromJson(article)).toList();
      } else {
        _handleApiError(response);
        return [];
      }
    } catch (e) {
      _handleException(e);
      return [];
    }
  }

  Future<List<NewsModel>> searchNews({
    required String query,
    String? from,
    String sortBy = 'publishedAt',
    int pageSize = 30,
  }) async {
    try {
      final fromDate = from ?? _getDefaultFromDate();
      final url =
          '$_baseUrl/everything?q=$query&from=$fromDate&sortBy=$sortBy&pageSize=$pageSize&apiKey=$_currentApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        return articles
            .where((article) => article['urlToImage'] != null)
            .take(pageSize)
            .map((article) => NewsModel.fromJson(article))
            .toList();
      } else {
        _handleApiError(response);
        return [];
      }
    } catch (e) {
      _handleException(e);
      return [];
    }
  }

  Future<List<NewsModel>> getCategoryNews({
    required String category,
    String country = 'us',
  }) async {
    try {
      final url =
          '$_baseUrl/top-headlines?country=$country&category=${category.toLowerCase()}&apiKey=$_currentApiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        return articles.map((article) => NewsModel.fromJson(article)).toList();
      } else {
        _handleApiError(response);
        return [];
      }
    } catch (e) {
      _handleException(e);
      return [];
    }
  }

  void _handleApiError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        Get.snackbar(
          'Error',
          'Bad Request. Please check your search terms.',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 401:
        Get.snackbar(
          'Error',
          'API key is invalid.',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 429:
        Get.snackbar(
          'Rate Limited',
          'Too many requests. Please try again later.',
          backgroundColor: Get.theme.colorScheme.warning.withOpacity(0.1),
          colorText: Get.theme.colorScheme.warning,
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 500:
        Get.snackbar(
          'Server Error',
          'Something went wrong on our end. Please try again.',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.TOP,
        );
        break;
      default:
        Get.snackbar(
          'Error',
          'Failed to load news. Please try again.',
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          colorText: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.TOP,
        );
    }
  }

  void _handleException(dynamic error) {
    Get.snackbar(
      'Connection Error',
      'Please check your internet connection and try again.',
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      colorText: Get.theme.colorScheme.error,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

  String _getDefaultFromDate() {
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(const Duration(days: 30));
    return '${oneMonthAgo.year}-${oneMonthAgo.month.toString().padLeft(2, '0')}-${oneMonthAgo.day.toString().padLeft(2, '0')}';
  }
}

extension on ColorScheme {
  get warning => null;
}
