// views/home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/my_search_controller.dart';
import '../widgets/movie_tile.dart';
import '../widgets/searchbox.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MySearchController>(
      create: (_) => MySearchController(),
      child: Consumer<MySearchController>(
        builder: (context, mySearchController, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
            ),
            body: Column(
              children: [
                SearchBox(
                  controller: mySearchController.searchController,
                  onChanged: (value) {
                    mySearchController.filterMovies(value);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: mySearchController.filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = mySearchController.filteredMovies[index];
                      return MovieTile(
                        title: movie.title,
                        imageUrl: movie.imageUrl ??
                            'https://via.placeholder.com/100x150',
                        releaseDate:
                            movie.releaseYear ?? 'N/A', // Use releaseYear here
                        genre: movie.genre ?? 'Unknown',
                        imdbRating: movie.imdbRating ?? 0,
                        onTap: () {
                          print('${movie.title} tapped,${movie.imdbRating}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
