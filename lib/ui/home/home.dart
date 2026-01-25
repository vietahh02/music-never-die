import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/data/model/song.dart';
import 'package:new_project/ui/discovery/discovery.dart';
import 'package:new_project/ui/home/viewmodel.dart';
import 'package:new_project/ui/now_playing/playing.dart';
import 'package:new_project/ui/settings/settings.dart';
import 'package:new_project/ui/user/profile.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MusicHomePage(),
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
    HomePage(),
    DiscoveryPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.list_bullet),
        ),
        middle: Text('Music App'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.music_albums),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (context, index) => _pages[index],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicHomeViewModel viewModel;

  @override
  void initState() {
    viewModel = MusicHomeViewModel();
    viewModel.loadSongs();
    observeSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  @override
  void dispose() {
    viewModel.songsController.close();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    return showLoading ? getLoading() : getSong();
  }

  Widget getLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget getSong() {
    return ListView.separated(
      itemBuilder: (context, index) => getSongItem(songs[index]),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        height: 1,
        thickness: 1,
        indent: 15,
        endIndent: 15,
      ),
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getSongItem(Song song) {
    return ListTile(
      title: Text(song.title),
      subtitle: Text(song.artist),
      contentPadding: EdgeInsets.only(left: 15, right: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage(
          width: 50,
          height: 50,
          placeholder: AssetImage('assets/placeholder.jpg'),
          image: NetworkImage(song.image),
          imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/placeholder.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      trailing: IconButton(
        onPressed: () => {
          showBottomSheet(song),
        },
        icon: Icon(Icons.more_vert),
      ),
      onTap: () => {
        navigate(song),
      },
    );
  }

  void observeSongs() {
    viewModel.songsController.stream.listen((value) {
      setState(() {
        songs.addAll(value);
      });
    });
  }

  void showBottomSheet(Song song) {
    showModalBottomSheet(context: context, builder: (context) => 
      ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          height: 400,
          width: double.infinity,
          color: Colors.amberAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bottom Sheet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(onPressed: () => {
                Navigator.pop(context),
              }, child: Text('Close Bottom Sheet'))
            ],
          ),
        ),
      )
    );
  }

  void navigate(Song song) {
    Navigator.push(context, 
      CupertinoPageRoute(builder: (context) => NowPlaying(
        songs: songs,
        playingSong: song,
      ))
    );
  }
}