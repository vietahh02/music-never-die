import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  final player = AudioPlayer();
  Stream<DurationState>? durationStateStream;
  String songUrl;

  AudioPlayerManager({required this.songUrl});

  void init() {
    durationStateStream = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
      (position, event) => DurationState(progress: position, buffered: event.bufferedPosition, total: event.duration),
    );
    player.setUrl(songUrl);
  }
}

class DurationState {
  final Duration progress;
  final Duration buffered;
  final Duration? total;

  DurationState({required this.progress, required this.buffered, this.total});

  factory DurationState.fromJson(Map<String, dynamic> json) {
    return DurationState(
      progress: Duration(seconds: json['progress']),
      buffered: Duration(seconds: json['buffered']),
      total: json['total'] != null ? Duration(seconds: json['total']) : null,
    );
  }
}