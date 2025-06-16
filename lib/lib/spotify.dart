import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:udemy__spotify_app/modules/songs/song.dart';

late SpotifyClient spotifyClient;

Future setupSpotifyClient() async {
  spotifyClient = await SpotifyClient.initialize();
}

class SpotifyClient {
  late final String? token;
  static Dio dio = Dio();

  static Future<SpotifyClient> initialize() async {
    Response response = await Dio().post(
      "https://accounts.spotify.com/api/token",
      data: {
        "grant_type": "client_credentials",
        "client_id": dotenv.env["SPOTIFY_CLIENT_ID"],
        "client_secret": dotenv.env["SPOTIFY_CLIENT_SECRET"],
      },
      options: Options(
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
    SpotifyClient spotifyClient = SpotifyClient();
    spotifyClient.token = response.data["access_token"];
    return spotifyClient;
  }

  dynamic getPopularSongs() async{
    Response response = await dio.get(
      "https://api.spotify.com/v1/playlists/5SLPaOxQyJ8Ne9zpmTOvSe",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    // print(response.data["tracks"]);
    return response.data["tracks"]["items"].map<Song>((item) {
      final song = item["track"];
      return Song(
        name: song["name"],
        artistName: song["artists"][0]["name"],
        albumImageUrl: song["album"]["images"][0]["url"],
        previewUrl: "https://p.scdn.co/mp3-preview/f85c348040c1072b3832a0fccb5c81d34dfefcfb",
      );
    }).toList();
  }

  Future<List<Song>> searchSongs(String keyword) async {
    Response response = await dio.get(
      "https://api.spotify.com/v1/search",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
      queryParameters: {
        "q": keyword,
        "type": "track",
        "limit": 10,
      },
    );

    return response.data["tracks"]["items"].map<Song>((item) {
      return Song(
        name: item["name"],
        artistName: item["artists"][0]["name"],
        albumImageUrl: item["album"]["images"][0]["url"],
        previewUrl: item["preview_url"],
      );
    }).toList();
  }
}
