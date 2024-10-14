import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/categories_news_model.dart';

import '../view_model/news_view_model.dart';
import 'home_screen.dart';
import 'news_detail_screen.dart';
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd,yyyy');
  String categoryName = 'general';
  List<String>categoriesList= [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context,index){
                   return InkWell(
                     onTap: (){
                       categoryName = categoriesList[index];
                       setState(() {
                       });
                     },
                     child: Padding(
                       padding: const EdgeInsets.only(right: 12),
                       child: Container(
                         decoration: BoxDecoration(
                           color: categoryName == categoriesList[index] ? Colors.blue : Colors.grey,
                           borderRadius: BorderRadius.circular(20)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 12),
                           child: Center(child: Text(categoriesList[index].toString(),
                             style: TextStyle(
                               fontSize: 13,
                               color: Colors.white
                           ),)),
                         ),
                       ),
                     ),
                   );
                  }
              )
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
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
            )
          ],
        ),
      ),
    );
  }
}
