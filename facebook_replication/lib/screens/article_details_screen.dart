import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../widgets/custom_text.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final Article article;
  final bool isEditMode;

  const ArticleDetailsScreen({
    Key? key, 
    required this.article,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  _ArticleDetailsScreenState createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late bool _isEditMode;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    _titleController = TextEditingController(text: widget.article.title);
    _descriptionController = TextEditingController(text: widget.article.description);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _saveChanges() {
    // Handle save logic
    setState(() {
      _isEditMode = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Article' : 'Article Details'),
        backgroundColor: const Color(0xFF1877f2),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.save : Icons.edit),
            onPressed: _isEditMode ? _saveChanges : _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isEditMode
                    ? TextField(
                        controller: _titleController,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter title',
                        ),
                      )
                    : CustomText(
                        text: widget.article.title ?? 'No Title',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
              ),
              const SizedBox(height: 20),
              
              // Article Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source Information
                      _buildDetailRow(
                        icon: Icons.source,
                        label: 'Source',
                        value: widget.article.source?['name'] ?? 'Unknown',
                      ),
                      const Divider(height: 24),
                      
                      // Author Information
                      _buildDetailRow(
                        icon: Icons.person,
                        label: 'Author',
                        value: widget.article.author ?? 'Unknown Author',
                      ),
                      const Divider(height: 24),
                      
                      // Published Date
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'Published',
                        value: _formatDate(widget.article.publishedAt),
                      ),
                      const Divider(height: 24),
                      
                      // URL
                      if (widget.article.url != null)
                        _buildDetailRow(
                          icon: Icons.link,
                          label: 'Article URL',
                          value: widget.article.url!,
                          isLink: true,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Description Section
              if (widget.article.description != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: 'Description',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      _isEditMode
                          ? TextField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter description',
                              ),
                            )
                          : CustomText(
                              text: widget.article.description!,
                              fontSize: 16,
                            ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              
              // Full Content
              if (widget.article.content != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: 'Full Content',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: widget.article.content!,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              
              // Action Buttons
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isEditMode) ...[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditMode = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877f2),
                        ),
                        child: const Text('Save'),
                      ),
                    ] else
                      ElevatedButton.icon(
                        onPressed: _toggleEditMode,
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Article'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877f2),
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1877f2), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                fontSize: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 4),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}