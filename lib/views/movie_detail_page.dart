import 'package:flutter/material.dart';
import 'package:responsi011/models/movie_detail_model.dart';
import 'package:responsi011/network/base_network.dart';
import 'package:responsi011/services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final String endpoint;

  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  MovieDetail? _movieDetail;
  String? _errorMessage;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
    _checkFavoriteStatus();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetailData(widget.endpoint, widget.id);
      setState(() {
        _movieDetail = MovieDetail.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkFavoriteStatus() async {
    bool favorite = await FavoriteService.isMovieFavorite(widget.id);
    setState(() {
      _isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoriteService.removeFavoriteMovie(widget.id);
    } else {
      await FavoriteService.addFavoriteMovie(widget.id);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to Favorites' : 'Removed from Favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget buildImage(String imgUrl) {
    if (imgUrl.isNotEmpty && Uri.tryParse(imgUrl)?.hasAbsolutePath == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imgUrl,
          width: 150,
          height: 225,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/no_image.jpg',
              width: 150,
              height: 225,
              fit: BoxFit.cover,
            );
          },
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/no_image.jpg',
          width: 150,
          height: 225,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Detail"),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage"))
              : _movieDetail != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: buildImage(_movieDetail!.imgUrl)),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              _movieDetail!.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildDetailRow("Release Date", _movieDetail!.releaseDate),
                          buildDetailRow("Rating", _movieDetail!.rating),
                          buildDetailRow("Genre", _movieDetail!.genre.join(', ')),
                          buildDetailRow("Director", _movieDetail!.director),
                          buildDetailRow("Cast", _movieDetail!.cast.join(', ')),
                          buildDetailRow("Language", _movieDetail!.language),
                          buildDetailRow("Duration", _movieDetail!.duration),
                          const SizedBox(height: 15),
                          const Text(
                            "Description:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _movieDetail!.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Created At: ${_movieDetail!.createdAt}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text("No data available!")),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}