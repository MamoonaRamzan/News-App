import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/news_channel_headlines_model.dart';
import 'package:news_app/View/categories_screen.dart';
import 'package:news_app/View/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../Model/categories_news_model.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList{ bbcNews, aryNews, abcNews, entertainmentWeekly, cnn, alJazeera, financialPost, infoMoney}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd,yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/category_icon.png',
            height: 30,
            width: 30,
          ),
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoriesScreen()));
          },
        ),
        title: Text('News', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900),),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            initialValue: selectedMenu,
              icon: Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (FilterList item){
              if(FilterList.bbcNews.name == item.name){
                name ='bbc-news';
              }
              if(FilterList.aryNews.name == item.name){
                name ='ary-news';
              }
              if(FilterList.cnn.name == item.name){
                name ='cnn';
              }
              if(FilterList.alJazeera.name == item.name){
                name ='al-jazeera-english';
              }
              if(FilterList.abcNews.name == item.name){
                name ='abc-news';
              }
              if(FilterList.entertainmentWeekly.name == item.name){
                name ='entertainment-weekly';
              }
              if(FilterList.financialPost.name == item.name){
                name ='financial-post';
              }
              if(FilterList.infoMoney.name == item.name){
                name ='info-money';
              }
              setState(() {
                selectedMenu = item;
              });
              },
              itemBuilder: (BuildContext context)=><PopupMenuEntry<FilterList>>[
                PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Text('BBC News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.aryNews,
                    child: Text('Ary News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.cnn,
                    child: Text('CNN')),
                PopupMenuItem<FilterList>(
                    value: FilterList.abcNews,
                    child: Text('ABC News')),
                PopupMenuItem<FilterList>(
                    value: FilterList.alJazeera,
                    child: Text('AlJazeera')),
                PopupMenuItem<FilterList>(
                    value: FilterList.entertainmentWeekly,
                    child: Text('Entertainment Weekly')),
                PopupMenuItem<FilterList>(
                    value: FilterList.financialPost,
                    child: Text('Financial Post')),
                PopupMenuItem<FilterList>(
                    value: FilterList.infoMoney,
                    child: Text('Info Money'))
              ]
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (BuildContext context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                }
                else{
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.articles!.length,
                      itemBuilder: (context,index){
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: format.format(dateTime),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                                content: snapshot.data!.articles![index].content.toString())));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height : height * 0.6,
                                  width: width * 0.9,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: height * 0.02
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url)=>Container(child: spinKit2,),
                                        errorWidget: (context, url, error)=>Icon(Icons.error_outline,color: Colors.red,)
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(15),
                                      height: height * 0.22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                          Spacer(

                                          ),
                                          Container(
                                            width: width * 0.7,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Text(format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
              },
            )
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (BuildContext context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                }
                else{
                  return ListView.builder(
                    shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.articles!.length,
                      itemBuilder: (context,index){
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: format.format(dateTime),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                                content: snapshot.data!.articles![index].content.toString())));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * 0.18,
                                      width: width * 0.3,
                                      placeholder: (context, url)=>Container(child: spinKit2,),
                                      errorWidget: (context, url, error)=>Icon(Icons.error_outline,color: Colors.red,)
                                  ),
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      height: height * 0.18,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              Text(format.format(dateTime),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                ),
                                              ),
                                            ],

                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}
const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
