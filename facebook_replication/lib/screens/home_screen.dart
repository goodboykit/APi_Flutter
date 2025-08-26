import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../services/article_service.dart';
import '../widgets/custom_text.dart';
import '../widgets/facebook_widgets.dart';
import '../providers/theme_provider.dart';
import '../constants.dart';
import 'article_screen.dart';
import 'settings_screen.dart';
import '../widgets/add_dialog.dart';


// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article> articles = [];
  bool isLoading = true;
  bool _isUpdating = false;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  // Asynchronous function to load articles
  Future<void> loadArticles() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch articles asynchronously
      final fetchedArticles = await ArticleService.fetchArticles();
      
      // Update state with fetched articles
      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      // Handle errors
      setState(() {
        errorMessage = 'Failed to load articles. Please try again.';
        isLoading = false;
      });
    }
  }

  // Asynchronous function to search articles
  Future<void> searchArticles(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final searchResults = await ArticleService.searchArticles(query);
      
      setState(() {
        articles = searchResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to search articles. Please try again.';
        isLoading = false;
      });
    }
  }

  // Add this method for handling updates
  Future<void> _updateArticles() async {
    setState(() {
      _isUpdating = true;
    });

    await loadArticles(); 

    setState(() {
      _isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: FacebookColors.primaryGradient,
              ),
              child: const Text(
                'f',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Facebook',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () {
              // Focus search bar
            },
          ),
          IconButton(
            icon: const Icon(Icons.messenger_outline, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Messenger coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Enhancement 1: Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode 
                  ? FacebookColors.surfaceDark 
                  : FacebookColors.surfaceLight,
              border: Border(
                bottom: BorderSide(
                  color: themeProvider.isDarkMode 
                      ? FacebookColors.dividerDark 
                      : FacebookColors.dividerLight,
                  width: 0.5,
                ),
              ),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                hintStyle: TextStyle(
                  color: themeProvider.isDarkMode 
                      ? FacebookColors.textSecondaryDark 
                      : FacebookColors.textSecondaryLight,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: themeProvider.isDarkMode 
                      ? FacebookColors.textSecondaryDark 
                      : FacebookColors.textSecondaryLight,
                ),
                suffixIcon: searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          loadArticles();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  searchArticles(value);
                } else {
                  loadArticles();
                }
              },
            ),
          ),
          
          // Article List
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(FacebookColors.primaryBlue),
                        ),
                        const SizedBox(height: 16),
                        CustomText(
                          text: 'Loading articles...',
                          color: themeProvider.isDarkMode 
                              ? FacebookColors.textSecondaryDark 
                              : FacebookColors.textSecondaryLight,
                        ),
                      ],
                    ),
                  )
                : errorMessage.isNotEmpty
                    ? Center(
                        child: FacebookCard(
                          isDarkMode: themeProvider.isDarkMode,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: FacebookColors.errorColor,
                              ),
                              const SizedBox(height: 16),
                              CustomText(
                                text: errorMessage,
                                fontSize: 16,
                                color: FacebookColors.errorColor,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              FacebookButton(
                                text: 'Try Again',
                                icon: Icons.refresh,
                                onPressed: loadArticles,
                                backgroundColor: FacebookColors.primaryBlue,
                              ),
                            ],
                          ),
                        ),
                      )
                    : articles.isEmpty
                        ? Center(
                            child: FacebookCard(
                              isDarkMode: themeProvider.isDarkMode,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 64,
                                    color: themeProvider.isDarkMode 
                                        ? FacebookColors.textSecondaryDark 
                                        : FacebookColors.textSecondaryLight,
                                  ),
                                  const SizedBox(height: 16),
                                  const CustomText(
                                    text: 'No articles found',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: 'Pull to refresh or try searching for something else',
                                    fontSize: 14,
                                    color: themeProvider.isDarkMode 
                                        ? FacebookColors.textSecondaryDark 
                                        : FacebookColors.textSecondaryLight,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  FacebookButton(
                                    text: 'Refresh',
                                    icon: Icons.refresh,
                                    onPressed: loadArticles,
                                    backgroundColor: FacebookColors.primaryBlue,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              RefreshIndicator(
                                onRefresh: _updateArticles,
                                child: ListView.builder(
                              itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkMode 
                                    ? FacebookColors.cardDark 
                                    : FacebookColors.cardLight,
                                border: Border(
                                  bottom: BorderSide(
                                    color: themeProvider.isDarkMode 
                                        ? FacebookColors.dividerDark 
                                        : FacebookColors.dividerLight,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleScreen(
                                        article: article,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Article Header with Avatar
                                      Row(
                                        children: [
                                          FacebookAvatar(
                                            text: article.source?['name'] ?? 'N',
                                            size: 40,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: article.source?['name'] ?? 'Unknown Source',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText(
                                                  text: _formatDate(article.publishedAt ?? ''),
                                                  fontSize: 12,
                                                  color: themeProvider.isDarkMode 
                                                      ? FacebookColors.textSecondaryDark 
                                                      : FacebookColors.textSecondaryLight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // Article Title
                                      CustomText(
                                        text: article.title ?? 'No Title',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      
                                      // Article Description
                                      if (article.description != null)
                                        CustomText(
                                          text: article.description!,
                                          fontSize: 14,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      
                                      // Article Image
                                      if (article.urlToImage != null)
                                        Container(
                                          margin: const EdgeInsets.only(top: 12),
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(article.urlToImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      
                                      // Like and Comment Buttons
                                      Container(
                                        margin: const EdgeInsets.only(top: 12),
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: themeProvider.isDarkMode 
                                                  ? FacebookColors.dividerDark 
                                                  : FacebookColors.dividerLight,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: FacebookActionButton(
                                                icon: Icons.thumb_up_outlined,
                                                label: 'Like',
                                                iconColor: FacebookColors.likeColor,
                                                isDarkMode: themeProvider.isDarkMode,
                                                onPressed: () {
                                                  // Handle like action
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Liked!')),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: FacebookActionButton(
                                                icon: Icons.comment_outlined,
                                                label: 'Comment',
                                                iconColor: FacebookColors.commentColor,
                                                isDarkMode: themeProvider.isDarkMode,
                                                onPressed: () {
                                                  // Handle comment action
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Comment feature coming soon!')),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: FacebookActionButton(
                                                icon: Icons.share_outlined,
                                                label: 'Share',
                                                iconColor: FacebookColors.shareColor,
                                                isDarkMode: themeProvider.isDarkMode,
                                                onPressed: () {
                                                  // Handle share action
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Share feature coming soon!')),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                              // Loading overlay
                              if (_isUpdating)
                                Container(
                                  color: Colors.black54,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                            ],
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Map<String, String>>(
            context: context,
            builder: (context) => AddDialog(),
          );
          
          if (result != null) {
            // Handle the new post data
            print('New post: ${result['title']}');
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF1877f2),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'now';
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}