import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_tv_show_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';

class TvShowWatchlistNotifier extends ChangeNotifier {
  final GetTvShowWatchlist getTvShowWatchlist;

  TvShowWatchlistNotifier({required this.getTvShowWatchlist});

  List<TvShow> _tvShowList = [];
  List<TvShow> get tvShowList => _tvShowList;

  RequestState _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getTvShowWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
      },
      (tvShowData) {
        if (tvShowList.isEmpty) _message = 'Your watchlist is empty.';
        _watchlistState = RequestState.Loaded;
        _tvShowList = tvShowData;
      },
    );

    notifyListeners();
  }
}
