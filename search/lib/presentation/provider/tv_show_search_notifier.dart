import 'package:core/domain/entities/tv_show.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:search/domain/usecases/search_tv_show.dart';

class TvShowSearchNotifier extends ChangeNotifier {
  final SearchTvShow searchTvShow;

  TvShowSearchNotifier({required this.searchTvShow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShow = [];
  List<TvShow> get tvShow => _tvShow;

  String _message = '';
  String get message => _message;

  String _query = '';
  String get query => _query;

  void resetState() {
    _state = RequestState.Empty;
    _tvShow.clear();
    _message = '';
    _query = '';
  }

  Future<void> fetchTvShowSearch(String query) async {
    _query = query;
    _state = RequestState.Loading;
    notifyListeners();

    final _result = await searchTvShow.execute(query);

    _result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
      },
      (tvShowData) {
        _tvShow = tvShowData
            .where((element) =>
                element.posterPath != null &&
                element.overview != null &&
                element.overview != '')
            .toList();
        _state = RequestState.Loaded;
      },
    );

    notifyListeners();
  }
}
