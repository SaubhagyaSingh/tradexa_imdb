import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String releaseDate;
  final String genre;
  final double imdbRating;
  final VoidCallback onTap;

  const MovieTile({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    required this.genre,
    required this.imdbRating,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/placeholder.png',
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Release Date: $releaseDate"),
                  Text("Genre: $genre"),
                  Text("IMDb Rating: $imdbRating"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
