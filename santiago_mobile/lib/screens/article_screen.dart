import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
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
              
              // Image or Placeholder
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: article.urlToImage == null 
                      ? (themeProvider.isDarkMode ? FacebookColors.surfaceDark : Colors.grey.shade100)
                      : null,
                  border: article.urlToImage == null 
                      ? Border.all(
                          color: themeProvider.isDarkMode ? FacebookColors.dividerDark : Colors.grey.shade300,
                          width: 2,
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
                    ? _buildArticlePlaceholder(themeProvider.isDarkMode)
                    : null,
              ),
              const SizedBox(height: 20),
              
              // Description
              if (article.description != null)
                CustomText(
                  text: article.description!,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              const SizedBox(height: 16),
              
              // Content
              if (article.content != null)
                CustomText(
                  text: article.content!,
                  fontSize: 16,
                ),
              const SizedBox(height: 20),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle like
                    },
                    icon: const Icon(Icons.thumb_up, color: Colors.white),
                    label: const Text('Like'),
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
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share'),
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

  Widget _buildArticlePlaceholder(bool isDark) {
    return SizedBox(
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? FacebookColors.surfaceDark : Colors.grey.shade200,
                  border: Border.all(
                    color: isDark ? FacebookColors.dividerDark : Colors.grey.shade400,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: 50,
                  color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 20),
              // Box icon with text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? FacebookColors.surfaceDark.withOpacity(0.5) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? FacebookColors.dividerDark : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 24,
                      color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'No Image Available',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
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