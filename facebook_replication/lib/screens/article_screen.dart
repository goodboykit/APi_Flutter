import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../widgets/custom_text.dart';
import '../providers/theme_provider.dart';
import '../constants.dart';
import 'article_details_screen.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailsScreen(article: article),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Source and Date
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: FacebookColors.primaryGradient,
                      border: Border.all(
                        color: FacebookColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        article.source?['name']?.substring(0, 1) ?? 'N',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: article.source?['name'] ?? 'Unknown Source',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        CustomText(
                          text: article.publishedAt ?? 'Date not available',
                          fontSize: 14,
                          color: themeProvider.isDarkMode 
                              ? FacebookColors.textSecondaryDark 
                              : FacebookColors.textSecondaryLight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              // Title
              CustomText(
                text: article.title ?? 'No Title',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16),
              
              // Author
              if (article.author != null)
                CustomText(
                  text: 'By ${article.author}',
                  fontSize: 16,
                  color: themeProvider.isDarkMode 
                      ? FacebookColors.textSecondaryDark 
                      : FacebookColors.textSecondaryLight,
                ),
              SizedBox(height: 16),
              
              // Image
              if (article.urlToImage != null)
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(article.urlToImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              
              // Description
              if (article.description != null)
                CustomText(
                  text: article.description!,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              SizedBox(height: 16),
              
              // Content
              if (article.content != null)
                CustomText(
                  text: article.content!,
                  fontSize: 16,
                ),
              SizedBox(height: 20),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle like
                    },
                    icon: Icon(Icons.thumb_up, color: Colors.white),
                    label: Text('Like'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FacebookColors.likeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle share
                    },
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FacebookColors.shareColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}