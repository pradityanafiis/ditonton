import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:core/domain/usecases/base_tv_show.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class RemoveTvShowWatchlist extends BaseTvShow {
  RemoveTvShowWatchlist(TvShowRepository repository) : super(repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShowDetail) =>
      repository.removeWatchlist(tvShowDetail);
}
