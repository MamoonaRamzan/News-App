import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/news_channel_headlines_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList{ bbcNews, aryNews, independent, reuters, cnn, alJazeera}

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
          onPressed: (){},
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
              if(FilterList.independent.name == item.name){
                name ='independent';
              }
              if(FilterList.reuters.name == item.name){
                name ='reuters';
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
                    value: FilterList.independent,
                    child: Text('Independent')),
                PopupMenuItem<FilterList>(
                    value: FilterList.alJazeera,
                    child: Text('AlJazeera')),
                PopupMenuItem<FilterList>(
                    value: FilterList.reuters,
                    child: Text('Reuters'))
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
                    itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context,index){
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return SizedBox(
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
                        );
                      }
                  );
                }
              },
            )
          )
        ],
      ),
    );
  }
}
const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
