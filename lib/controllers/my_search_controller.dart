import 'package:flutter/material.dart';
import '../modules/movie.dart';
import '../services/movie_service.dart';

class MySearchController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final MovieService _movieService = MovieService();

  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];
  Map<String, List<Movie>> _searchCache = {}; // Cache for search results

  MySearchController() {
    fetchInitialMovies();
  }

  Future<void> fetchInitialMovies() async {
    try {
      allMovies = await _movieService.fetchMovies('maze runner');
      allMovies = await _fetchMoviesWithDetails(allMovies);
      filteredMovies = List.from(allMovies);
      notifyListeners();
    } catch (error) {
      print('Failed to load movies: $error');
    }
  }

  Future<List<Movie>> _fetchMoviesWithDetails(List<Movie> movies) async {
    List<Movie> updatedMovies = [];
    for (var movie in movies) {
      try {
        // Fetch rating and genres for each movie
        final ratedMovie = await _movieService.fetchRating(movie) ?? movie;
        final genres = await _movieService.fetchGenres(movie.id);
        updatedMovies.add(ratedMovie.copyWith(genres: genres));
      } catch (error) {
        print('Failed to fetch details for ${movie.title}: $error');
        updatedMovies.add(movie);
      }
    }
    return updatedMovies;
  }

  Future<void> handleSearch(String query, {String? genreFilter}) async {
    if (query.isEmpty && genreFilter == null) {
      filteredMovies = List.from(allMovies);
    } else if (_searchCache.containsKey(query)) {
      filteredMovies = _filterByGenre(_searchCache[query]!, genreFilter);
    } else {
      try {
        final movies = await _movieService.fetchMovies(query);
        final moviesWithDetails = await _fetchMoviesWithDetails(movies);
        _searchCache[query] = moviesWithDetails;
        filteredMovies = _filterByGenre(moviesWithDetails, genreFilter);
      } catch (error) {
        print('Failed to filter movies: $error');
        filteredMovies = [];
      }
    }
    notifyListeners();
  }

  List<Movie> _filterByGenre(List<Movie> movies, String? genreFilter) {
    if (genreFilter == null) return movies;
    return movies
        .where((movie) => movie.genres?.contains(genreFilter) ?? false)
        .toList();
  }

  void clearSearch() {
    searchController.clear();
    filteredMovies = List.from(allMovies);
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
