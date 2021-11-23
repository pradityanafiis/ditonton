part of 'popular_movie_cubit.dart';

@immutable
abstract class PopularMovieState extends Equatable {}

class PopularMovieInitial extends PopularMovieState {
  @override
  List<Object?> get props => [];
}

class PopularMovieLoading extends PopularMovieState {
  @override
  List<Object?> get props => [];
}

class PopularMovieError extends PopularMovieState {
  final String message;

  PopularMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopularMovieLoaded extends PopularMovieState {
  final List<Movie> data;

  PopularMovieLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
