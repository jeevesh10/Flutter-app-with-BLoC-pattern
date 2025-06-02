import 'package:flutter/material.dart';

class Post {
  final String title;
  final String body;

  Post({required this.title, required this.body});
}

class CreatePostScreen extends StatefulWidget {
  final Function(Post) onPostCreated;

  const CreatePostScreen({super.key, required this.onPostCreated});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  bool _isSaving = false;

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final newPost = Post(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        widget.onPostCreated(newPost);
        setState(() {
          _isSaving = false;
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter the body text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon:
                      _isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.send),
                  label: Text(_isSaving ? 'Saving...' : 'Save Post'),
                  onPressed: _isSaving ? null : _savePost,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
