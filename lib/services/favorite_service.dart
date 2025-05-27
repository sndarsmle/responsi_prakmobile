import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _favoriteMoviesKey = 'favoriteMovies';

  static Future<void> saveFavoriteMovies(List<String> movieIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteMoviesKey, movieIds);
  }

  static Future<List<String>> getFavoriteMovies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteMoviesKey) ?? [];
  }

  static Future<void> addFavoriteMovie(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList(_favoriteMoviesKey) ?? [];
    if (!currentFavorites.contains(movieId)) {
      currentFavorites.add(movieId);
      await prefs.setStringList(_favoriteMoviesKey, currentFavorites);
    }
  }

  static Future<void> removeFavoriteMovie(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList(_favoriteMoviesKey) ?? [];
    currentFavorites.remove(movieId);
    await prefs.setStringList(_favoriteMoviesKey, currentFavorites);
  }

  static Future<bool> isMovieFavorite(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList(_favoriteMoviesKey) ?? [];
    return currentFavorites.contains(movieId);
  }
}