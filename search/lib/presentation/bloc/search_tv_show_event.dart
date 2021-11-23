part of 'search_tv_show_bloc.dart';

@immutable
abstract class SearchTvShowEvent extends Equatable {
  const SearchTvShowEvent();
}

class OnQueryChanged extends SearchTvShowEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
