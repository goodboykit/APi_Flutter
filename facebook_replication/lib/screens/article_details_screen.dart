import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../widgets/custom_text.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailsScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        backgroundColor: Color(0xFF1877f2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Title
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomText(
                  text: article.title ?? 'No Title',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              
              // Article Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source Information
                      _buildDetailRow(
                        icon: Icons.source,
                        label: 'Source',
                        value: article.source?['name'] ?? 'Unknown',
                      ),
                      Divider(height: 24),
                      
                      // Author Information
                      _buildDetailRow(
                        icon: Icons.person,
                        label: 'Author',
                        value: article.author ?? 'Unknown Author',
                      ),
                      Divider(height: 24),
                      
                      // Published Date
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Published',
                        value: _formatDate(article.publishedAt),
                      ),
                      Divider(height: 24),
                      
                      // URL
                      if (article.url != null)
                        _buildDetailRow(
                          icon: Icons.link,
                          label: 'Article URL',
                          value: article.url!,
                          isLink: true,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Full Description
              if (article.description != null)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Description',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8),
                      CustomText(
                        text: article.description!,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              
              // Full Content
              if (article.content != null)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Full Content',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8),
                      CustomText(
                        text: article.content!,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              
              // Action Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Open article in browser
                    // You can implement URL launcher here
                  },
                  icon: Icon(Icons.open_in_browser),
                  label: Text('Open in Browser'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1877f2),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF1877f2), size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                fontSize: 14,
                color: Colors.grey[600],
              ),
              SizedBox(height: 4),
              CustomText(
                text: value,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLink ? Colors.blue : null,
                maxLines: isLink ? 1 : null,
                overflow: isLink ? TextOverflow.ellipsis : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown Date';
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}