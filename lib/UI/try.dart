import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Quotes extends StatefulWidget {
  @override
  _QuotesState createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;

  Duration position = new Duration();
  Duration music_l = new Duration();

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.white,
          inactiveColor: Colors.grey.shade700,
          value: position.inSeconds.toDouble(),
          max: music_l.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
  }

  List path = ["Audio1.mp3", "Audio2.mp3", "Audio3.mp3"];
  int i = 0;
  int index = 0;
  List OP = [
    "Imagination is more important than knowledge.",
    "The present is theirs, the future, for which I really worked, is mine.",
    "Every pain gives a lesson and every lesson changes the person.",
    "Life is like riding a bicycle. To keep balance, you must keep moving."
  ];

  @override
  void initState() {
    super.initState();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });
    audioPlayer.durationHandler = (d) {
      setState(() {
        music_l = d;
      });
    };
    audioPlayer.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearCache();
  }

  playMusic() async {
    await audioCache.play(path[index % path.length]);
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quotes"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blueAccent,
      //   onPressed: (){
      //    audioPlayerState == AudioPlayerState.PLAYING
      //        ? pauseMusic() : playMusic();
      //   },
      //   child: Icon(audioPlayerState == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
      // ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("lib/UI/tenor.gif"),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 180.0,
              ),
              child: Center(
                child: Container(
                  height: 250,
                  width: 350,
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      OP[i % OP.length],
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FlatButton.icon(
                onPressed: _showQuote,
                color: Colors.lightGreenAccent.shade700,
                icon: Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                label: Text(
                  "Next Quote",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 600.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                            slider(),
                            Text(
                              "${music_l.inMinutes}:${music_l.inSeconds.remainder(60)}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 20.0,
                            color: Colors.white,
                            icon: Icon(Icons.skip_previous),
                            onPressed: _prevSong,
                          ),
                          IconButton(
                            iconSize: 40.0,
                            color: Colors.white,
                            onPressed: () {
                              audioPlayerState == AudioPlayerState.PLAYING
                                  ? pauseMusic()
                                  : playMusic();
                            },
                            icon: Icon(
                                audioPlayerState == AudioPlayerState.PLAYING
                                    ? Icons.pause
                                    : Icons.play_arrow),
                          ),
                          IconButton(
                            iconSize: 20.0,
                            color: Colors.white,
                            icon: Icon(Icons.skip_next),
                            onPressed: _nextSong,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuote() {
    setState(() {
      i++;
    });
  }

  void _prevSong() {
    setState(() {
      index--;
      playMusic();
    });
  }

  void _nextSong() {
    setState(() {
      index++;
      playMusic();
    });
  }
}

