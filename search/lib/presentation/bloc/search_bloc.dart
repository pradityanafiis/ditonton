import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_movies.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchEmpty()) {
    EventTransformer<SearchEvent> _debounce<SearchEvent>(Duration duration) {
      return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
    }

    on<OnQueryChanged>(
      _onQueryChanged,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );
  }

  void _onQueryChanged(OnQueryChanged event, Emitter<SearchState> emit) async {
    final _query = event.query;

    emit(SearchLoading());

    final _result = await _searchMovies.execute(_query);

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
