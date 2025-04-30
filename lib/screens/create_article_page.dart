import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  void _saveArticle() {
    if (_formKey.currentState!.validate()) {
      final newArticle = Article(
        id: 0, // ID سيتم توليده تلقائياً
        title: _titleController.text,
        body: _bodyController.text,
      );

      Provider.of<ArticleProvider>(context, listen: false)
          .addArticle(newArticle)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة المقالة')),
        );
        _titleController.clear();
        _bodyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء مقالة جديدة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان المقالة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'أدخل العنوان' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'المحتوى',
                  border: OutlineInputBorder(),
                ),
                maxLines: 6,
                validator: (value) =>
                    value == null || value.isEmpty ? 'أدخل المحتوى' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveArticle,
                child: const Text('إضافة المقالة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
