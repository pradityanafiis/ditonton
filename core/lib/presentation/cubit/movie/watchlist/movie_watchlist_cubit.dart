import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_watchlist_state.dart';

class MovieWatchlistCubit extends Cubit<MovieWatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;

  MovieWatchlistCubit(this._getWatchlistMovies)
      : super(MovieWatchlistInitial());

  void fetchWatchlist() async {
    emit(MovieWatchlistLoading());

    final _result = await _getWatchlistMovies.execute();

    _result.fold(
      (failure) {
        emit(MovieWatchlistError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(MovieWatchlistLoaded(data));
        } else {
          emit(MovieWatchlistError('Your movie watchlist is empty'));
        }
      },
    );
  }
}
