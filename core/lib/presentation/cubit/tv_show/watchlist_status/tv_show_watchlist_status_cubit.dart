import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/usecases/get_tv_show_watchlist_status.dart';
import 'package:core/domain/usecases/remove_tv_show_watchlist.dart';
import 'package:core/domain/usecases/save_tv_show_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_show_watchlist_status_state.dart';

class TvShowWatchlistStatusCubit extends Cubit<TvShowWatchlistStatusState> {
  final GetTvShowWatchlistStatus _getTvShowWatchlistStatus;
  final SaveTvShowWatchlist _saveTvShowWatchlist;
  final RemoveTvShowWatchlist _removeTvShowWatchlist;

  TvShowWatchlistStatusCubit(
    this._getTvShowWatchlistStatus,
    this._saveTvShowWatchlist,
    this._removeTvShowWatchlist,
  ) : super(TvShowWatchlistStatusInitial());

  void fetchWatchlistStatus(int id) async {
    final _isAdded = await _getTvShowWatchlistStatus.execute(id);

    if (_isAdded) {
      emit(TvShowWatchlistStatusAdded());
    } else {
      emit(TvShowWatchlistStatusNotAdded());
    }
  }

  void addToWatchlist(TvShowDetail data) async {
    final _result = await _saveTvShowWatchlist.execute(data);

    _result.fold(
      (failure) {
        emit(TvShowWatchlistStatusNotAdded(message: failure.message));
      },
      (success) {
        emit(TvShowWatchlistStatusAdded(message: success));
      },
    );
  }

  void removeFromWatchlist(TvShowDetail data) async {
    final _result = await _removeTvShowWatchlist.execute(data);

    _result.fold(
      (failure) {
        emit(TvShowWatchlistStatusAdded(message: failure.message));
      },
      (success) {
        emit(TvShowWatchlistStatusNotAdded(message: success));
      },
    );
  }
}
