import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TvShowRepository {
  Future<Either<Failure, List<TvShow>>> getNowPlaying();
  Future<Either<Failure, List<TvShow>>> getPopular();
  Future<Either<Failure, List<TvShow>>> getTopRated();
  Future<Either<Failure, List<TvShow>>> search(String query);
  Future<Either<Failure, TvShowDetail>> getDetail(int id);
  Future<Either<Failure, List<TvShow>>> getRecommendations(int id);
  Future<Either<Failure, String>> saveWatchlist(TvShowDetail tvShow);
  Future<Either<Failure, String>> removeWatchlist(TvShowDetail tvShow);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvShow>>> getWatchlist();
}
