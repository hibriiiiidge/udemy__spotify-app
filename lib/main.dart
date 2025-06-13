import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:udemy__spotify_app/lib/spotify.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  await setupSpotifyClient();
  runApp(const MainApp());
  spotifyClient.test();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
