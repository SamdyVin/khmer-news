import 'package:khmer_news/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khmer_news/pages/create_post.dart';
import 'package:khmer_news/pages/detail_post.dart';
import 'package:khmer_news/pages/edit_post.dart';
import 'package:khmer_news/repos/article_repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khmer News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<ArticleModel> data;
  List<Article> posts;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      data = fetchArticle();
    });
  }

  Future refresh() {
    setState(() {
      data = fetchArticle();
    });
    return data;
  }

  get _buildPostList {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        itemBuilder: (_, index) {
          return _buildPost(posts[index]);
//          return Post(article: posts[index]);
        },
        itemCount: posts.length,
      ),
    );
  }

  void deleteDataHandler(Article _article) {
    deleteArticle(_article).then((value) {
      if (value == "succeed") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Deleted Successfully"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to delete data!"),
          backgroundColor: Colors.red,
        ));
      }
    });
    setState(() {
      posts.remove(_article);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Khmer Post"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CreatePostPage()))
                  .then((value) {
                refresh();
              });
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<ArticleModel>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              posts = snapshot.data.articles;
              return _buildPostList;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  _buildPost(Article article) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DetailPostPage(
            article: article,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(article.img),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(article.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white38,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (_) => EditPostPage(
                                    article: article,
                                  ),
                                ))
                                .then((value) => refresh());
                          },
                          color: Colors.white60,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteDataHandler(article);
                          },
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                article.body,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
