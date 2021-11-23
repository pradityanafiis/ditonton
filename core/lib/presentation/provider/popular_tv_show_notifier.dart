import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_popular_tv_show.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

class PopularTvShowNotifier extends ChangeNotifier {
  final GetPopularTvShow getPopularTvShow;

  PopularTvShowNotifier({required this.getPopularTvShow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShow = [];
  List<TvShow> get tvShow => _tvShow;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvShow() async {
    _state = RequestState.Loading;
    notifyListeners();

    final _result = await getPopularTvShow.execute();

    _result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
      },
      (tvShowData) {
        _tvShow = tvShowData;
        _state = RequestState.Loaded;
      },
    );

    notifyListeners();
  }
}
