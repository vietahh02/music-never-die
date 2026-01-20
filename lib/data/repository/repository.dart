import 'package:new_project/data/model/song.dart';
import 'package:new_project/data/source/source.dart';

abstract interface class SongRepository {
  Future<List<Song>?> loadData();
}

class SongRepositoryImpl implements SongRepository {
  final _localSongSource = LocalSongSource();
  final _remoteSongSource = RemoteSongSource();

  @override
  Future<List<Song>?> loadData() async {
    List<Song> songs = [];

    await _remoteSongSource.getSongs().then((value) async {
      if (value != null) {
        songs.addAll(value);
      }else {
        await _localSongSource.getSongs().then((value) {
          if (value != null) {
            songs.addAll(value);
          }
        });
      }
    });

    return songs;
  }
}
