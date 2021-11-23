part of 'now_playing_movie_cubit.dart';

@immutable
abstract class NowPlayingMovieState extends Equatable {}

class NowPlayingMovieInitial extends NowPlayingMovieState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMovieLoading extends NowPlayingMovieState {
  @override
  List<Object?> get props => [];
}

class NowPlayingMovieError extends NowPlayingMovieState {
  final String message;

  NowPlayingMovieError(this.message);

  @override
  List<Object?> get props => [];
}

class NowPlayingMovieLoaded extends NowPlayingMovieState {
  final List<Movie> data;

  NowPlayingMovieLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
