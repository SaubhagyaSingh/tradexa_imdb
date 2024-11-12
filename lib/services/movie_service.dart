import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_variables.dart';
import '../modules/movie.dart';

class MovieService {
  Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$apiUrl?searchTerm=$query'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> edges =
          jsonDecode(response.body)['data']['mainSearch']['edges'];
      return edges.map((edge) => Movie.fromJson(edge)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> fetchRating(Movie movie) async {
    final ratingUrl =
        'https://imdb-com.p.rapidapi.com/title/get-ratings?tconst=${movie.id}';
    final response = await http.get(Uri.parse(ratingUrl), headers: headers);

    if (response.statusCode == 200) {
      final ratingData = jsonDecode(response.body);

      // Extract the aggregateRating and voteCount from the nested structure
      final double? rating = ratingData['data']?['title']?['ratingsSummary']
              ?['aggregateRating']
          ?.toDouble();
      final int? voteCount =
          ratingData['data']?['title']?['ratingsSummary']?['voteCount'];

      return movie.copyWithRating(rating!, voteCount!);
    } else {
      throw Exception('Failed to load movie rating');
    }
  }
}
