import 'package:about/about.dart';
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
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:core/presentation/pages/home_tv_show_page.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/pages/now_playing_tv_show_page.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:core/presentation/pages/popular_tv_show_page.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/top_rated_tv_show_page.dart';
import 'package:core/presentation/pages/tv_show_detail_page.dart';
import 'package:core/presentation/pages/tv_show_watchlist_page.dart';
import 'package:core/presentation/pages/watchlist_movies_page.dart';
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
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_tv_show_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:search/presentation/pages/tv_show_search_page.dart';
import 'package:search/presentation/provider/movie_search_notifier.dart';
import 'package:search/presentation/provider/tv_show_search_notifier.dart';

import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSslPinning.init();
  await Firebase.initializeApp();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<MovieSearchNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularMoviesNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistMovieNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TvShowListNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<NowPlayingTvShowNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedTvShowNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<PopularTvShowNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvShowSearchNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvShowDetailNotifier>()),
        ChangeNotifierProvider(
            create: (_) => di.locator<TvShowWatchlistNotifier>()),
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMovieCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMovieCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedMovieCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailCubit>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationCubit>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistStatusCubit>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistCubit>()),
        BlocProvider(create: (_) => di.locator<SearchTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingTvShowCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTvShowCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvShowCubit>()),
        BlocProvider(create: (_) => di.locator<TvShowDetailCubit>()),
        BlocProvider(create: (_) => di.locator<TvShowRecommendationCubit>()),
        BlocProvider(create: (_) => di.locator<TvShowWatchlistStatusCubit>()),
        BlocProvider(create: (_) => di.locator<TvShowWatchlistCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(
            secondary: kMikadoYellow,
          ),
        ),
        home: HomeMoviePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case homeTvShowRoute:
              return MaterialPageRoute(builder: (_) => HomeTvShowPage());
            case popularMovieRoute:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case topRatedMovieRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case searchMovieRoute:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case watchlistMovieRoute:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case nowPlayingTvShowRoute:
              return MaterialPageRoute(builder: (_) => NowPlayingTvShowPage());
            case popularTvShowRoute:
              return MaterialPageRoute(builder: (_) => PopularTvShowPage());
            case topRatedTvShowRoute:
              return MaterialPageRoute(builder: (_) => TopRatedTvShowPage());
            case searchTvShowRoute:
              return MaterialPageRoute(builder: (_) => TvShowSearchPage());
            case watchlistTvShowRoute:
              return MaterialPageRoute(builder: (_) => TvShowWatchlistPage());
            case tvShowDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: Center(
                          child: Text('Page not found :('),
                        ),
                      ));
          }
        },
      ),
    );
  }
}
