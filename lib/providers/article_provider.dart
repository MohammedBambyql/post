import 'package:flutter/material.dart';
import '../models/article.dart';
import '../db/database_helper.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _myArticles = [];

  List<Article> get myArticles => _myArticles;

  Future<void> loadMyArticles() async {
    _myArticles = await DatabaseHelper().getUserArticles();
    notifyListeners();
  }

  Future<void> addArticle(Article article) async {
    await DatabaseHelper().insertUserArticle(article);
    await loadMyArticles();
  }

  Future<void> deleteArticle(int id) async {
    await DatabaseHelper().deleteUserArticle(id);
    await loadMyArticles();
  }
}
