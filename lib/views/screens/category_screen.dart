import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import '../widgets/news_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'news_view_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final NewsController newsController = Get.find<NewsController>();
  late String query;
  late bool isSearch;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>;
    query = arguments['query'] as String;
    isSearch = arguments['isSearch'] as bool;

    // Load appropriate data based on whether it's a search or category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isSearch) {
        newsController.searchNews(query);
      } else {
        newsController.loadCategoryNews(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RK NEWS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              Container(
                margin: const EdgeInsets.fromLTRB(24, 25, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSearch ? 'Search Results' : query,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isSearch) ...[
                            const SizedBox(height: 4),
                            Text(
                              'for "$query"',
                              style: TextStyle(
                                fontSize: 16,
                                color: Get.theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Obx(() {
                            final count = isSearch
                                ? newsController.searchResults.length
                                : newsController.categoryNews.length;
                            return Text(
                              '$count articles found',
                              style: TextStyle(
                                fontSize: 14,
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // News List
              Obx(() {
                if (_isLoading()) {
                  return LoadingWidget(
                    message: isSearch
                        ? 'Searching for news...'
                        : 'Loading $query news...',
                    height: MediaQuery.of(context).size.height - 300,
                  );
                }

                final newsList = isSearch
                    ? newsController.searchResults
                    : newsController.categoryNews;

                if (newsList.isEmpty) {
                  return EmptyStateWidget(
                    title: isSearch ? 'No Results Found' : 'No News Available',
                    description: isSearch
                        ? 'Try searching with different keywords'
                        : 'No news available in this category at the moment',
                    icon: isSearch ? Icons.search_off : Icons.newspaper,
                    onRetry: _refreshData,
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return NewsCard(
                      news: news,
                      onTap: () => _navigateToNewsView(news.url),
                    );
                  },
                );
              }),

              // Load More Button (for search results)
              if (isSearch)
                Obx(() {
                  if (newsController.searchResults.isNotEmpty &&
                      !newsController.isLoadingSearch.value) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _loadMoreResults(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'LOAD MORE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLoading() {
    return isSearch
        ? newsController.isLoadingSearch.value
        : newsController.isLoadingCategory.value;
  }

  Future<void> _refreshData() async {
    if (isSearch) {
      await newsController.searchNews(query);
    } else {
      await newsController.loadCategoryNews(query);
    }

    Get.snackbar(
      'Refreshed',
      isSearch ? 'Search results updated' : '$query news updated',
      backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      colorText: Get.theme.colorScheme.primary,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void _loadMoreResults() {
    // This would typically load more pages of results
    // For now, we'll just show a message
    Get.snackbar(
      'Load More',
      'Loading more results...',
      backgroundColor: Get.theme.colorScheme.surface,
      colorText: Get.theme.colorScheme.onSurface,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void _navigateToNewsView(String url) {
    Get.to(() => const NewsViewScreen(), arguments: url);
  }

  @override
  void dispose() {
    // Clear search results when leaving search screen
    if (isSearch) {
      newsController.clearSearch();
    }
    super.dispose();
  }
}
