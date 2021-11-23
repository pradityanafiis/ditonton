import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:core/domain/usecases/base_tv_show.dart';

class GetTvShowWatchlistStatus extends BaseTvShow {
  GetTvShowWatchlistStatus(TvShowRepository repository) : super(repository);

  Future<bool> execute(int id) async => repository.isAddedToWatchlist(id);
}
