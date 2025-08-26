import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AddDialog extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleAdd() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    Navigator.pop(context, {
      'title': _titleController.text,
      'content': _contentController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleAdd,
          child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}