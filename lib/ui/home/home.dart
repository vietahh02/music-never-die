import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/data/model/song.dart';
import 'package:new_project/ui/discovery/discovery.dart';
import 'package:new_project/ui/home/viewmodel.dart';
import 'package:new_project/ui/now_playing/playing.dart';
import 'package:new_project/ui/settings/settings.dart';
import 'package:new_project/ui/user/proflie.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _pages = [
    HomeTab(),
    DiscoveryPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Music'),
        backgroundColor: Colors.blue,
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          // activeColor: Colors.white,
          // inactiveColor: Colors.grey,
          iconSize: 24,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Discovery'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              return _pages[index];
            },
          );
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}


class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,

      ),
      drawer: AboutDialog(
        applicationName: "Big Dick",
        children: [

        ],
      ),
      body: Center(
        child: getBody(),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if(showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      }, 
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      }, 
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(song: songs[index], parent: this);
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void showButtonSheet(Song song) {
    showModalBottomSheet(context: context, builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(song.title),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Play'))
            ],
          ),
        ),
      );
    });
    // showCupertinoModalPopup(context: context, builder: (context) {
    //   return CupertinoActionSheet(title: Text(song.title), actions: [
    //     CupertinoActionSheetAction(child: Text('Play'), onPressed: () {
    //       Navigator.pop(context);
    //     }),
    //   ]);
    // });
  }

  void navigate(Song song) {
    Navigator.push(context, 
      CupertinoPageRoute(builder: (context) => NowPlaying(
        songs: songs,
        playingSong: song,
      )),
    );
  }
}

class _SongItemSection extends StatelessWidget {

  _SongItemSection({
    required this.song, required this.parent
    });
  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 24, right: 12),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage.assetNetwork(placeholder: 'assets/placeholder.jpg', image: song.image, 
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/placeholder.jpg', width: 50, height: 50, fit: BoxFit.cover,);
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(onPressed: () {
        parent.showButtonSheet(song);
      }, icon: Icon(Icons.more_vert)),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}
