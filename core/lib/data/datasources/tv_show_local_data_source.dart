import 'package:core/data/models/tv_show_table.dart';
import 'package:core/utils/exception.dart';

import 'db/database_helper.dart';

abstract class TvShowLocalDataSource {
  Future<String> insertWatchlist(TvShowTable tvShowTable);
  Future<String> removeWatchlist(TvShowTable tvShowTable);
  Future<TvShowTable?> getTvShowById(int id);
  Future<List<TvShowTable>> getTvShowWatchlist();
}

class TvShowLocalDataSourceImpl implements TvShowLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvShowLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TvShowTable tvShowTable) async {
    try {
      await databaseHelper.insertTvShowWatchlist(tvShowTable);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvShowTable tvShowTable) async {
    try {
      await databaseHelper.removeTvShowWatchlist(tvShowTable);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvShowTable?> getTvShowById(int id) async {
    final result = await databaseHelper.getTvShowById(id);
    if (result != null) {
      return TvShowTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvShowTable>> getTvShowWatchlist() async {
    final result = await databaseHelper.getTvShowWatchlist();
    return result.map((data) => TvShowTable.fromMap(data)).toList();
  }
}
