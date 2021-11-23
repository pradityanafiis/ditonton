import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_movie_state.dart';

class NowPlayingMovieCubit extends Cubit<NowPlayingMovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieCubit(this._getNowPlayingMovies)
      : super(NowPlayingMovieInitial());

  void fetch() async {
    emit(NowPlayingMovieLoading());

    final _result = await _getNowPlayingMovies.execute();

    _result.fold(
      (failure) {
        emit(NowPlayingMovieError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(NowPlayingMovieLoaded(data));
        } else {
          emit(NowPlayingMovieError('Movie not found.'));
        }
      },
    );
  }
}
