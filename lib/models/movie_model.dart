class Movie {
  final String id;
  final String title;
  final String imgUrl;
  final List<String> genre;
  final String rating;
  final String duration;

  Movie({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.genre,
    required this.rating,
    required this.duration,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '0',
      title: json['title'] ?? 'No Title',
      imgUrl: json['imgUrl'] ?? 'https://via.placeholder.com/150',
      genre: List<String>.from(json['genre'] ?? []),
      rating: json['rating'] ?? 'N/A',
      duration: json['duration'] ?? 'N/A', 
    );
  }
}