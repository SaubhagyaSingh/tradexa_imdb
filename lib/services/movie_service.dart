import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_variables.dart';
import '../modules/movie.dart';

class MovieService {
  // Fetch movies with genres and basic details
  Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$apiUrl?searchTerm=$query'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> edges =
          jsonDecode(response.body)['data']?['mainSearch']?['edges'] ?? [];

      // Parse each edge into a Movie instance
      return edges
          .map((edge) {
            try {
              return Movie.fromJson(edge);
            } catch (e) {
              print('Error parsing movie: $e');
              return null;
            }
          })
          .whereType<Movie>()
          .toList(); // Filters out null values
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Fetch rating for a specific movie by its IMDb ID
  Future<Movie?> fetchRating(Movie movie) async {
    final ratingUrl =
        'https://imdb-com.p.rapidapi.com/title/get-ratings?tconst=${movie.id}';
    final response = await http.get(Uri.parse(ratingUrl), headers: headers);

    if (response.statusCode == 200) {
      final ratingData = jsonDecode(response.body);
      final double? rating = (ratingData['data']?['title']?['ratingsSummary']
              ?['aggregateRating'] as num?)
          ?.toDouble();
      final int? voteCount =
          ratingData['data']?['title']?['ratingsSummary']?['voteCount'];

      if (rating != null && voteCount != null) {
        return movie.copyWithRating(rating, voteCount);
      } else {
        print('Rating or vote count missing for ${movie.title}');
        return movie; // Return movie without rating if data is incomplete
      }
    } else {
      print('Failed to load movie rating for ${movie.title}');
      return movie; // Return the movie unchanged if rating API fails
    }
  }

  // Fetch genres for a specific movie by its ID
  Future<List<String>> fetchGenres(String movieId) async {
    final genreUrl =
        'https://imdb-com.p.rapidapi.com/title/get-genres?tconst=$movieId';
    final response = await http.get(Uri.parse(genreUrl), headers: headers);

    if (response.statusCode == 200) {
      final genreData = jsonDecode(response.body);
      final List<dynamic>? genres =
          genreData['data']?['title']?['titleGenres']?['genres'];

      return genres
              ?.map((genre) => genre['genre']?['text']?.toString() ?? 'Unknown')
              .toList() ??
          ['Unknown'];
    } else {
      print('Failed to load genres for movie ID: $movieId');
      return ['Unknown'];
    }
  }
}
