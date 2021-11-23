import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'movie_watchlist_status_state.dart';

class MovieWatchlistStatusCubit extends Cubit<MovieWatchlistStatusState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieWatchlistStatusCubit({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistStatusInitial());

  void fetchWatchlistStatus(int id) async {
    final _isAdded = await getWatchListStatus.execute(id);

    if (_isAdded) {
      emit(MovieWatchlistStatusAdded());
    } else {
      emit(MovieWatchlistStatusNotAdded());
    }
  }

  void addToWatchlist(MovieDetail data) async {
    final _result = await saveWatchlist.execute(data);

    _result.fold(
      (failure) {
        emit(MovieWatchlistStatusNotAdded(message: failure.message));
      },
      (success) {
        emit(MovieWatchlistStatusAdded(message: success));
      },
    );
  }

  void removeFromWatchlist(MovieDetail data) async {
    final _result = await removeWatchlist.execute(data);

    _result.fold(
      (failure) {
        emit(MovieWatchlistStatusAdded(message: failure.message));
      },
      (success) {
        emit(MovieWatchlistStatusNotAdded(message: success));
      },
    );
  }
}
