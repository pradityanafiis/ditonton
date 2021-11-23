import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/usecases/get_tv_show_detail.dart';
import 'package:core/domain/usecases/get_tv_show_recommendations.dart';
import 'package:core/domain/usecases/get_tv_show_watchlist_status.dart';
import 'package:core/domain/usecases/remove_tv_show_watchlist.dart';
import 'package:core/domain/usecases/save_tv_show_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

class TvShowDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvShowDetail getTvShowDetail;
  final GetTvShowRecommendations getTvShowRecommendations;
  final GetTvShowWatchlistStatus getTvShowWatchlistStatus;
  final SaveTvShowWatchlist saveTvShowWatchlist;
  final RemoveTvShowWatchlist removeTvShowWatchlist;

  TvShowDetailNotifier({
    required this.getTvShowDetail,
    required this.getTvShowRecommendations,
    required this.getTvShowWatchlistStatus,
    required this.saveTvShowWatchlist,
    required this.removeTvShowWatchlist,
  });

  late TvShowDetail _tvShowDetail;
  TvShowDetail get tvShowDetail => _tvShowDetail;

  RequestState _detailState = RequestState.Empty;
  RequestState get detailState => _detailState;

  List<TvShow> _recommendations = [];
  List<TvShow> get recommendations => _recommendations;

  RequestState _recommendationsState = RequestState.Empty;
  RequestState get recommendationsState => _recommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchDetail(int id) async {
    _detailState = RequestState.Loading;
    _recommendationsState = RequestState.Loading;
    notifyListeners();

    final _detailResult = await getTvShowDetail.execute(id);
    final _recommendationsResult = await getTvShowRecommendations.execute(id);

    _detailResult.fold(
      (failure) {
        _detailState = RequestState.Error;
        _message = failure.message;
      },
      (tvShowDetail) {
        _tvShowDetail = tvShowDetail;
        _detailState = RequestState.Loaded;
      },
    );

    _recommendationsResult.fold(
      (failure) {
        _recommendationsState = RequestState.Error;
        _message = failure.message;
      },
      (tvShowRecommendations) {
        _recommendations = tvShowRecommendations;
        _recommendationsState = RequestState.Loaded;
      },
    );

    notifyListeners();
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvShowDetail tvShow) async {
    final result = await saveTvShowWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TvShowDetail tvShow) async {
    final result = await removeTvShowWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getTvShowWatchlistStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
