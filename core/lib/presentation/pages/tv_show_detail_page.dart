import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/presentation/cubit/tv_show/detail/tv_show_detail_cubit.dart';
import 'package:core/presentation/cubit/tv_show/recommendation/tv_show_recommendation_cubit.dart';
import 'package:core/presentation/cubit/tv_show/watchlist/tv_show_watchlist_cubit.dart';
import 'package:core/presentation/cubit/tv_show/watchlist_status/tv_show_watchlist_status_cubit.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvShowDetailPage extends StatefulWidget {
  final int id;

  const TvShowDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _TvShowDetailPageState createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TvShowDetailCubit>().getDetail(widget.id);
      context.read<TvShowRecommendationCubit>().fetchRecommendation(widget.id);
      context
          .read<TvShowWatchlistStatusCubit>()
          .fetchWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvShowDetailCubit, TvShowDetailState>(
        builder: (ctx, state) {
          if (state is TvShowDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvShowDetailLoaded) {
            return SafeArea(
              child: DetailContent(
                tvShow: state.data,
                isAddedToWatchlist: false,
              ),
            );
          } else if (state is TvShowDetailError) {
            return Text(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvShowDetail tvShow;
  final bool isAddedToWatchlist;

  const DetailContent({
    Key? key,
    required this.tvShow,
    required this.isAddedToWatchlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (ctx, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvShow.name,
                              style: kHeading5,
                            ),
                            _watchlistButton(tvShow),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShow.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShow.voteAverage / 2}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvShow.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _recommendationsWidget(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _watchlistButton(TvShowDetail data) =>
      BlocConsumer<TvShowWatchlistStatusCubit, TvShowWatchlistStatusState>(
        listener: (context, state) {
          if (state is TvShowWatchlistStatusAdded && state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar
              ..showSnackBar(SnackBar(content: Text(state.message!)));
          }

          if (state is TvShowWatchlistStatusNotAdded && state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar
              ..showSnackBar(SnackBar(content: Text(state.message!)));
          }

          context.read<TvShowWatchlistCubit>().fetchWatchlist();
        },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () async {
              if (state is TvShowWatchlistStatusAdded) {
                context
                    .read<TvShowWatchlistStatusCubit>()
                    .removeFromWatchlist(data);
              } else {
                context.read<TvShowWatchlistStatusCubit>().addToWatchlist(data);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                state is TvShowWatchlistStatusAdded
                    ? const Icon(Icons.check)
                    : const Icon(Icons.add),
                const Text('Watchlist'),
              ],
            ),
          );
        },
      );

  Widget _recommendationsWidget() =>
      BlocBuilder<TvShowRecommendationCubit, TvShowRecommendationState>(
        builder: (ctx, state) {
          if (state is TvShowRecommendationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvShowRecommendationLoaded) {
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final TvShow _tvShow = state.data[index];

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          tvShowDetailRoute,
                          arguments: _tvShow.id,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${_tvShow.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: state.data.length,
              ),
            );
          } else if (state is TvShowRecommendationError) {
            return Text(state.message);
          }

          return const SizedBox.shrink();
        },
      );
}
