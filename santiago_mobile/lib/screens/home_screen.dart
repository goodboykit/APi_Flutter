import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
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

  // Method to add new articles to the list
  void _addNewArticle(Map<String, String> articleData) {
    final newArticle = Article(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: articleData['title'],
      author: articleData['author'],
      description: articleData['content'], // Using content as description for now
      content: articleData['content'],
      publishedAt: DateTime.now().toIso8601String(),
      source: {'name': 'User Created', 'id': 'user'},
      url: null,
      urlToImage: null,
      isActive: articleData['isActive'] == 'true',
    );

    setState(() {
      // Add new article to the beginning of the list
      articles.insert(0, newArticle);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article "${articleData['title']}" added successfully!')),
    );
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
            icon: const Icon(Icons.person_outline, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
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
                            return _buildArticleCard(article, themeProvider, context);
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
            builder: (context) => const AddDialog(),
          );
          
          if (result != null) {
            // Add the new article to the list
            _addNewArticle(result);
          }
        },
        backgroundColor: const Color(0xFF1877f2),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildArticleCard(Article article, dynamic themeProvider, BuildContext context) {
    final isDark = themeProvider.isDarkMode;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? FacebookColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Image at Top
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: article.urlToImage != null ? null : (isDark ? FacebookColors.surfaceDark : Colors.grey.shade100),
                border: article.urlToImage == null 
                    ? Border.all(
                        color: isDark ? FacebookColors.dividerDark : Colors.grey.shade300,
                        width: 2,
                        style: BorderStyle.solid,
                      )
                    : null,
                image: article.urlToImage != null 
                    ? DecorationImage(
                        image: NetworkImage(article.urlToImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: article.urlToImage == null
                  ? _buildImagePlaceholder(isDark)
                  : Stack(
                      children: [
                        // Active status indicator overlay
                        if (article.isActive)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Active',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? FacebookColors.textPrimaryDark : const Color(0xFF1877f2),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Author
                  if (article.author != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? FacebookColors.surfaceDark : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: isDark ? FacebookColors.primaryBlue : Colors.blue.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'By ${article.author}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? FacebookColors.textPrimaryDark : Colors.blue.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  
                  // Content Preview
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade700,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Footer with source and date
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1877f2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            article.source?['name']?.substring(0, 1) ?? 'N',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.source?['name'] ?? 'Unknown Source',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark ? FacebookColors.textPrimaryDark : Colors.black87,
                              ),
                            ),
                            Text(
                              _formatDate(article.publishedAt ?? ''),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Active status for articles without images
                      if (article.urlToImage == null && article.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(bool isDark) {
    return Stack(
      children: [
        // Background with dashed border pattern
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: isDark ? FacebookColors.dividerDark : Colors.grey.shade400,
              strokeWidth: 2,
              dashLength: 8,
              spaceLength: 6,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Large X icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? FacebookColors.surfaceDark : Colors.grey.shade200,
                      border: Border.all(
                        color: isDark ? FacebookColors.dividerDark : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 40,
                      color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Box icon with X
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? FacebookColors.surfaceDark.withOpacity(0.5) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? FacebookColors.dividerDark : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: 20,
                          color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No Image Available',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.spaceLength = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw dashed border
    _drawDashedLine(canvas, paint, Offset.zero, Offset(size.width, 0)); // Top
    _drawDashedLine(canvas, paint, Offset(size.width, 0), Offset(size.width, size.height)); // Right
    _drawDashedLine(canvas, paint, Offset(size.width, size.height), Offset(0, size.height)); // Bottom
    _drawDashedLine(canvas, paint, Offset(0, size.height), Offset.zero); // Left
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    final double totalLength = (end - start).distance;
    final double dashCount = (totalLength / (dashLength + spaceLength));
    
    for (int i = 0; i < dashCount; i++) {
      final double startDistance = i * (dashLength + spaceLength);
      final double endDistance = startDistance + dashLength;
      
      if (startDistance < totalLength) {
        final Offset dashStart = start + (end - start) * (startDistance / totalLength);
        final Offset dashEnd = start + (end - start) * (math.min(endDistance, totalLength) / totalLength);
        canvas.drawLine(dashStart, dashEnd, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}