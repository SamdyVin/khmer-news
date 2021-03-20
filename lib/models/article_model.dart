// To parse this JSON data, do
//
//     final articleModel = articleModelFromJson(jsonString);

import 'dart:convert';

ArticleModel articleModelFromJson(String str) => ArticleModel.fromJson(json.decode(str));

String articleModelToJson(ArticleModel data) => json.encode(data.toJson());

class ArticleModel {
  ArticleModel({
    this.articles,
  });

  final List<Article> articles;

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
    articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Article {
  Article({
    this.aid,
    this.title,
    this.body,
    this.date,
    this.img,
  });

  final String aid;
  final String title;
  final String body;
  final DateTime date;
  final String img;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    aid: json["aid"],
    title: json["title"],
    body: json["body"],
    date: DateTime.parse(json["date"]),
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "aid": aid,
    "title": title,
    "body": body,
    "date": date.toIso8601String(),
    "img": img,
  };
}
