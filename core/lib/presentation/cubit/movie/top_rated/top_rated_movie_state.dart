part of 'top_rated_movie_cubit.dart';

@immutable
abstract class TopRatedMovieState extends Equatable {}

class TopRatedMovieInitial extends TopRatedMovieState {
  @override
  List<Object?> get props => [];
}

class TopRatedMovieLoading extends TopRatedMovieState {
  @override
  List<Object?> get props => [];
}

class TopRatedMovieError extends TopRatedMovieState {
  final String message;

  TopRatedMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class TopRatedMovieLoaded extends TopRatedMovieState {
  final List<Movie> data;

  TopRatedMovieLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
