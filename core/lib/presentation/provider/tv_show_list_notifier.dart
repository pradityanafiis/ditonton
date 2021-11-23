import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_now_playing_tv_show.dart';
import 'package:core/domain/usecases/get_popular_tv_show.dart';
import 'package:core/domain/usecases/get_top_rated_tv_show.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

class TvShowListNotifier extends ChangeNotifier {
  List<TvShow> _nowPlayingTvShow = [];
  List<TvShow> get nowPlayingTvShow => _nowPlayingTvShow;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  List<TvShow> _popularTvShow = [];
  List<TvShow> get popularTvShow => _popularTvShow;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  List<TvShow> _topRatedTvShow = [];
  List<TvShow> get topRatedTvShow => _topRatedTvShow;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  final GetNowPlayingTvShow getNowPlayingTvShow;
  final GetPopularTvShow getPopularTvShow;
  final GetTopRatedTvShow getTopRatedTvShow;

  TvShowListNotifier({
    required this.getNowPlayingTvShow,
    required this.getPopularTvShow,
    required this.getTopRatedTvShow,
  });

  Future<void> fetchNowPlaying() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final _result = await getNowPlayingTvShow.execute();
    _result.fold(
      (failure) {
        _nowPlayingState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowData) {
        _nowPlayingState = RequestState.Loaded;
        _nowPlayingTvShow = tvShowData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopular() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final _result = await getPopularTvShow.execute();
    _result.fold(
      (failure) {
        _popularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowData) {
        _popularState = RequestState.Loaded;
        _popularTvShow = tvShowData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRated() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final _result = await getTopRatedTvShow.execute();
    _result.fold(
      (failure) {
        _topRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowData) {
        _topRatedState = RequestState.Loaded;
        _topRatedTvShow = tvShowData;
        notifyListeners();
      },
    );
  }
}
