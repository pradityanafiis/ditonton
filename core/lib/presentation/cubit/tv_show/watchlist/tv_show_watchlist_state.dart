part of 'tv_show_watchlist_cubit.dart';

@immutable
abstract class TvShowWatchlistState extends Equatable {}

class TvShowWatchlistInitial extends TvShowWatchlistState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchlistLoading extends TvShowWatchlistState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchlistError extends TvShowWatchlistState {
  final String message;

  TvShowWatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class TvShowWatchlistLoaded extends TvShowWatchlistState {
  final List<TvShow> data;

  TvShowWatchlistLoaded(this.data);

  @override
  List<Object?> get props => [data];
}
