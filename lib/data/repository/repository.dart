import 'package:new_project/data/model/song.dart';
import 'package:new_project/data/source/source.dart';

abstract interface class Repository {
  Future<List<Song>?> loadSongs();
}

class SongRepository implements Repository {
  final _localDataSource = LocalSource();
  final _remoteDataSource = RemoteSource();

  @override
  Future<List<Song>?> loadSongs() async {
    List<Song> songs = [];

    await _remoteDataSource.fetchSongs().then((removeSongs) {
      if (removeSongs == null) {
        _localDataSource.fetchSongs().then((localSongs) {
          if (localSongs != null) {
            songs.addAll(localSongs);
          }
        });
      } else {
        songs.addAll(removeSongs);
      }
    });

    return songs;
  }
}