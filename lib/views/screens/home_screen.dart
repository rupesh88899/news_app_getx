import 'package:news_app/controllers/theme_controller.dart';
import 'package:news_app/views/widgets/search_bar.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/views/widgets/empty_state_widget.dart';
import 'package:news_app/views/widgets/news_card.dart';
import 'package:news_app/views/widgets/category_chip.dart';
import 'package:news_app/views/widgets/loading_widget.dart';
import 'package:news_app/views/widgets/section_header.dart';
import 'category_screen.dart';
import 'news_view_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsController newsController = Get.find<NewsController>();
    final TextEditingController searchController = TextEditingController();

    final ThemeController themeController = Get.find<ThemeController>();
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
            onPressed: () => newsController.refreshNews(),
          ),
          Obx(() {
            final isDark = themeController.themeMode.value == ThemeMode.dark;
            return IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip:
                  isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
              onPressed: () {
                themeController.setTheme(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                );
              },
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => newsController.refreshNews(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Search Bar
              SearchBar(
                controller: searchController,
                onSearchPressed: () =>
                    _handleSearch(newsController, searchController),
                onSubmitted: (value) =>
                    _handleSearch(newsController, searchController),
              ),

              // Category Navigation
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsController.categories.length,
                  itemBuilder: (context, index) {
                    final category = newsController.categories[index];
                    return Obx(() => CategoryChip(
                          category: category,
                          isSelected:
                              newsController.selectedCategory.value == category,
                          onTap: () => _navigateToCategory(category),
                        ));
                  },
                ),
              ),

              // Top Headlines Carousel
              const SectionHeader(title: 'Top Headlines'),
              Obx(() {
                if (newsController.isLoadingTop.value) {
                  return const LoadingWidget(
                    message: 'Loading top headlines...',
                    height: 200,
                  );
                }

                if (newsController.topNews.isEmpty) {
                  return const SizedBox(height: 200);
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 5),
                    ),
                    items: newsController.topNews.map((news) {
                      return Builder(
                        builder: (BuildContext context) {
                          return NewsCard(
                            news: news,
                            height: 200,
                            showDescription: false,
                            onTap: () => _navigateToNewsView(news.url),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }),

              // Latest News Section
              const SectionHeader(
                title: 'Latest News',
              ),
              Obx(() {
                if (newsController.isLoadingLatest.value) {
                  return const LoadingWidget(
                    message: 'Loading latest news...',
                    height: 300,
                  );
                }

                if (newsController.latestNews.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'No News Available',
                    description: 'Unable to load latest news at the moment.',
                    icon: Icons.newspaper,
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsController.latestNews.length,
                  itemBuilder: (context, index) {
                    final news = newsController.latestNews[index];
                    return NewsCard(
                      news: news,
                      onTap: () => _navigateToNewsView(news.url),
                    );
                  },
                );
              }),

              // Show More Button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToCategory('More News'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'SHOW MORE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSearch(
      NewsController controller, TextEditingController searchController) {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      Get.to(() => const CategoryScreen(), arguments: {
        'query': query,
        'isSearch': true,
      });
    } else {
      Get.snackbar(
        'Search',
        'Please enter a search term',
        backgroundColor: Get.theme.colorScheme.surface,
        colorText: Get.theme.colorScheme.onSurface,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _navigateToCategory(String category) {
    Get.to(() => const CategoryScreen(), arguments: {
      'query': category,
      'isSearch': false,
    });
  }

  void _navigateToNewsView(String url) {
    Get.to(() => const NewsViewScreen(), arguments: url);
  }
}
