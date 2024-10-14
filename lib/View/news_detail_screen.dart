import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class NewsDetailScreen extends StatefulWidget {
  String newsImage, newsTitle, newsDate, author, description, content, source;
  NewsDetailScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.source,
    required this.content
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height *1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40)
              ),
              child: CachedNetworkImage(
                height: height * 0.5,
                  width: width,
                  imageUrl: widget.newsImage,
                  fit: BoxFit.cover,
                  placeholder: (context,url) => Center(child: CircularProgressIndicator())
              ),
            ),
          ),
          Container(
              height: height * 0.6,
              margin: EdgeInsets.only(top: height * 0.4),
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  ),
                color: Colors.white
              ),
          child: ListView(
            children: [
              Text(
                  widget.newsTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: Text(widget.source,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                  Text(widget.newsDate,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w800
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.02),
              Text(
                widget.description,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          )
          )
        ],

      ),
    );
  }
}
