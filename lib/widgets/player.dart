import 'package:flutter/material.dart';
import 'package:udemy__spotify_app/modules/songs/song.dart';

class Player extends StatelessWidget {
  final Song song;
  final bool isPlay;
  final void Function()? onButtonTap;

  const Player({
    super.key,
    required this.song,
    required this.isPlay,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(song.albumImageUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          song.artistName,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: onButtonTap,
                child: Icon(
                  isPlay ? Icons.stop_circle : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
