import 'package:flutter/material.dart';
import '../modules/movie.dart';
import '../services/movie_service.dart';

class MySearchController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final MovieService _movieService = MovieService();

  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];

  MySearchController() {
    searchController.addListener(_onSearchChanged);
    fetchInitialMovies();
  }

  Future<void> fetchInitialMovies() async {
    try {
      allMovies = await _movieService.fetchMovies('maze runner');
      allMovies = await _fetchMoviesWithRatings(allMovies);
      filteredMovies = allMovies;
      notifyListeners();
    } catch (error) {
      print('Failed to load movies: $error');
    }
  }

  Future<List<Movie>> _fetchMoviesWithRatings(List<Movie> movies) async {
    for (int i = 0; i < movies.length; i++) {
      movies[i] = await _movieService.fetchRating(movies[i]);
    }
    return movies;
  }

  void _onSearchChanged() {
    filterMovies(searchController.text);
  }

  void filterMovies(String query) async {
    if (query.isEmpty) {
      filteredMovies = allMovies;
    } else {
      try {
        final movies = await _movieService.fetchMovies(query);
        filteredMovies = await _fetchMoviesWithRatings(movies);
      } catch (error) {
        print('Failed to filter movies: $error');
      }
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filterMovies('');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
