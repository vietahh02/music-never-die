import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/data/model/song.dart';

abstract class SongSource {
  Future<List<Song>?> getSongs();
}

class RemoteSongSource implements SongSource {
  @override
  Future<List<Song>?> getSongs() async {
    final response = await http.get(
      Uri.parse('https://thantrieu.com/resources/braniumapis/songs.jso'),
    );
    if (response.statusCode == 200) {
      final data = utf8.decode(response.bodyBytes);
      var songWrapper = jsonDecode(data) as Map<String, dynamic>;
      var songs = songWrapper['songs'] as List<dynamic>;
      debugPrint(songs.map((song) => Song.fromJson(song)).toList().toString());
      return songs.map((song) => Song.fromJson(song)).toList();
    } else {
      return null;
    }
  }
}

class LocalSongSource implements SongSource {
  @override
  Future<List<Song>?> getSongs() async {
    final response = await rootBundle.loadString('assets/songs.json');
    var songWrapper = jsonDecode(response) as Map;
    var songs = songWrapper['songs'] as List;
    // debugPrint(songs.map((song) => Song.fromJson(song)).toList().toString());
    List<Song> songsList = songs.map((song) => Song.fromJson(song)).toList();
    return songsList;
  }
}
