import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/data/model/song.dart';
import 'package:new_project/ui/discovery/discovery.dart';
import 'package:new_project/ui/home/viewmodel.dart';
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
    return Scaffold(
      body: getBody(),
    );
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
      leading: Image.network(song.image),
    );
  }

  void observeSongs() {
    viewModel.songsController.stream.listen((value) {
      setState(() {
        songs.addAll(value);
      });
    });
  }
}