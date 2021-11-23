import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'top_rated_movie_state.dart';

class TopRatedMovieCubit extends Cubit<TopRatedMovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieCubit(this._getTopRatedMovies) : super(TopRatedMovieInitial());

  void fetch() async {
    emit(TopRatedMovieLoading());

    final _result = await _getTopRatedMovies.execute();

    _result.fold(
      (failure) {
        emit(TopRatedMovieError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(TopRatedMovieLoaded(data));
        } else {
          emit(TopRatedMovieError('Movie not found.'));
        }
      },
    );
  }
}
