import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  final List<String> genres; // Change to List<String>
  final double imdbRating;
  final VoidCallback onTap;

  const MovieTile({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.genres,
    required this.imdbRating,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the IMDb rating background and text colors based on the rating
    Color backgroundColor =
        imdbRating > 7 ? Color(0xFF5EC570) : Color(0xFF1C7EEB);
    Color textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 60, horizontal: 24), // Add vertical and horizontal margin
      child: InkWell(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main container with shadow
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 10,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      155, 12, 12, 12), // Extra padding on the left
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        genres.join(' | '), // Join the genre list here
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "$imdbRating IMDb",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned image that extends from the bottom of the container and overflows from the top
            Positioned(
              bottom: 0, // Aligns the image with the base of the card
              left: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 130,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/placeholder.png',
                      width: 120,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
