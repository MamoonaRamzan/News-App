
import 'package:news_app/Model/categories_news_model.dart';
import 'package:news_app/repository/news_repository.dart';

import '../Model/news_channel_headlines_model.dart';

class NewsViewModel{

  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName)async{
    final response = await _rep.fetchNewsChannelHeadlineApi(channelName);
    return response;

  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category)async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;

  }
  
}