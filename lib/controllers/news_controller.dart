import 'package:get/get.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';

class NewsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Observable variables
  final RxList<NewsModel> topNews = <NewsModel>[].obs;
  final RxList<NewsModel> latestNews = <NewsModel>[].obs;
  final RxList<NewsModel> categoryNews = <NewsModel>[].obs;
  final RxList<NewsModel> searchResults = <NewsModel>[].obs;

  // Loading states
  final RxBool isLoadingTop = false.obs;
  final RxBool isLoadingLatest = false.obs;
  final RxBool isLoadingCategory = false.obs;
  final RxBool isLoadingSearch = false.obs;

  // UI state
  final RxString selectedCategory = 'Top News'.obs;
  final RxString searchQuery = ''.obs;

  // Available categories
  final List<String> categories = [
    'Top News',
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadTopHeadlines(),
      loadLatestNews(),
    ]);
  }

  Future<void> loadTopHeadlines() async {
    try {
      isLoadingTop.value = true;
      final news = await _apiService.getCategoryNews(category: 'business');
      topNews.assignAll(news.take(5).toList());
    } catch (e) {
      _showErrorSnackbar('Failed to load top headlines');
    } finally {
      isLoadingTop.value = false;
    }
  }

  Future<void> loadLatestNews() async {
    try {
      isLoadingLatest.value = true;
      final news = await _apiService.searchNews(query: 'latest');
      latestNews.assignAll(news);
    } catch (e) {
      _showErrorSnackbar('Failed to load latest news');
    } finally {
      isLoadingLatest.value = false;
    }
  }

  Future<void> loadCategoryNews(String category) async {
    try {
      isLoadingCategory.value = true;
      selectedCategory.value = category;

      List<NewsModel> news;
      if (category.toLowerCase() == 'top news') {
        news = await _apiService.getTopHeadlines();
      } else {
        news = await _apiService.getCategoryNews(category: category);
      }

      categoryNews.assignAll(news);
    } catch (e) {
      _showErrorSnackbar('Failed to load $category news');
    } finally {
      isLoadingCategory.value = false;
    }
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      Get.snackbar(
        'Search Error',
        'Please enter a search term',
        backgroundColor: Get.theme.colorScheme.surface,
        colorText: Get.theme.colorScheme.onSurface,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoadingSearch.value = true;
      searchQuery.value = query;
      final news = await _apiService.searchNews(query: query);
      searchResults.assignAll(news);

      if (news.isEmpty) {
        Get.snackbar(
          'No Results',
          'No news found for "$query"',
          backgroundColor: Get.theme.colorScheme.surface,
          colorText: Get.theme.colorScheme.onSurface,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      _showErrorSnackbar('Failed to search news');
    } finally {
      isLoadingSearch.value = false;
    }
  }

  Future<void> refreshNews() async {
    await loadInitialData();
    Get.snackbar(
      'Refreshed',
      'News updated successfully',
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.primary,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      colorText: Get.theme.colorScheme.error,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // Getters for combined loading states
  bool get isAnyLoading =>
      isLoadingTop.value ||
      isLoadingLatest.value ||
      isLoadingCategory.value ||
      isLoadingSearch.value;
}
