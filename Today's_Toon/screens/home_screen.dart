import 'package:flutter/material.dart';
import 'package:study_flutter/models/webtoon_model.dart';
import 'package:study_flutter/services/api_service.dart';
import 'package:study_flutter/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    print(webtoons);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text("오늘의 웹툰", style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Column(
              children: [
                SizedBox(height: 50,),
                Expanded(child: makeList(snapshot)),
              ],
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context,index){
              var webtoon = snapshot.data![index];
              print(index);
              return Webtoon(title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id,);
            },
            separatorBuilder: (context,index)=>const SizedBox(width: 40,),
          );
  }
}
