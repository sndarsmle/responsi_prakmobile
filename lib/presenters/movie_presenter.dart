import 'package:responsi011/models/movie_model.dart';
import 'package:responsi011/network/base_network.dart';
import 'package:responsi011/services/favorite_service.dart';

abstract class MovieView{
  void showLoading();
  void hideLoading();
  void showMovieList(List<Movie> movieList);
  void showError(String message);
  void updateFavoriteStatus(String movieId, bool isFavorite);
}

class MoviePresenter {
  final MovieView view;
  MoviePresenter(this.view);

  Future<void> loadMovieData(String endpoint) async {
    view.showLoading();
    try {
      final List<dynamic> data = await BaseNetwork.getData(endpoint);
      final movieList = data.map((json) => Movie.fromJson(json)).toList();
      view.showMovieList(movieList);
    } catch (e) {
      view.showError("Failed to load movies: ${e.toString()}");
    } finally {
      view.hideLoading();
    }
  }

  Future<void> toggleFavorite(String movieId) async {
    bool isCurrentlyFavorite = await FavoriteService.isMovieFavorite(movieId);
    if (isCurrentlyFavorite) {
      await FavoriteService.removeFavoriteMovie(movieId);
      view.updateFavoriteStatus(movieId, false);
    } else {
      await FavoriteService.addFavoriteMovie(movieId);
      view.updateFavoriteStatus(movieId, true);
    }
  }

  Future<List<String>> getFavoriteMovieIds() async {
    return await FavoriteService.getFavoriteMovies();
  }
}