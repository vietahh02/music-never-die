import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_project/data/model/song.dart';
import 'package:new_project/data/repository/repository.dart';

class MusicHomeViewModel extends ChangeNotifier {
  StreamController<List<Song>> songsController = StreamController();

  void loadSongs() {
    final repository = SongRepositoryImpl();
    repository.loadData().then((value) {
      songsController.add(value ?? []);
    });
  }
}