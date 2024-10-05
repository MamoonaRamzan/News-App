import 'dart:convert';
import 'package:news_app/Model/categories_news_model.dart';
import '../Model/news_channel_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository{
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlineApi(String channelName)async{
    String url= 'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=b7c8329f45ad45ad9c79117b309169e9';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    String url= 'https://newsapi.org/v2/everything?q=${category}&apiKey=b7c8329f45ad45ad9c79117b309169e9';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      CategoriesNewsModel categoriesNewsModel = CategoriesNewsModel.fromJson(body);
      return categoriesNewsModel;
    }
    throw Exception("Error");
  }

}