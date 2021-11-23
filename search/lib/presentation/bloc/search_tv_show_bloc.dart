import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_tv_show.dart';

part 'search_tv_show_event.dart';
part 'search_tv_show_state.dart';

class SearchTvShowBloc extends Bloc<SearchTvShowEvent, SearchTvShowState> {
  final SearchTvShow _searchTvShow;

  SearchTvShowBloc(this._searchTvShow) : super(SearchEmpty()) {
    EventTransformer<SearchEvent> _debounce<SearchEvent>(Duration duration) {
      return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
    }

    on<OnQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );
  }

  void _onQueryChanged(
      OnQueryChanged event, Emitter<SearchTvShowState> emit) async {
    final _query = event.query;

    emit(SearchLoading());

    final _result = await _searchTvShow.execute(_query);

    _result.fold(
      (failure) {
        emit(SearchError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(SearchHasData(data));
        } else {
          emit(SearchError(
              '"$_query" not found. Please try to find another title.'));
        }
      },
    );
  }
}
