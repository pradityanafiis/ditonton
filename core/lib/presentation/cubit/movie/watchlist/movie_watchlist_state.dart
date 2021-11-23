part of 'movie_watchlist_cubit.dart';

@immutable
abstract class MovieWatchlistState extends Equatable {}

class MovieWatchlistInitial extends MovieWatchlistState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistLoading extends MovieWatchlistState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  MovieWatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieWatchlistLoaded extends MovieWatchlistState {
  final List<Movie> data;

  MovieWatchlistLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
