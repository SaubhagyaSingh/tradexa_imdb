class Movie {
  final String id;
  final String title;
  final String? imageUrl;
  final String? releaseYear;
  final List<String>? genres;
  final double? imdbRating;
  final int? voteCount;

  Movie({
    required this.id,
    required this.title,
    this.imageUrl,
    this.releaseYear,
    this.genres,
    this.imdbRating,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final entity = json['node']?['entity'];
    final titleData = json['data']?['title'];

    // Parse genres as a List<String>
    final List<String>? parsedGenres = (titleData?['titleGenres']?['genres']
            as List<dynamic>?)
        ?.map(
            (genreItem) => genreItem['genre']?['text']?.toString() ?? 'Unknown')
        .toList();

    return Movie(
      id: entity?['id'] as String? ?? 'Unknown ID',
      title: entity?['titleText']?['text'] as String? ?? 'Unknown Title',
      imageUrl: entity?['primaryImage']?['url'] as String?,
      releaseYear: entity?['releaseYear']?['year']?.toString(),
      genres: parsedGenres,
      imdbRating: null, // Will be populated later
      voteCount: null, // Will be populated later
    );
  }

  // Factory method for adding rating data
  Movie copyWithRating(double rating, int votes) {
    return Movie(
      id: id,
      title: title,
      imageUrl: imageUrl,
      releaseYear: releaseYear,
      genres: genres,
      imdbRating: rating,
      voteCount: votes,
    );
  }

  // Add a copyWith method to update specific properties, like genres
  Movie copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? releaseYear,
    List<String>? genres,
    double? imdbRating,
    int? voteCount,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      releaseYear: releaseYear ?? this.releaseYear,
      genres: genres ?? this.genres,
      imdbRating: imdbRating ?? this.imdbRating,
      voteCount: voteCount ?? this.voteCount,
    );
  }
}
