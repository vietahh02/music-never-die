import 'dart:async';

import 'package:new_project/data/model/song.dart';
import 'package:new_project/data/repository/repository.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStream = StreamController();

  void loadSongs() {
    final repository = SongRepository();
    repository.loadSongs().then((value) => songStream.add(value!));
  }
}  