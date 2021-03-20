import 'package:flutter/material.dart';
import 'package:khmer_news/models/article_model.dart';
import 'package:khmer_news/repos/article_repo.dart';

class EditPostPage extends StatefulWidget {
  final Article article;

  EditPostPage({this.article});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  var _titleController = TextEditingController();
  var _captionController = TextEditingController();
  var _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.article.title;
    _captionController.text = widget.article.body;
    _imageController.text = widget.article.img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Enter your post title",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _captionController,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: "Caption",
                      hintText: "Enter your post caption",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.closed_caption),
                      counterText:
                          "${_captionController.text.length} characters"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  controller: _imageController,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Image Url",
                    hintText: "Enter your post image url",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  updateHandler();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload),
                      Text("Update"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDataHandler(Article _article) {
    updateArticle(_article).then((value) {
      if (value == "succeed") {
        print("Success!");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Updated Successfully"),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to update data!"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  void updateHandler() {
    if (_titleController.text.trim().isNotEmpty ||
        _captionController.text.trim().isNotEmpty ||
        _imageController.text.trim().isNotEmpty) {
      Article _article = Article(
        aid: widget.article.aid,
        title: _titleController.text.trim(),
        body: _captionController.text.trim(),
        img: _imageController.text.trim(),
        date: DateTime.now(),
      );
      updateDataHandler(_article);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please insert all inputs before update!"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
