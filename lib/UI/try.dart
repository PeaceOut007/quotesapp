import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Quotes extends StatefulWidget {
  @override
  _QuotesState createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  TimeOfDay _timeOfDay = TimeOfDay.now();
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;

  Duration position = new Duration();

  // ignore: non_constant_identifier_names
  Duration music_l = new Duration();

  Widget slider() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Slider.adaptive(
          activeColor: Colors.white,
          inactiveColor: Colors.grey.shade700,
          value: position.inSeconds.toDouble(),
          min: 0,
          max: music_l.inSeconds.toDouble(),
          onChanged: (value) {
            if (value >= 0 && value <= music_l.inSeconds.toDouble()) {
              seekToSec(value.toInt());
            }
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

  // ignore: non_constant_identifier_names
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
    // ignore: deprecated_member_use
    audioPlayer.durationHandler = (d) {
      setState(() {
        music_l = d;
      });
    };
    // ignore: deprecated_member_use
    audioPlayer.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
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
    String _period = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
    String _text = _timeOfDay.period == DayPeriod.am
        ? "Good Morning, Lets go......"
        : "Good Evening, take a break";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quotes",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.035,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
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
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("lib/UI/tenor.gif"),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  Text(
                    "${_timeOfDay.hour}:${_timeOfDay.minute}",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Text(
                    _period,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    _text,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.024,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.04,
              ),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width * 0.80,
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
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
                        fontSize: MediaQuery.of(context).size.height * 0.055,
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
              height: MediaQuery.of(context).size.height * 0.005,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.0005),
              // ignore: deprecated_member_use
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
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
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
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            slider(),
                            Text(
                              "${music_l.inMinutes}:${music_l.inSeconds.remainder(60)}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
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
                            iconSize: MediaQuery.of(context).size.width * 0.08,
                            color: Colors.white,
                            icon: Icon(Icons.skip_previous),
                            onPressed: _prevSong,
                          ),
                          IconButton(
                            iconSize: MediaQuery.of(context).size.width * 0.13,
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
                            iconSize: MediaQuery.of(context).size.width * 0.08,
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

