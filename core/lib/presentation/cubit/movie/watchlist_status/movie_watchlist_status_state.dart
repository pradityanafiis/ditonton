part of 'movie_watchlist_status_cubit.dart';

@immutable
abstract class MovieWatchlistStatusState extends Equatable {}

class MovieWatchlistStatusInitial extends MovieWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistStatusLoading extends MovieWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class MovieWatchlistStatusAdded extends MovieWatchlistStatusState {
  final String? message;

  MovieWatchlistStatusAdded({this.message});

  @override
  List<Object?> get props => [message];
}

class MovieWatchlistStatusNotAdded extends MovieWatchlistStatusState {
  final String? message;

  MovieWatchlistStatusNotAdded({this.message});

  @override
  List<Object?> get props => [message];
}
