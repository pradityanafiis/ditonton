import 'package:core/presentation/cubit/tv_show/watchlist/tv_show_watchlist_cubit.dart';
import 'package:core/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvShowWatchlistPage extends StatefulWidget {
  const TvShowWatchlistPage({Key? key}) : super(key: key);

  @override
  _TvShowWatchlistPageState createState() => _TvShowWatchlistPageState();
}

class _TvShowWatchlistPageState extends State<TvShowWatchlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowWatchlistCubit>().fetchWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Show Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvShowWatchlistCubit, TvShowWatchlistState>(
          builder: (ctx, state) {
            if (state is TvShowWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowWatchlistLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) => TvShowCard(state.data[index]),
                itemCount: state.data.length,
              );
            } else if (state is TvShowWatchlistError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
