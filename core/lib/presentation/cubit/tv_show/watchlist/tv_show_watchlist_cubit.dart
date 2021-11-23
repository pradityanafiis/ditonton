import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_tv_show_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_show_watchlist_state.dart';

class TvShowWatchlistCubit extends Cubit<TvShowWatchlistState> {
  final GetTvShowWatchlist _getTvShowWatchlist;

  TvShowWatchlistCubit(this._getTvShowWatchlist)
      : super(TvShowWatchlistInitial());

  void fetchWatchlist() async {
    emit(TvShowWatchlistLoading());

    final _result = await _getTvShowWatchlist.execute();

    _result.fold(
      (failure) {
        emit(TvShowWatchlistError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(TvShowWatchlistLoaded(data));
        } else {
          emit(TvShowWatchlistError('Your TV show watchlist is empty.'));
        }
      },
    );
  }
}
