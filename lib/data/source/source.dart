import 'package:flutter/services.dart';
import 'package:new_project/data/model/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract interface class Source {
  Future<List<Song>?> fetchSongs();
}

class RemoteSource implements Source {
  @override
  Future<List<Song>?> fetchSongs() async {
    final response = await http.get(Uri.parse('https://thantrieu.com/resources/braniumapis/songs.json'));
    if (response.statusCode == 200) {
      final String data = utf8.decode(response.bodyBytes);
      var songWapper = jsonDecode(data);
      var jsonData = songWapper['songs'] as List;
      return jsonData.map((song) => Song.fromJson(song)).toList();
    }else {
      return null;
    }
  }
}

class LocalSource implements Source {
  @override
  Future<List<Song>?> fetchSongs() async {
    final response = await rootBundle.loadString('assets/songs.json');
    final jsonBody = jsonDecode(response) as Map;
    var songList = jsonBody['songs'] as List<dynamic>;
    return songList.map((song) => Song.fromJson(song)).toList();
  }
}
