import 'package:flutter/material.dart';
import 'package:responsi011/models/movie_model.dart';
import 'package:responsi011/network/base_network.dart';
import 'package:responsi011/presenters/movie_presenter.dart';
import 'package:responsi011/views/movie_detail_page.dart';
import 'package:responsi011/services/favorite_service.dart';

class MovieListScrenn extends StatefulWidget {
  const MovieListScrenn({super.key});

  @override
  State<MovieListScrenn> createState() => _MovieListScrennState();
}

class _MovieListScrennState extends State <MovieListScrenn>
implements MovieView {

  late MoviePresenter _presenter;
  bool _isLoading = false;
  List<Movie> _movieList = [];
  String? _errorMessage;
  String _currentEndpoint = 'movie';
  List<String> _favoriteMovieIds = [];

  @override
  void initState() {
    super.initState();
    _presenter = MoviePresenter(this);
    _presenter.loadMovieData(_currentEndpoint);
    _loadFavoriteMovieIds();
  }

  Future<void> _loadFavoriteMovieIds() async {
    _favoriteMovieIds = await FavoriteService.getFavoriteMovies();
    setState(() {});
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadMovieData(endpoint);
    });
  }

  void _showFavoriteMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final allMoviesRaw = await BaseNetwork.getData(_currentEndpoint);
      final allMovies = allMoviesRaw.map((json) => Movie.fromJson(json)).toList();
      final favoriteIds = await FavoriteService.getFavoriteMovies();

      List<Movie> favoritedMovies = allMovies.where((movie) => favoriteIds.contains(movie.id)).toList();
      showMovieList(favoritedMovies);
    } catch (e) {
      showError("Failed to load favorite movies: ${e.toString()}");
    } finally {
      hideLoading();
    }
  }


  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showMovieList(List<Movie> movieList) {
    setState(() {
      _movieList = movieList;
      _errorMessage = null;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void updateFavoriteStatus(String movieId, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        _favoriteMovieIds.add(movieId);
      } else {
        _favoriteMovieIds.remove(movieId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _fetchData('movie'),
                child: const Text('All Movies'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _showFavoriteMovies,
                child: const Text('Favorites'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(child: Text("Error: $_errorMessage"))
                    : _movieList.isEmpty
                        ? const Center(child: Text("No movies available."))
                        : ListView.builder(
                      itemCount: _movieList.length,
                      itemBuilder: (context, index) {
                        final movie = _movieList[index];
                        final isFavorite = _favoriteMovieIds.contains(movie.id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
                          child: Card(
                            elevation: 3,
                            child: InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailScreen(
                                          id: movie.id,
                                          endpoint: _currentEndpoint,
                                        ),
                                  ),
                                );
                                _loadFavoriteMovieIds();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    // Gambar/Poster
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        movie.imgUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/no_image.jpg',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Rating: ${movie.rating}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Genre: ${movie.genre.join(', ')}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Duration: ${movie.duration}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : null,
                                      ),
                                      onPressed: () {
                                        _presenter.toggleFavorite(movie.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}