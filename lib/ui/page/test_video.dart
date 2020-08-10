
import 'package:ark/chewie/chewie_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestVideoItem extends StatefulWidget {

  String url;


  TestVideoItem({this.url});

  @override
  TestVideoItemState createState() => new TestVideoItemState();
}

class TestVideoItemState extends State<TestVideoItem> with WidgetsBindingObserver{

  ChewieController _chewieController;
  VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    videoPlayerController=VideoPlayerController.network('http://192.168.1.119:10000/resource/get_resource/?secret_key=wRlLNy5qZ0&resource_id=c2_fJceSTp3_502');
    _chewieController=ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16/9,
      autoPlay: true,
      errorBuilder: (context,errorMessage){
        return Center(
          child: Text(errorMessage,style: TextStyle(color: Colors.white),),
        );
      }
    );
//    _initializeVideoPlayerFuture=widget.videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _chewieController.dispose();
  }

}