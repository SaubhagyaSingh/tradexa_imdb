class Movie {
  final String id;
  final String title;
  final String? imageUrl;
  final String? releaseYear;
  final String? genre;
  final double? imdbRating;
  final int? voteCount;

  Movie({
    required this.id,
    required this.title,
    this.imageUrl,
    this.releaseYear,
    this.genre,
    this.imdbRating,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final entity = json['node']['entity'];
    return Movie(
      id: entity['id'] as String,
      title: entity['titleText']['text'] as String,
      imageUrl: entity['primaryImage']?['url'] as String?,
      releaseYear: entity['releaseYear']?['year']?.toString(),
      genre: entity['titleType']?['text'] as String?,
    );
  }

  // Factory method for adding rating data
  Movie copyWithRating(double rating, int votes) {
    return Movie(
      id: id,
      title: title,
      imageUrl: imageUrl,
      releaseYear: releaseYear,
      genre: genre,
      imdbRating: rating,
      voteCount: votes,
    );
  }
}
