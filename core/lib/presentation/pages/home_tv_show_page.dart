import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/presentation/cubit/tv_show/now_playing/now_playing_tv_show_cubit.dart';
import 'package:core/presentation/cubit/tv_show/popular/popular_tv_show_cubit.dart';
import 'package:core/presentation/cubit/tv_show/top_rated/top_rated_tv_show_cubit.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/constants.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeTvShowPage extends StatefulWidget {
  const HomeTvShowPage({Key? key}) : super(key: key);

  @override
  _HomeTvShowPageState createState() => _HomeTvShowPageState();
}

class _HomeTvShowPageState extends State<HomeTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTvShowCubit>().getAll();
      context.read<PopularTvShowCubit>().getAll();
      context.read<TopRatedTvShowCubit>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(context, homeMovieRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv),
              title: const Text('TV Show'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, watchlistMovieRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('TV Show Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, watchlistTvShowRoute);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchTvShowRoute);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Now Playing',
              onTap: () => Navigator.pushNamed(context, nowPlayingTvShowRoute),
            ),
            BlocBuilder<NowPlayingTvShowCubit, NowPlayingTvShowState>(
              builder: (context, state) {
                if (state is NowPlayingTvShowLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingTvShowHasData) {
                  return TvShowList(state.data);
                } else if (state is NowPlayingTvShowError) {
                  return Text(state.message);
                }

                return const SizedBox.shrink();
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularTvShowRoute),
            ),
            BlocBuilder<PopularTvShowCubit, PopularTvShowState>(
              builder: (context, state) {
                if (state is PopularTvShowLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvShowHasData) {
                  return TvShowList(state.data);
                } else if (state is PopularTvShowError) {
                  return Text(state.message);
                }

                return const SizedBox.shrink();
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedTvShowRoute),
            ),
            BlocBuilder<TopRatedTvShowCubit, TopRatedTvShowState>(
              builder: (context, state) {
                if (state is TopRatedTvShowLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvShowHasData) {
                  return TvShowList(state.data);
                } else if (state is TopRatedTvShowError) {
                  return Text(state.message);
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kHeading6,
          ),
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Text('See More'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ],
      );
}

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShowList;

  const TvShowList(this.tvShowList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: tvShowList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final _tvShow = tvShowList[index];

          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  tvShowDetailRoute,
                  arguments: _tvShow.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${_tvShow.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
