import 'package:flutter/material.dart';
import 'package:tradexa_imdb/widgets/movie_tile.dart';
import '../widgets/searchbox.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  List<String> allMovies = [
    'Inception',
    'The Dark Knight',
    'Interstellar',
    'Dunkirk',
    'Tenet'
  ]; // Example movie list
  List<String> filteredMovies = [];

  @override
  void initState() {
    super.initState();
    // Initialize with all movies shown
    filteredMovies = allMovies;
  }

  void _filterMovies(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMovies = allMovies; // Show all movies if query is empty
      } else {
        filteredMovies = allMovies
            .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter movies based on query
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home'),
      ),
      body: Column(
        children: [
          SearchBox(
            controller: searchController,
            onChanged: _filterMovies, // Call _filterMovies when text changes
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                return MovieTile(
                  title: filteredMovies[index],
                  imageUrl: 'https://via.placeholder.com/100x150',
                  releaseDate: '2024-11-12', // Example release date
                  onTap: () {
                    // Handle tap event
                    print('${filteredMovies[index]} tapped');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
