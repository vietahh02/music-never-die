import 'package:flutter/material.dart';
import 'package:new_project/data/model/song.dart';

class NowPlaying extends StatelessWidget {
  final List<Song> songs;
  final Song playingSong;
  const NowPlaying({super.key, required this.songs, required this.playingSong});

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  final List<Song> songs;
  final Song playingSong;
  const NowPlayingPage({super.key, required this.songs, required this.playingSong});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.playingSong.title)),
    );
  }
}