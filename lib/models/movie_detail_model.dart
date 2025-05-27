class MovieDetail {
  final String id;
  final String title;
  final String releaseDate;
  final String imgUrl;
  final String rating;
  final List<String> genre;
  final String createdAt;
  final String description;
  final String director;
  final List<String> cast;
  final String language;
  final String duration;

  MovieDetail({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.imgUrl,
    required this.rating,
    required this.genre,
    required this.createdAt,
    required this.description,
    required this.director,
    required this.cast,
    required this.language,
    required this.duration,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? '0',
      title: json['title'] ?? 'No Title',
      releaseDate: json['release_date'] ?? 'N/A',
      imgUrl: json['imgUrl'] ?? 'https://via.placeholder.com/150',
      rating: json['rating'] ?? 'N/A',
      genre: List<String>.from(json['genre'] ?? []),
      createdAt: json['created_at'] ?? 'N/A',
      description: json['description'] ?? 'No description available.',
      director: json['director'] ?? 'N/A',
      cast: List<String>.from(json['cast'] ?? []),
      language: json['language'] ?? 'N/A',
      duration: json['duration'] ?? 'N/A',
    );
  }
}