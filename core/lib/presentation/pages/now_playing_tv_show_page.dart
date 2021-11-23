import 'package:core/presentation/cubit/tv_show/now_playing/now_playing_tv_show_cubit.dart';
import 'package:core/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class NowPlayingTvShowPage extends StatefulWidget {
  const NowPlayingTvShowPage({Key? key}) : super(key: key);

  @override
  _NowPlayingTvShowPageState createState() => _NowPlayingTvShowPageState();
}

class _NowPlayingTvShowPageState extends State<NowPlayingTvShowPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NowPlayingTvShowCubit>().getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing TV Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvShowCubit, NowPlayingTvShowState>(
          builder: (context, state) {
            if (state is NowPlayingTvShowLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvShowHasData) {
              return ListView.builder(
                itemBuilder: (context, index) => TvShowCard(state.data[index]),
                itemCount: state.data.length,
              );
            } else if (state is NowPlayingTvShowError) {
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
