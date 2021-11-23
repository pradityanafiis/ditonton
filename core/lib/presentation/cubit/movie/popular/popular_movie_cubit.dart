import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'popular_movie_state.dart';

class PopularMovieCubit extends Cubit<PopularMovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieCubit(this._getPopularMovies) : super(PopularMovieInitial());

  void fetch() async {
    emit(PopularMovieLoading());

    final _result = await _getPopularMovies.execute();

    _result.fold(
      (failure) {
        emit(PopularMovieError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(PopularMovieLoaded(data));
        } else {
          emit(PopularMovieError('Movie not found.'));
        }
      },
    );
  }
}
