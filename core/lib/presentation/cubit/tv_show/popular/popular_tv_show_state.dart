part of 'popular_tv_show_cubit.dart';

@immutable
abstract class PopularTvShowState extends Equatable {
  const PopularTvShowState();
}

class PopularTvShowInitial extends PopularTvShowState {
  @override
  List<Object?> get props => [];
}

class PopularTvShowLoading extends PopularTvShowState {
  @override
  List<Object?> get props => [];
}

class PopularTvShowError extends PopularTvShowState {
  final String message;

  const PopularTvShowError(this.message);

  @override
  List<Object?> get props => [];
}

class PopularTvShowHasData extends PopularTvShowState {
  final List<TvShow> data;

  const PopularTvShowHasData(this.data);

  @override
  List<Object?> get props => [data];
}
