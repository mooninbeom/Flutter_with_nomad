import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_flutter/models/webtoon_detail_model.dart';
import 'package:study_flutter/models/webtoon_episode_model.dart';
import 'package:study_flutter/services/api_service.dart';
import '../widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title,thumb, id;


  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if(likedToons != null){
      if(likedToons.contains(widget.id)==true){
        setState(() {
          isLiked = true;
        });
      }
    }else{
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLastestEpisodeById(widget.id);
    initPrefs();
  }

  onHeartTap() async{
    final likedToons = prefs.getStringList('likedToons');
    if(likedToons != null){
      if(isLiked){
        likedToons.remove(widget.id);
      }else{
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(onPressed: onHeartTap, icon: Icon(isLiked?Icons.favorite:Icons.favorite_outline,),),
        ],
        title: Text(widget.title, style: const TextStyle(fontSize: 24,),),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              offset: Offset(10, 10),
                              color: Colors.black.withOpacity(0.7),

                            )
                          ]
                      ),
                      width: 250,
                      child: Image.network(widget.thumb,
                        headers: const {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",},),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25,),
              FutureBuilder(
                  future: webtoon,
                  builder: (context,snapshot){
                if(snapshot.hasData){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data!.about, style: TextStyle(fontSize: 16),),
                      const SizedBox(height: 15,),
                      Text("${snapshot.data!.genre} / ${snapshot.data!.age}", style: TextStyle(fontSize: 16),),
                    ],
                  );
                }else{
                  return Text("...");
                }
              }),
              const SizedBox(height: 25,),
              FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Column(
                        children: [
                          for(var a in snapshot.data!.length>10?snapshot.data!.sublist(0,10):snapshot.data!)
                            Episode(a: a, webtoon_Id:widget.id)
                        ],
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
