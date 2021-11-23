part of 'now_playing_tv_show_cubit.dart';

@immutable
abstract class NowPlayingTvShowState extends Equatable {
  const NowPlayingTvShowState();
}

class NowPlayingTvShowInitial extends NowPlayingTvShowState {
  @override
  List<Object?> get props => [];
}

class NowPlayingTvShowLoading extends NowPlayingTvShowState {
  @override
  List<Object?> get props => [];
}

class NowPlayingTvShowError extends NowPlayingTvShowState {
  final String message;

  const NowPlayingTvShowError(this.message);

  @override
  List<Object?> get props => [];
}

class NowPlayingTvShowHasData extends NowPlayingTvShowState {
  final List<TvShow> data;

  const NowPlayingTvShowHasData(this.data);

  @override
  List<Object?> get props => [data];
}
