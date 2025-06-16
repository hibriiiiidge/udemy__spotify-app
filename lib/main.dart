import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:udemy__spotify_app/lib/spotify.dart';
import 'package:udemy__spotify_app/widgets/song_card.dart';
import 'package:udemy__spotify_app/modules/songs/song.dart';
import 'package:udemy__spotify_app/widgets/player.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await setupSpotifyClient();
  runApp(const MaterialApp(
    home: MusicApp(),
  ));
}

class MusicApp extends StatefulWidget {
  const MusicApp({
    super.key,
  });

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _popularSongs = [];
  bool _isInitialized = false;
  Song? _selectedSong;
  bool _isPlaying = false;
  String? _keyword;
  List<Song> _searchedSongs = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final songs = await spotifyClient.getPopularSongs();
    setState(() {
      _popularSongs = songs;
      _isInitialized = true;
    });
  }

  void _play() {
    _audioPlayer.play(UrlSource(_selectedSong!.previewUrl!));
    setState(() {
      _isPlaying = true;
    });
  }

  void _stop() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _handleSongSelected(Song song) {
    setState(() {
      _selectedSong = song;
    });
    _play();
  }

  void _handleTextFieldChanged(String value) {
    setState(() {
      _keyword = value;
    });
  }

  void _searchSongs() async {
    if (_keyword != null && _keyword!.isNotEmpty) {
      final songs = await spotifyClient.searchSongs(_keyword!);
      setState(() {
        _searchedSongs = songs;
      });
    } else {
      setState(() {
        _searchedSongs = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final songs = _searchedSongs.isNotEmpty ? _searchedSongs : _popularSongs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Music App',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: '探したい曲を入力してください',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                              onChanged: _handleTextFieldChanged,
                              onEditingComplete: () => _searchSongs(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Songs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: !_isInitialized
                      ? Container()
                      : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: LayoutGrid(
                              columnSizes: [1.fr, 1.fr],
                              rowSizes: List.generate(
                                (songs.length / 2).round(),
                                (int index) => auto,
                              ),
                              children: songs.map((song) {
                                return SongCard(song: song, onTap: _handleSongSelected);
                              }).toList(),
                            )
                          )
                        ],
                      ),
                  ),
                ],
              ),
              if (_selectedSong != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: IntrinsicHeight(
                    child: Player(
                      song: _selectedSong!,
                      isPlay: _isPlaying,
                      onButtonTap: () => _isPlaying ? _stop() : _play(),
                    )
                  ),
                ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0E0E10),
    );
  }
}
