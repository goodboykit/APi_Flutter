import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../constants.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;
  bool _isActive = true; // Default to active

  Future<void> _handleAdd() async {
    setState(() {
      _isLoading = true;
    });

    // Extended loading time for screenshot purposes
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    Navigator.pop(context, {
      'title': _titleController.text,
      'author': _authorController.text,
      'content': _contentController.text,
      'isActive': _isActive.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
                ? [
                    FacebookColors.cardDark,
                    FacebookColors.surfaceDark,
                  ]
                : [
                    Colors.white,
                    Colors.blue.shade50,
                  ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1877f2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Create New Post',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? FacebookColors.textPrimaryDark : const Color(0xFF1877f2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_isLoading)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? FacebookColors.surfaceDark : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1877f2)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Creating your post...',
                        style: TextStyle(
                          color: isDark ? FacebookColors.textPrimaryDark : const Color(0xFF1877f2),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please wait while we process your content',
                        style: TextStyle(
                          color: isDark 
                              ? FacebookColors.textSecondaryDark 
                              : const Color(0xFF1877f2).withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // Title Field
              _buildTextField(
                controller: _titleController,
                label: 'Post Title',
                hint: 'What would you like to share?',
                icon: Icons.title,
                maxLines: 1,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Author Field
              _buildTextField(
                controller: _authorController,
                label: 'Author',
                hint: 'Your name',
                icon: Icons.person,
                maxLines: 1,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Content Field
              _buildTextField(
                controller: _contentController,
                label: 'Content',
                hint: 'Share your thoughts...',
                icon: Icons.article,
                maxLines: 4,
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // Active Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? FacebookColors.surfaceDark : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? FacebookColors.dividerDark : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: _isActive ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Post Visibility',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? FacebookColors.textPrimaryDark : Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            _isActive ? 'Active - Visible to all users' : 'Inactive - Hidden from feed',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green.shade100,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877f2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Post',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark ? FacebookColors.primaryBlue : const Color(0xFF1877f2),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? FacebookColors.textPrimaryDark : const Color(0xFF1877f2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? FacebookColors.textSecondaryDark : Colors.grey.shade400,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? FacebookColors.dividerDark : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? FacebookColors.dividerDark : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1877f2), width: 2),
            ),
            filled: true,
            fillColor: isDark ? FacebookColors.surfaceDark : Colors.white,
          ),
          style: TextStyle(
            color: isDark ? FacebookColors.textPrimaryDark : Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}