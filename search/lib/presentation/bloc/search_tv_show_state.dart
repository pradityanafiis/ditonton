part of 'search_tv_show_bloc.dart';

@immutable
abstract class SearchTvShowState extends Equatable {}

class SearchEmpty extends SearchTvShowState {
  @override
  List<Object?> get props => [];
}

class SearchLoading extends SearchTvShowState {
  @override
  List<Object?> get props => [];
}

class SearchError extends SearchTvShowState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends SearchTvShowState {
  final List<TvShow> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}
