import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';

class MyArticlesPage extends StatelessWidget {
  const MyArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myArticles = Provider.of<ArticleProvider>(context).myArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Articles'),
      ),
      body: myArticles.isEmpty
          ? const Center(child: Text('Don\'t have any articles yet!'))
          : ListView.builder(
              itemCount: myArticles.length,
              itemBuilder: (context, index) {
                final article = myArticles[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Text(
                      article.body.length > 100
                          ? '${article.body.substring(0, 100)}...'
                          : article.body,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        Provider.of<ArticleProvider>(context, listen: false)
                            .deleteArticle(article.id!);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Article deleted!')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
