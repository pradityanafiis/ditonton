import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_show_local_data_source.dart';
import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_show_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_now_playing_tv_show.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_popular_tv_show.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_top_rated_tv_show.dart';
import 'package:core/domain/usecases/get_tv_show_detail.dart';
import 'package:core/domain/usecases/get_tv_show_recommendations.dart';
import 'package:core/domain/usecases/get_tv_show_watchlist.dart';
import 'package:core/domain/usecases/get_tv_show_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_tv_show_watchlist.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_tv_show_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/cubit/movie/detail/movie_detail_cubit.dart';
import 'package:core/presentation/cubit/movie/now_playing/now_playing_movie_cubit.dart';
import 'package:core/presentation/cubit/movie/popular/popular_movie_cubit.dart';
import 'package:core/presentation/cubit/movie/recommendation/movie_recommendation_cubit.dart';
import 'package:core/presentation/cubit/movie/top_rated/top_rated_movie_cubit.dart';
import 'package:core/presentation/cubit/movie/watchlist/movie_watchlist_cubit.dart';
import 'package:core/presentation/cubit/movie/watchlist_status/movie_watchlist_status_cubit.dart';
import 'package:core/presentation/cubit/tv_show/detail/tv_show_detail_cubit.dart';
import 'package:core/presentation/cubit/tv_show/now_playing/now_playing_tv_show_cubit.dart';
import 'package:core/presentation/cubit/tv_show/popular/popular_tv_show_cubit.dart';
import 'package:core/presentation/cubit/tv_show/recommendation/tv_show_recommendation_cubit.dart';
import 'package:core/presentation/cubit/tv_show/top_rated/top_rated_tv_show_cubit.dart';
import 'package:core/presentation/cubit/tv_show/watchlist/tv_show_watchlist_cubit.dart';
import 'package:core/presentation/cubit/tv_show/watchlist_status/tv_show_watchlist_status_cubit.dart';
import 'package:core/presentation/provider/movie_detail_notifier.dart';
import 'package:core/presentation/provider/movie_list_notifier.dart';
import 'package:core/presentation/provider/now_playing_tv_show_notifier.dart';
import 'package:core/presentation/provider/popular_movies_notifier.dart';
import 'package:core/presentation/provider/popular_tv_show_notifier.dart';
import 'package:core/presentation/provider/top_rated_movies_notifier.dart';
import 'package:core/presentation/provider/top_rated_tv_show_notifier.dart';
import 'package:core/presentation/provider/tv_show_detail_notifier.dart';
import 'package:core/presentation/provider/tv_show_list_notifier.dart';
import 'package:core/presentation/provider/tv_show_watchlist_notifier.dart';
import 'package:core/presentation/provider/watchlist_movie_notifier.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:get_it/get_it.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv_show.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_tv_show_bloc.dart';
import 'package:search/presentation/provider/movie_search_notifier.dart';
import 'package:search/presentation/provider/tv_show_search_notifier.dart';

final GetIt locator = GetIt.instance;

void init() {
  // PROVIDER
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(searchMovies: locator()),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(locator()),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(getWatchlistMovies: locator()),
  );
  locator.registerFactory(
    () => TvShowListNotifier(
      getNowPlayingTvShow: locator(),
      getPopularTvShow: locator(),
      getTopRatedTvShow: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvShowNotifier(getPopularTvShow: locator()),
  );
  locator.registerFactory(
    () => TopRatedTvShowNotifier(getTopRatedTvShow: locator()),
  );
  locator.registerFactory(
    () => NowPlayingTvShowNotifier(getNowPlayingTvShow: locator()),
  );
  locator.registerFactory(
    () => TvShowSearchNotifier(searchTvShow: locator()),
  );
  locator.registerFactory(
    () => TvShowDetailNotifier(
      getTvShowDetail: locator(),
      getTvShowRecommendations: locator(),
      getTvShowWatchlistStatus: locator(),
      saveTvShowWatchlist: locator(),
      removeTvShowWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvShowWatchlistNotifier(getTvShowWatchlist: locator()),
  );

  // MOVIE BLOC/CUBIT
  locator.registerFactory(
    () => SearchBloc(locator()),
  );
  locator.registerFactory(
    () => NowPlayingMovieCubit(locator()),
  );
  locator.registerFactory(
    () => PopularMovieCubit(locator()),
  );
  locator.registerFactory(
    () => TopRatedMovieCubit(locator()),
  );
  locator.registerFactory(
    () => MovieDetailCubit(locator()),
  );
  locator.registerFactory(
    () => MovieRecommendationCubit(locator()),
  );
  locator.registerFactory(
    () => MovieWatchlistStatusCubit(
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieWatchlistCubit(locator()),
  );

  // TV SHOW BLOC/CUBIT
  locator.registerFactory(
    () => SearchTvShowBloc(locator()),
  );
  locator.registerFactory(
    () => NowPlayingTvShowCubit(locator()),
  );
  locator.registerFactory(
    () => PopularTvShowCubit(locator()),
  );
  locator.registerFactory(
    () => TopRatedTvShowCubit(locator()),
  );
  locator.registerFactory(
    () => TvShowDetailCubit(locator()),
  );
  locator.registerFactory(
    () => TvShowRecommendationCubit(locator()),
  );
  locator.registerFactory(
    () => TvShowWatchlistStatusCubit(locator(), locator(), locator()),
  );
  locator.registerFactory(
    () => TvShowWatchlistCubit(locator()),
  );

  // MOVIES USE CASE
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // TV SHOW USE CASE
  locator.registerLazySingleton(() => GetNowPlayingTvShow(locator()));
  locator.registerLazySingleton(() => GetPopularTvShow(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShow(locator()));
  locator.registerLazySingleton(() => SearchTvShow(locator()));
  locator.registerLazySingleton(() => GetTvShowRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => SaveTvShowWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvShowWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvShowWatchlistStatus(locator()));
  locator.registerLazySingleton(() => GetTvShowWatchlist(locator()));

  // REPOSITORIES
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // DATA SOURCES
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvShowRemoteDataSource>(
      () => TvShowRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
      () => TvShowLocalDataSourceImpl(databaseHelper: locator()));

  // HELPER
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // EXTERNAL
  // locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => HttpSslPinning.client);
}
