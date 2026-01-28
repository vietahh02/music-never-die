import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:new_project/data/model/song.dart';
import 'package:new_project/ui/now_playing/audio_player_manager.dart';

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
  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayerManager _audioPlayerManager;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _audioPlayerManager = AudioPlayerManager(
      songUrl: widget.playingSong.source,
    );
    _audioPlayerManager.init();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Now Playing'),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.ellipsis),
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(widget.playingSong.album),
              const SizedBox(height: 20),
              const Text('_ ___ _'),
              const SizedBox(height: 20),
              RotationTransition(
                turns: Tween<double>(begin: 0, end: 1).animate(_controller),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage(
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    placeholder: AssetImage('assets/placeholder.jpg'),
                    image: NetworkImage(widget.playingSong.image),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                          'assets/placeholder.jpg',
                          width: screenWidth - delta,
                          height: screenWidth - delta,
                          fit: BoxFit.cover,
                        ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: 20,
                ),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined),
                      ),
                      Column(
                        children: [
                          Text(widget.playingSong.title),
                          SizedBox(height: 8),
                          Text(
                            widget.playingSong.artist,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_outline),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 20,
                  bottom: 20,
                ),
                child: _progressBar(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: _mediaButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonController(
            function: () {},
            icon: Icons.shuffle,
            color: Colors.grey,
            size: 24,
          ),
          MediaButtonController(
            function: () {},
            icon: Icons.skip_previous,
            color: Colors.black,
            size: 36,
          ),
          _playButton(),
          MediaButtonController(
            function: () {},
            icon: Icons.skip_next,
            color: Colors.black,
            size: 36,
          ),
          MediaButtonController(
            function: () {},
            icon: Icons.repeat,
            color: Colors.grey,
            size: 24,
          ),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationStateStream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: (value) => _audioPlayerManager.player.seek(value),
          barHeight: 4,
          timeLabelTextStyle: TextStyle(fontSize: 12, color: Colors.grey),
          baseBarColor: Colors.grey.shade300,
          progressBarColor: Colors.blue,
          bufferedBarColor: Colors.blue.shade100,
        );
      },
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final progressingState = playState?.processingState;
        final playing = playState?.playing;
        if (progressingState == ProcessingState.loading 
        || progressingState == ProcessingState.buffering) {
          return Container(
            margin: EdgeInsets.all(10),
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
          );
        }else if (playing != true) {
          return MediaButtonController(
            function: () {
              _audioPlayerManager.player.play();
              _controller.repeat();
            },
            icon: Icons.play_arrow,
            color: Colors.blue,
            size: 48,
          );
        }else if(progressingState != ProcessingState.completed) {
          return MediaButtonController(
            function: () {
              _audioPlayerManager.player.pause();
              _controller.stop();
            },
            icon: Icons.pause,
            color: Colors.blue,
            size: 48,
          );
        }else {
          return MediaButtonController(
            function: () {
              _audioPlayerManager.player.seek(Duration.zero);
            },
            icon: Icons.replay,
            color: Colors.blue,
            size: 48,
          );
        }
      },
    );
  }
}

class MediaButtonController extends StatefulWidget {
  const MediaButtonController({
    super.key,
    required this.function,
    required this.icon,
    this.color,
    this.size,
  });

  final void Function()? function;
  final IconData icon;
  final Color? color;
  final double? size;

  @override
  State<MediaButtonController> createState() => _MediaButtonControllerState();
}

class _MediaButtonControllerState extends State<MediaButtonController> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(
        widget.icon,
        color: widget.color ?? Theme.of(context).colorScheme.primary,
        size: widget.size,
      ),
    );
  }
}
