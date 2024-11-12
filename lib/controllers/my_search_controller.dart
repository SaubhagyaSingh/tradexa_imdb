import 'dart:async';
import 'package:flutter/material.dart';
import '../modules/movie.dart';
import '../services/movie_service.dart';

class MySearchController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final MovieService _movieService = MovieService();

  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];
  Map<String, List<Movie>> _searchCache = {}; // Caches search results
  Timer? _debounce; // Timer for debouncing

  MySearchController() {
    fetchInitialMovies();
  }

  Future<void> fetchInitialMovies() async {
    try {
      allMovies = await _movieService.fetchMovies('maze runner') ?? [];
      allMovies = await _fetchMoviesWithRatings(allMovies);
      filteredMovies = List.from(allMovies);
      notifyListeners();
    } catch (error) {
      print('Failed to load movies: $error');
    }
  }

  Future<List<Movie>> _fetchMoviesWithRatings(List<Movie> movies) async {
    List<Movie> updatedMovies = [];
    for (var movie in movies) {
      try {
        var ratedMovie = await _movieService.fetchRating(movie);
        updatedMovies.add(ratedMovie ?? movie);
      } catch (error) {
        print('Failed to fetch rating for ${movie.title}: $error');
        updatedMovies.add(movie);
      }
    }
    return updatedMovies;
  }

  void handleSearch(String query, {String? genreFilter}) async {
    if (query.isEmpty && genreFilter == null) {
      filteredMovies = List.from(allMovies);
    } else if (_searchCache.containsKey(query)) {
      filteredMovies = _searchCache[query]!;
      if (genreFilter != null) {
        filteredMovies = filteredMovies
            .where((movie) => movie.genre!.contains(genreFilter))
            .toList();
      }
    } else {
      try {
        final movies = await _movieService.fetchMovies(query) ?? [];
        final moviesWithRatings = await _fetchMoviesWithRatings(movies);
        _searchCache[query] = moviesWithRatings;
        filteredMovies = moviesWithRatings;
        if (genreFilter != null) {
          filteredMovies = filteredMovies
              .where((movie) => movie.genre!.contains(genreFilter))
              .toList();
        }
      } catch (error) {
        print('Failed to filter movies: $error');
        filteredMovies = [];
      }
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filteredMovies = List.from(allMovies);
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
