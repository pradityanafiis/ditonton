part of 'tv_show_watchlist_status_cubit.dart';

@immutable
abstract class TvShowWatchlistStatusState extends Equatable {}

class TvShowWatchlistStatusInitial extends TvShowWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchlistStatusLoading extends TvShowWatchlistStatusState {
  @override
  List<Object?> get props => [];
}

class TvShowWatchlistStatusAdded extends TvShowWatchlistStatusState {
  final String? message;

  TvShowWatchlistStatusAdded({this.message});

  @override
  List<Object?> get props => [message];
}

class TvShowWatchlistStatusNotAdded extends TvShowWatchlistStatusState {
  final String? message;

  TvShowWatchlistStatusNotAdded({this.message});

  @override
  List<Object?> get props => [message];
}
