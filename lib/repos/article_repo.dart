import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:khmer_news/models/article_model.dart';

Future<ArticleModel> fetchArticle() async {
  Uri url = Uri.http("127.0.0.1", "/api4flutter/read.php");
  Response res = await get(url);

  if (res.statusCode == 200) {
    return compute(articleModelFromJson, res.body);
  } else {
    throw Exception("Error Api Url");
  }
}

Future<String> insertArticle(Article article) async {
  Uri url = Uri.http("127.0.0.1", "/api4flutter/insert.php");
  Response res = await post(url, body: article.toJson());

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw Exception("Error Api Url");
  }
}

Future<String> updateArticle(Article article) async {
  Uri url = Uri.http("127.0.0.1", "/api4flutter/update.php");
  Response res = await post(url, body: article.toJson());

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw Exception("Error Api Url");
  }
}

Future<String> deleteArticle(Article article) async {
  Uri url = Uri.http("127.0.0.1", "/api4flutter/delete.php");
  Response res = await post(url, body: article.toJson());

  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw Exception("Error Api Url");
  }
}
