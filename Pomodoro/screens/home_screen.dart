import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  int pomodors = 0;
  late Timer tm;
  bool isRunning = false;

  void onTick(Timer timer){
    if(totalSeconds==0){
      setState(() {
        pomodors++;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      tm.cancel();
    }else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void onStartPressed(){
    tm = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isRunning = true;
    });
  }

  void onPausedPressed(){
    tm.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed(){
    tm.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds){
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2,7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(format(totalSeconds),
                style: TextStyle(color: Theme.of(context).cardColor,
                fontSize: 89,
                fontWeight: FontWeight.w600,),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Theme.of(context).cardColor,
                    iconSize: 120,
                    icon: Icon(isRunning? Icons.pause_circle_outline:Icons.play_circle_outline),
                    onPressed: isRunning? onPausedPressed:onStartPressed,
                  ),
                  IconButton(
                      color: Theme.of(context).cardColor,
                      iconSize: 80,
                      onPressed: onResetPressed,
                      icon: const Icon(Icons.stop_circle_outlined)
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pomodors",style: TextStyle(
                          fontSize: 20, color: Theme.of(context).textTheme.displayLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),),
                        Text("$pomodors", style: TextStyle(
                          fontSize: 60, color: Theme.of(context).textTheme.displayLarge!.color,
                          fontWeight: FontWeight.w600,
                        ),),
                      ],
                    ),
           ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
