import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_now_playing_tv_show.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'now_playing_tv_show_state.dart';

class NowPlayingTvShowCubit extends Cubit<NowPlayingTvShowState> {
  final GetNowPlayingTvShow _getNowPlayingTvShow;

  NowPlayingTvShowCubit(this._getNowPlayingTvShow)
      : super(NowPlayingTvShowInitial());

  void resetState() {
    emit(NowPlayingTvShowInitial());
  }

  void getAll() async {
    emit(NowPlayingTvShowLoading());

    final _result = await _getNowPlayingTvShow.execute();

    _result.fold(
      (failure) {
        emit(NowPlayingTvShowError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(NowPlayingTvShowHasData(data));
        } else {
          emit(const NowPlayingTvShowError('TV Show not found.'));
        }
      },
    );
  }
}
